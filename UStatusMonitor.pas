unit UStatusMonitor;

{ Monitor de disponibilidade para o semaforo da tela principal.

  Verifica duas coisas, cada uma em sua propria thread:
    - o banco MySQL  (SELECT 1)
    - o servico de NF-e da SEFAZ (StatusServico do ACBr)

  REGRA NUMERO UM: nada aqui pode travar a aplicacao.

  Por isso as threads NAO chamam a interface - nem por Synchronize. Elas
  escrevem o resultado num registro protegido por critical section, e o form
  le esse registro no seu proprio TTimer. Assim:

    - nenhuma thread toca componente visual (nao ha risco de tocar um form ja
      destruido);
    - se uma verificacao demorar ou travar, o form simplesmente continua lendo
      o ultimo resultado conhecido e, passado o prazo do watchdog, mostra
      "desconhecido" (cinza) - sem esperar por ninguem;
    - cada thread tem conexao/instancia PROPRIA. Nada de reaproveitar
      Modulo.ZConexao (nao e thread-safe e roubaria a conexao da interface)
      nem o ACBrNFe1 do FNf.

  Uso:
      MonitorStatus.IniciarBanco;      // dispara se ja nao houver uma rodando
      MonitorStatus.IniciarNFe(2);     // 1=producao 2=homologacao
      Info := MonitorStatus.LerBanco;  // no OnTimer do form
}

interface

uses
  Windows, SysUtils, Classes, SyncObjs, IniFiles, DateUtils,
  ZConnection, ZDataset;

type
  { Cinza = nao sei (ainda nao verifiquei, ou a verificacao nao voltou a tempo) }
  TStatusNivel = (snDesconhecido, snOk, snAtencao, snFalha);

  TStatusInfo = record
    Nivel     : TStatusNivel;
    Titulo    : string;      { linha 1 do hint }
    Detalhe   : string;      { linha 2 do hint }
    Quando    : TDateTime;   { horario da ultima resposta }
    Verificado: Boolean;     { ja houve ao menos uma resposta? }
  end;

  TMonitorStatus = class
  private
    FLock          : TCriticalSection;
    FBanco         : TStatusInfo;
    FNFe           : TStatusInfo;
    FBancoRodando  : Boolean;
    FNFeRodando    : Boolean;
    FBancoInicio   : TDateTime;
    FNFeInicio     : TDateTime;
    procedure GravarBanco(const Info: TStatusInfo);
    procedure GravarNFe(const Info: TStatusInfo);
  public
    constructor Create;
    destructor  Destroy; override;

    procedure IniciarBanco;
    procedure IniciarNFe(const Ambiente: string);

    function  LerBanco: TStatusInfo;
    function  LerNFe: TStatusInfo;

    { True quando a thread passou do prazo aceitavel - o form usa isso para
      cair para cinza em vez de continuar mostrando um estado velho. }
    function  BancoTravado(SegundosLimite: Integer): Boolean;
    function  NFeTravado(SegundosLimite: Integer): Boolean;
  end;

var
  MonitorStatus: TMonitorStatus;

implementation

uses
  ACBrNFe, pcnConversao, ACBrDFeSSL;

type
  TThreadBanco = class(TThread)
  private
    FInfo: TStatusInfo;
  protected
    procedure Execute; override;
  end;

  TThreadNFe = class(TThread)
  private
    FAmbiente: string;
    FInfo: TStatusInfo;
  protected
    procedure Execute; override;
  end;

// ---------------------------------------------------------------------------
// TMonitorStatus
// ---------------------------------------------------------------------------

constructor TMonitorStatus.Create;
begin
  inherited Create;
  FLock := TCriticalSection.Create;
  FillChar(FBanco, SizeOf(FBanco), 0);
  FillChar(FNFe,   SizeOf(FNFe),   0);
  FBanco.Nivel := snDesconhecido;
  FNFe.Nivel   := snDesconhecido;
end;

destructor TMonitorStatus.Destroy;
begin
  { As threads sao FreeOnTerminate e nao referenciam este objeto apos gravar.
    Se alguma ainda estiver viva no encerramento, o processo termina junto. }
  FLock.Free;
  inherited;
end;

procedure TMonitorStatus.GravarBanco(const Info: TStatusInfo);
begin
  FLock.Acquire;
  try
    FBanco := Info;
    FBancoRodando := False;
  finally
    FLock.Release;
  end;
end;

procedure TMonitorStatus.GravarNFe(const Info: TStatusInfo);
begin
  FLock.Acquire;
  try
    FNFe := Info;
    FNFeRodando := False;
  finally
    FLock.Release;
  end;
end;

