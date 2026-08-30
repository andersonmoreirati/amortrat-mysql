unit UModulo;

interface

uses
  SysUtils, Windows, Registry, Classes, ImgList, Controls, DB, Dialogs,
  ZConnection, ZDataset, IniFiles;


type
  TModulo = class(TDataModule)
    imagens: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Conexão MySQL — usada por todos os módulos migrados }
    ZConexao: TZConnection;

    { LOGIN do usuário autenticado, preenchido pelo ULogin após validar a senha.
      Antes os forms descobriam quem estava logado lendo TBUsuarioLOGIN.Value —
      o cursor BDE de tb_usuario, que precisava estar posicionado no registro
      certo. Sem cursor persistente, o login passa a viver aqui. }
    UsuarioLogado: string;

    procedure NovaLeitura;

    function RetZero(ZEROS:string;QUANT:integer):String;
    function Number(Key: Char): char;
    function MapeamentosDisponiveis():string;
    procedure ConectarRede;
    function Getcomputer : string;
  end;

var
  Modulo: TModulo;

implementation


function TModulo.Number(Key: Char): char;
begin
  case Key of
    '0'..'9': Number := Key;
    chr(08): Number := Key;
  else Number := chr(0)
  end;
end;

procedure TModulo.NovaLeitura;
{ Encerra a transação de leitura em curso, para que a PRÓXIMA consulta enxergue
  os dados mais recentes.

  Por que isso é necessário: o InnoDB roda em REPEATABLE READ. O snapshot é
  criado na primeira leitura da transação e NÃO muda até haver commit — mesmo
  relendo a tabela. Verificado no servidor:

      transação abre e lê ......... 404 registros
      (outra conexão insere 1)
      relê na MESMA transação ..... 404   <-- snapshot preso
      COMMIT e lê ................. 405   <-- só aqui aparece

  Sintoma prático: emitir um relatório, cadastrar um cliente e reemitir o
  relatório — o novo cliente não aparecia até reiniciar o sistema.

  Chamar isto ANTES de reabrir datasets de consulta/relatório. É barato: se não
  houver transação aberta, não faz nada de custoso. }
begin
  if (ZConexao = nil) or (not ZConexao.Connected) then Exit;
  try
    if not ZConexao.AutoCommit then
    begin
      // havia transação explícita em aberto (ex.: gravação interrompida)
      ZConexao.Rollback;
      ZConexao.AutoCommit := True;
    end
    else
    begin
      // AutoCommit ligado: encerra o snapshot REPEATABLE READ do InnoDB.
      // ZeosLib 8.x rejeita Commit() direto em modo AutoCommit=True
      // (CheckNonAutoCommitMode lança EZDatabaseError).
      // Solução: StartTransaction emite BEGIN explícito e ajusta os contadores
      // internos; o Commit seguinte emite COMMIT e restaura AutoCommit=True.
      ZConexao.StartTransaction;
      ZConexao.Commit;
    end;
  except
    // Não deve mais chegar aqui; mantido como fallback defensivo.
    try ZConexao.AutoCommit := True; except end;
  end;
end;

function TModulo.RetZero(ZEROS:string;QUANT:integer):String;
var
I,Tamanho:integer;
aux: string;
begin
  aux:=zeros;
  Tamanho:=length(ZEROS);
  ZEROS:='';
  for I:=1 to quant-tamanho do
  ZEROS:=ZEROS+'0';
  aux:=zeros+aux;
  RetZero:=aux;
end;
{$R *.dfm}

{ Os handlers AfterPost (TBClientes/TBPecas/TBOs/TBOs_Finalizados/TBNf) foram
  removidos junto com os TTable. Faziam FlushBuffers + DBISaveChanges, que
  forçavam o BDE a gravar o buffer no arquivo .DB em disco — nada a ver com o
  sync Paradox->MySQL, que é um processo externo (colunas sync_hash/sync_at/
  sync_origin). No MySQL cada INSERT/UPDATE já é durável no commit. }

procedure TModulo.DataModuleCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  // --- Conexão MySQL (fundação para migração progressiva) ---
  try
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'amortrat.ini');
    try
      ZConexao := TZConnection.Create(Self);
      ZConexao.Protocol  := 'mysql';
      ZConexao.HostName  := Ini.ReadString('BD', 'Host',    '');
      ZConexao.Port      := Ini.ReadInteger('BD', 'Porta',  3306);
      ZConexao.Database  := Ini.ReadString('BD', 'Banco',   '');
      ZConexao.User      := Ini.ReadString('BD', 'Usuario', '');
      ZConexao.Password  := Ini.ReadString('BD', 'Senha',   '');
      ZConexao.Properties.Values['codepage'] := 'utf8mb4';
      ZConexao.Properties.Values['usessl']   := 'false';
      ZConexao.Properties.Values['MYSQL_OPT_SSL_VERIFY_SERVER_CERT'] := 'FALSE';
      ZConexao.Properties.Values['MYSQL_OPT_RECONNECT'] := '1';  // reconexão automática se o servidor derrubar por inatividade
      ZConexao.LibraryLocation :=
        ExtractFilePath(ParamStr(0)) + 'libmysql.dll';
      ZConexao.Connected := True;
    finally
      Ini.Free;
    end;
  except
    on E: Exception do
      ShowMessage(
        'Aviso: não foi possível conectar ao MySQL.' + #13#10 +
        'Verifique o arquivo amortrat.ini.' + #13#10 + E.Message);
  end;

  { A partir daqui o DataModule é 100% MySQL.
    Removidos: os 18 TTable/5 TRxQuery Paradox, os AddPassword('99866') do
    alias BDE e os Active := True que abriam todos os cursores na abertura do
    sistema. Cada form migrado abre e fecha seus próprios TZQuery.
    ZTBUsuario/ZDSUsuario também saíram: eram andaime da fase de transição e
    nenhum form chegou a usá-los (o login autentica por TZQuery e guarda o
    resultado em UsuarioLogado). }
end;

function TModulo.MapeamentosDisponiveis():string;
var
  I : Integer;
  Caminho, Drive : String;
  Tamanho : Cardinal;
begin
  SetLength(Caminho,255);
  Tamanho:=255;
  For I:=0 to 25 do
  begin
    Drive := Chr(Ord('A')+I)+':';
    if WNetGetConnection(PChar(Drive),PChar(Caminho),Tamanho) = NO_ERROR then
       MapeamentosDisponiveis := Caminho else MapeamentosDisponiveis := 'erro';
  end;
end;

procedure TModulo.ConectarRede;
var
  NRW: TNetResource;
begin
  with NRW do
  begin
  dwType := RESOURCETYPE_ANY;
  lpLocalName := 'F:';
  lpRemoteName := '\\producao\c';
  lpProvider := '';
  end;
  WNetAddConnection2(NRW, '', '', CONNECT_UPDATE_PROFILE);
end;


function TModulo.Getcomputer : string;
var
registro : tregistry;
begin
registro:=tregistry.create;
registro.RootKey:=HKEY_LOCAL_MACHINE;
registro.openkey('System\CurrentControlSet\Services\VXD\VNETSUP',false);
result:=registro.readstring('ComputerName');
end;



end.