function TMonitorStatus.LerBanco: TStatusInfo;
begin
  FLock.Acquire;
  try Result := FBanco; finally FLock.Release; end;
end;

function TMonitorStatus.LerNFe: TStatusInfo;
begin
  FLock.Acquire;
  try Result := FNFe; finally FLock.Release; end;
end;

function TMonitorStatus.BancoTravado(SegundosLimite: Integer): Boolean;
begin
  FLock.Acquire;
  try
    Result := FBancoRodando and
              (SecondsBetween(Now, FBancoInicio) > SegundosLimite);
  finally
    FLock.Release;
  end;
end;

function TMonitorStatus.NFeTravado(SegundosLimite: Integer): Boolean;
begin
  FLock.Acquire;
  try
    Result := FNFeRodando and
              (SecondsBetween(Now, FNFeInicio) > SegundosLimite);
  finally
    FLock.Release;
  end;
end;

procedure TMonitorStatus.IniciarBanco;
var T: TThreadBanco;
begin
  FLock.Acquire;
  try
    if FBancoRodando then Exit;   { ja tem uma em andamento - nao empilha }
    FBancoRodando := True;
    FBancoInicio  := Now;
  finally
    FLock.Release;
  end;

  T := TThreadBanco.Create(True);
  T.FreeOnTerminate := True;
  T.Priority := tpLower;   { nunca disputar CPU com a interface }
  T.Resume;
end;

procedure TMonitorStatus.IniciarNFe(const Ambiente: string);
var T: TThreadNFe;
begin
  FLock.Acquire;
  try
    if FNFeRodando then Exit;
    FNFeRodando := True;
    FNFeInicio  := Now;
  finally
    FLock.Release;
  end;

  T := TThreadNFe.Create(True);
  T.FAmbiente := Ambiente;
  T.FreeOnTerminate := True;
  T.Priority := tpLower;
  T.Resume;
end;

// ---------------------------------------------------------------------------
// TThreadBanco — SELECT 1 numa conexao propria
// ---------------------------------------------------------------------------

procedure TThreadBanco.Execute;
var
  Con  : TZConnection;
  Q    : TZQuery;
  Ini  : TIniFile;
  T0   : Cardinal;
  Ms   : Cardinal;
  Versao, Banco: string;
begin
  FillChar(FInfo, SizeOf(FInfo), 0);
  FInfo.Nivel      := snFalha;
  FInfo.Titulo     := 'Banco de dados indisponivel';
  FInfo.Quando     := Now;
  FInfo.Verificado := True;

  Con := nil;
  Q   := nil;
  try
    try
      Con := TZConnection.Create(nil);
      Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'amortrat.ini');
      try
        Con.Protocol := 'mysql';
        Con.HostName := Ini.ReadString('BD', 'Host',    '');
        Con.Port     := Ini.ReadInteger('BD', 'Porta',  3306);
        Con.Database := Ini.ReadString('BD', 'Banco',   '');
        Con.User     := Ini.ReadString('BD', 'Usuario', '');
        Con.Password := Ini.ReadString('BD', 'Senha',   '');
        Banco        := Con.Database;
      finally
        Ini.Free;
      end;
      Con.Properties.Values['codepage'] := 'utf8mb4';
      Con.Properties.Values['usessl']   := 'false';
      Con.Properties.Values['MYSQL_OPT_SSL_VERIFY_SERVER_CERT'] := 'FALSE';
      { timeouts curtos: a checagem tem de responder rapido ou falhar rapido }
      Con.Properties.Values['MYSQL_OPT_CONNECT_TIMEOUT'] := '5';
      Con.Properties.Values['MYSQL_OPT_READ_TIMEOUT']    := '5';
      Con.LibraryLocation := ExtractFilePath(ParamStr(0)) + 'libmysql.dll';

      T0 := GetTickCount;
      Con.Connect;

      Q := TZQuery.Create(nil);
      Q.Connection := Con;
      Q.SQL.Text := 'SELECT VERSION() AS V';
      Q.Open;
      Versao := Q.FieldByName('V').AsString;
      Q.Close;

      Ms := GetTickCount - T0;

      FInfo.Quando  := Now;
      FInfo.Detalhe := Format('MySQL %s - %s - %d ms', [Versao, Banco, Ms]);

      if Ms <= 1000 then
      begin
        FInfo.Nivel  := snOk;
        FInfo.Titulo := 'Banco de dados operacional';
      end
      else if Ms <= 3000 then
      begin
        FInfo.Nivel  := snAtencao;
        FInfo.Titulo := 'Banco de dados lento';
      end
      else
      begin
        FInfo.Nivel  := snAtencao;
        FInfo.Titulo := 'Banco de dados muito lento';
      end;
    except
      on E: Exception do
      begin
        FInfo.Nivel   := snFalha;
        FInfo.Titulo  := 'Banco de dados indisponivel';
        FInfo.Detalhe := Copy(E.Message, 1, 120);
        FInfo.Quando  := Now;
      end;
    end;
  finally
    try if Q <> nil then Q.Free; except end;
    try
      if Con <> nil then
      begin
        if Con.Connected then Con.Disconnect;
        Con.Free;
      end;
    except end;
    MonitorStatus.GravarBanco(FInfo);
  end;
end;

// ---------------------------------------------------------------------------
// TThreadNFe — StatusServico numa instancia propria do ACBr
// ---------------------------------------------------------------------------

procedure TThreadNFe.Execute;
var
  ACBr : TACBrNFe;
  T0, Ms: Cardinal;
  Ok   : Boolean;
  cStat, TMed: Integer;
  xMotivo, UF, sAmb: string;
begin
  FillChar(FInfo, SizeOf(FInfo), 0);
  FInfo.Nivel      := snFalha;
  FInfo.Titulo     := 'Servico de NF-e indisponivel';
  FInfo.Quando     := Now;
  FInfo.Verificado := True;

  ACBr := nil;
  try
    try
      { Instancia exclusiva desta thread. O ACBr nao e thread-safe, entao
        reaproveitar o FNf.ACBrNFe1 daria corrupcao silenciosa. }
      ACBr := TACBrNFe.Create(nil);
      ACBr.Configuracoes.WebServices.UF      := 'SP';
      ACBr.Configuracoes.WebServices.Ambiente := StrToTpAmb(Ok, FAmbiente);
      ACBr.Configuracoes.WebServices.TimeOut := 12000;   { 12s - o default e 5s }
      ACBr.Configuracoes.WebServices.AguardarConsultaRet := 0;
      ACBr.Configuracoes.Geral.SSLLib        := libOpenSSL;
      ACBr.Configuracoes.Geral.SSLHttpLib    := httpOpenSSL;
      ACBr.Configuracoes.Arquivos.Salvar     := False;
      ACBr.Configuracoes.Arquivos.SalvarEvento := False;

      UF := ACBr.Configuracoes.WebServices.UF;
      if FAmbiente = '1' then sAmb := 'producao' else sAmb := 'homologacao';

      T0 := GetTickCount;
      ACBr.WebServices.StatusServico.Executar;
      Ms := GetTickCount - T0;

      cStat   := ACBr.WebServices.StatusServico.cStat;
      xMotivo := ACBr.WebServices.StatusServico.xMotivo;
      TMed    := ACBr.WebServices.StatusServico.TMed;   { tempo medio informado pela SEFAZ }

      FInfo.Quando  := Now;
      FInfo.Detalhe := Format('SEFAZ %s (%s) - cStat %d - %d ms', [UF, sAmb, cStat, Ms]);
      if TMed > 0 then
        FInfo.Detalhe := FInfo.Detalhe + Format(' - TMed %ds', [TMed]);

      case cStat of
        107:                          { Servico em Operacao }
          begin
            FInfo.Nivel  := snOk;
            FInfo.Titulo := 'NF-e em operacao';
            if Ms > 5000 then
            begin
              FInfo.Nivel  := snAtencao;
              FInfo.Titulo := 'NF-e em operacao (resposta lenta)';
            end;
          end;
        108, 109:                     { paralisacao temporaria / sem previsao }
          begin
            FInfo.Nivel  := snAtencao;
            FInfo.Titulo := 'NF-e com paralisacao temporaria';
          end;
      else
        FInfo.Nivel  := snFalha;
        FInfo.Titulo := 'NF-e fora de operacao';
      end;

      if xMotivo <> '' then
        FInfo.Detalhe := FInfo.Detalhe + ' - ' + Copy(xMotivo, 1, 80);
    except
      on E: Exception do
      begin
        FInfo.Nivel   := snFalha;
        FInfo.Titulo  := 'Servico de NF-e indisponivel';
        FInfo.Detalhe := Copy(E.Message, 1, 120);
        FInfo.Quando  := Now;
      end;
    end;
  finally
    try if ACBr <> nil then ACBr.Free; except end;
    MonitorStatus.GravarNFe(FInfo);
  end;
end;

initialization
  MonitorStatus := TMonitorStatus.Create;

finalization
  { Nao damos Free: pode haver thread em voo que ainda vai gravar aqui.
    O objeto vive ate o processo terminar - custo irrelevante e elimina
    a chance de access violation no encerramento. }

end.
