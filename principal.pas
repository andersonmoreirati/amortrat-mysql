{$OPTIMIZATION ON}
unit principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, BarMenus, BcDrawModule, BcCustomDrawModule, ImgList,
  ComCtrls, AdvStatus, VrControls, VrLcd, VrLabel,
  ExtCtrls, jpeg, ShellApi, StdCtrls,
  mdTabEnter,mdShell, PkgAdvStatus, scExcelExport, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdSSLOpenSSL, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  DB, ZDataset, IdAuthentication;

    function EscapeJSON(const S: string): string;
    function AjustarString(const S: string; N: integer): string;

type
  TFPrincipal = class(TForm)
    ImageList1: TImageList;
    AdvStatus1: TAdvStatus;
    Data: TVrLabel;
    Menu: TBcBarMainMenu;
    Cadastro: TMenuItem;
    Clientes1: TMenuItem;
    Processos1: TMenuItem;
    Pecas: TMenuItem;
    Relatorios: TMenuItem;
    Sair1: TMenuItem;
    Nota: TMenuItem;
    Image1: TImage;
    Gerenciador: TMenuItem;
    VrClock1: TVrClock;
    CertificadodeQualidade1: TMenuItem;
    Preco: TMenuItem;
    Usuario: TMenuItem;
    PB: TProgressBar;
    OrdemdeServio1: TMenuItem;
    Fornecedores1: TMenuItem;
    MatriaPrima1: TMenuItem;
    scExcelExport1: TscExcelExport;
    Exportar1: TMenuItem;
    Timer1: TTimer;
    scExcelExport2: TscExcelExport;
    scExcelExport3: TscExcelExport;
    Timer2: TTimer;
    HTTP: TIdHTTP;
    IOHandler: TIdSSLIOHandlerSocketOpenSSL;
    { Queries MySQL. Os TField persistentes foram REMOVIDOS de proposito:
        - QOsCODIGO tinha Size=8, mas tb_os.CODIGO e varchar(9) ('098800/26');
          o TField truncaria o numero da OS enviado no WhatsApp (armadilha #15);
        - QOsCODIGO_1/QOsCODIGO_2 so existiam porque o BDE renomeava colunas
          duplicadas de JOIN. O MySQL nao faz isso (armadilha #7) - os SELECTs
          foram reescritos SEM as colunas duplicadas, resolvendo na raiz.
      O acesso passa a ser por FieldByName. }
    QResumo: TZQuery;
    Resumo1: TMenuItem;
    QOs: TZQuery;
    ResumoDirio1: TMenuItem;
    RankingFaturamentoMs1: TMenuItem;
    QRank: TZQuery;
    { Datasets locais que substituem os do UModulo (que continua BDE para os
      forms ainda nao migrados). Mesmo criterio adotado no UOS. }
    QConfig: TZQuery;
    QVendasGerais: TZQuery;
    QOrdensNaoFinalizadas: TZQuery;
    QPesoTotal: TZQuery;
    QOrdensDoAno: TZQuery;
    QOrdensFinalizadasDoAno: TZQuery;
    QExpClientes: TZQuery;
    QExpPecas: TZQuery;
    scExcelCliente: TscExcelExport;
    scExcelPecas: TscExcelExport;
    ControleProduo1: TMenuItem;
    PowerBI1: TMenuItem;
    scExcelOS: TscExcelExport;
    scExcelOSFinalizados: TscExcelExport;
    procedure Sair1Click(Sender: TObject);
    procedure Clientes1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Processos1Click(Sender: TObject);
    procedure PecasClick(Sender: TObject);
    procedure NotaClick(Sender: TObject);
    procedure CertificadodeQualidade1Click(Sender: TObject);
    procedure GerenciadorClick(Sender: TObject);
    procedure ESenhaEnter(Sender: TObject);
    procedure ESenhaExit(Sender: TObject);
    procedure Abertura1Click(Sender: TObject);
    procedure PrecoClick(Sender: TObject);
    procedure UsuarioClick(Sender: TObject);
    procedure NMFTP1TransactionStart(Sender: TObject);
    procedure NMFTP1TransactionStop(Sender: TObject);
    procedure NMFTP1Error(Sender: TComponent; Errno: Word; Errmsg: String);
    procedure OrdemdeServio1Click(Sender: TObject);
    procedure MatriaPrima1Click(Sender: TObject);
    procedure Fornecedores1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ResumoDirio1Click(Sender: TObject);
    procedure RankingFaturamentoMs1Click(Sender: TObject);
    procedure ControleProduo1Click(Sender: TObject);
    procedure PowerBI1Click(Sender: TObject);


  private
    { Private declarations }
    FCaptionBase: string;          { campos ANTES dos metodos - armadilha #3 }
    function  GarantirConexao: Boolean;
    function  LerConfig(CodConfig: Integer): string;
  public
  function AliasToPath(Alias : String) : String;
  function DiskInDrive(const Drive: char): Boolean;
  function Percentdisk(unidade: byte): Integer;
  Function ExecAndWait( Const FileName, Params: String; Const WindowState: Word ) : Boolean;
  function TamArquivo(Arquivo: string): Integer;

    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;

const
SHFMT_ID_DEFAULT = $FFFF;
// Formating options
SHFMT_OPT_QUICKFORMAT = $0000;
SHFMT_OPT_FULL = $0001;
SHFMT_OPT_SYSONLY = $0002;
// Error codes
SHFMT_ERROR = $FFFFFFFF;
SHFMT_CANCEL = $FFFFFFFE;
SHFMT_NOFORMAT = $FFFFFFFD;

function SHFormatDrive(Handle: HWND; Drive, ID, Options: Word): LongInt; stdcall; external 'shell32.dll' name 'SHFormatDrive'

implementation
Uses Uclientes, UModulo, UProcessos, UPecas, UOS, UNf, UGerrelat, URelatCQ,
  UReajuste, UUsuarios, URelatorios;

{$R *.dfm}

function TFPrincipal.GarantirConexao: Boolean;
{ Os TZQuery vivem no DFM, mas Modulo.ZConexao e criado em runtime e nao existe
  em design time - por isso a ligacao e feita aqui. Mesmo padrao dos demais
  forms migrados (secao 4.1 do HANDOFF). }
begin
  Result := False;
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;
  if not Modulo.ZConexao.Connected then
    try
      Modulo.ZConexao.Connect;
    except
      on E: Exception do
      begin
        Application.MessageBox(pchar('Erro de conexao: ' + E.Message),
          pchar('ERRO'), MB_OK + MB_IconError);
        Exit;
      end;
    end;

  QResumo.Connection                := Modulo.ZConexao;
  QOs.Connection                    := Modulo.ZConexao;
  QRank.Connection                  := Modulo.ZConexao;
  QConfig.Connection                := Modulo.ZConexao;
  QVendasGerais.Connection          := Modulo.ZConexao;
  QOrdensNaoFinalizadas.Connection  := Modulo.ZConexao;
  QPesoTotal.Connection             := Modulo.ZConexao;
  QOrdensDoAno.Connection           := Modulo.ZConexao;
  QOrdensFinalizadasDoAno.Connection:= Modulo.ZConexao;
  QExpClientes.Connection           := Modulo.ZConexao;
  QExpPecas.Connection              := Modulo.ZConexao;
  Result := True;
end;

function TFPrincipal.LerConfig(CodConfig: Integer): string;
{ Substitui Modulo.TBConfig.FindKey([...]) + GotoKey + TBConfigVLR_CONFIG.Value.
  tb_config tem as colunas COD_CONFIG e VLR_CONFIG (mesmo padrao do UPecas). }
begin
  Result := '';
  if not GarantirConexao then Exit;
  QConfig.Close;
  QConfig.SQL.Text := 'SELECT VLR_CONFIG FROM tb_config WHERE COD_CONFIG = :pCod';
  QConfig.ParamByName('pCod').AsInteger := CodConfig;
  try
    QConfig.Open;
    if not QConfig.IsEmpty then
      Result := QConfig.FieldByName('VLR_CONFIG').AsString;
  finally
    QConfig.Close;
  end;
end;

function TFPrincipal.Percentdisk(unidade: byte): Integer;
{Retorna a porcentagem de espaço livre em uma unidade de disco}
var
A,B, Percentual : longint;
begin
if DiskFree(Unidade)<> -1 then
  begin
  A := DiskFree(Unidade) div 1024;
  B := DiskSize(Unidade) div 1024;
  Percentual:=(A*100) div B;
  result := Percentual;
  end
else
  begin
  result := -1;
  end;
end;

procedure TFPrincipal.PowerBI1Click(Sender: TObject);
var
  pathextrac: string;
begin

if not GarantirConexao then Exit;

scExcelExport1.ExcelVisible:=False;
scExcelExport2.ExcelVisible:=False;
scExcelExport3.ExcelVisible:=False;

Modulo.NovaLeitura;   { snapshot atualizado antes de exportar - armadilha #1 }

{ SELECTs identicos aos que estavam no UModulo (VendasGerais /
  OrdensNaoFilalizadas / PesoTotal), com os nomes de tabela do MySQL e
  'finalizada = false' -> '= 0' (armadilha #6). }
QVendasGerais.Close;
QVendasGerais.SQL.Text :=
  'select c.fantasia CLIENTE, c.codigo CODIGO_CLIENTE, f.codigo CODIGO_OS, ' +
  'o.data DATA_ABERTURA, f.data_fim DATA_FIM, f.valor VALOR, ' +
  'o.quantidade QUANTIDADE, o.peso PESO, p.codigo CODIGO_PECA, ' +
  'p.descricao PECA, p.preco PRECO_KG, f.valor / o.peso PRECO_COBRADO, ' +
  'extract(MONTH from f.data_fim) MES_OS_FIM, ' +
  'extract(YEAR from f.data_fim) ANO_OS_FIM ' +
  'from tb_os_finalizados f, tb_os o, tb_clientes c, tb_pecas p ' +
  'where extract(MONTH from f.data_fim) >= 1 ' +
  'and extract(YEAR from f.data_fim) >= 2013 ' +
  'and f.codigo = o.codigo and o.cliente = c.codigo ' +
  'and o.peca = p.codigo and c.codigo = p.cod_cli';
QVendasGerais.Open;

QOrdensNaoFinalizadas.Close;
QOrdensNaoFinalizadas.SQL.Text :=
  'select c.fantasia CLIENTE, c.codigo CODIGO_CLIENTE, o.codigo CODIGO, ' +
  'o.data DATA_ABERTURA, o.quantidade QUANTIDADE, o.peso PESO, ' +
  'p.codigo CODIGO_PECA, p.descricao PECA, p.preco PRECO_KG, ' +
  'extract(MONTH from o.data) MES_OS_ABERTURA, ' +
  'extract(YEAR from o.data) ANO_OS_ABERTURA, ' +
  'o.peso * p.preco valor_estimado ' +
  'from tb_os o, tb_clientes c, tb_pecas p ' +
  'where extract(MONTH from o.data) >= 1 ' +
  'and extract(YEAR from o.data) >= 2013 ' +
  'and o.cliente = c.codigo and o.peca = p.codigo ' +
  'and c.codigo = p.cod_cli ' +
  'and (o.finalizada is null or o.finalizada = 0)';
QOrdensNaoFinalizadas.Open;

QPesoTotal.Close;
QPesoTotal.SQL.Text :=
  'select o.data, o.peso from tb_os o ' +
  'where extract(MONTH from o.data) >= 1 ' +
  'and extract(YEAR from o.data) >= 2013';
QPesoTotal.Open;

 try

  pathextrac := LerConfig(24);

scExcelExport1.LoadDefaultProperties;
scExcelExport1.ExcelVisible:=False;
scExcelExport1.WorksheetName := 'Vendas Gerais';
scExcelExport1.Dataset:= QVendasGerais;
scExcelExport1.ExportDataset;

scExcelExport1.SaveAs(pathextrac + '\VENDAS_GERAIS.xlsx',ffDefault); //without file extension

scExcelExport2.LoadDefaultProperties;
scExcelExport2.ExcelVisible:=False;
scExcelExport2.WorksheetName := 'OS Nao finalizada';
scExcelExport2.Dataset:= QOrdensNaoFinalizadas;
scExcelExport2.ExportDataset;

scExcelExport2.SaveAs(pathextrac + '\OS_NAO_FINALIZADA.xlsx',ffDefault); //without file extension

scExcelExport3.LoadDefaultProperties;
scExcelExport3.ExcelVisible:=False;
scExcelExport3.WorksheetName := 'Peso Total';
scExcelExport3.Dataset:= QPesoTotal;
scExcelExport3.ExportDataset;

scExcelExport3.SaveAs(pathextrac + '\PESO_TOTAL.xlsx',ffDefault); //without file extension


finally
scExcelExport1.Disconnect(True);
scExcelExport2.Disconnect(True);
scExcelExport3.Disconnect(True);
QVendasGerais.Close;
QOrdensNaoFinalizadas.Close;
QPesoTotal.Close;
end;

end;

function TFPrincipal.AliasToPath(Alias : String) : String;
{ Ja retornava caminho fixo desde a migracao anterior; as variaveis locais
  (dbDesc) vinham da unit BDE, removida do uses. }
begin
Result := 'D:\AMORTRAT\BD\Copy';
end;

function TFPrincipal.DiskInDrive(const Drive: char): Boolean;
var
DrvNum: byte;
EMode: Word;
begin
 result := false;
 DrvNum := ord(Drive);
 if DrvNum >= ord('a') then dec(DrvNum,$20);
 EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
 try
  if DiskSize(DrvNum-$40) <> -1 then result := true else messagebeep(0);
  finally SetErrorMode(EMode);
 end;
end;

procedure TFPrincipal.Sair1Click(Sender: TObject);
begin
close;
end;


procedure TFPrincipal.Clientes1Click(Sender: TObject);
begin
Fclientes.ShowModal;
end;

procedure TFPrincipal.ControleProduo1Click(Sender: TObject);
var
  pathextrac: string;
begin

if not GarantirConexao then Exit;

scExcelCliente.ExcelVisible:=False;
scExcelPecas.ExcelVisible:=False;
scExcelOS.ExcelVisible:=False;
scExcelOSFinalizados.ExcelVisible:=False;

Modulo.NovaLeitura;   { snapshot atualizado antes de exportar - armadilha #1 }

{ Substituem Modulo.TBClientes / TBPecas / OrdensDoAno / OrdensFinalizadasDoAno }
QExpClientes.Close;
QExpClientes.SQL.Text := 'select * from tb_clientes';
QExpClientes.Open;

QExpPecas.Close;
QExpPecas.SQL.Text := 'select * from tb_pecas';
QExpPecas.Open;

QOrdensDoAno.Close;
QOrdensDoAno.SQL.Text :=
  'select * from tb_os where extract(YEAR from data) >= :pAno';
QOrdensDoAno.ParamByName('pAno').AsInteger := 2025;
QOrdensDoAno.Open;

QOrdensFinalizadasDoAno.Close;
QOrdensFinalizadasDoAno.SQL.Text :=
  'select * from tb_os_finalizados where extract(YEAR from data_fim) >= :pAno';
QOrdensFinalizadasDoAno.ParamByName('pAno').AsInteger := 2025;
QOrdensFinalizadasDoAno.Open;

 try

  pathextrac := LerConfig(24);

scExcelCliente.LoadDefaultProperties;
scExcelCliente.ExcelVisible:=False;
scExcelCliente.WorksheetName := 'Clientes';
scExcelCliente.Dataset:= QExpClientes;
scExcelCliente.ExportDataset;

scExcelCliente.SaveAs(pathextrac + '\CLIENTES.xlsx',ffDefault); //without file extension

scExcelPecas.LoadDefaultProperties;
scExcelPecas.ExcelVisible:=False;
scExcelPecas.WorksheetName := 'PECAS';
scExcelPecas.Dataset:= QExpPecas;
scExcelPecas.ExportDataset;

scExcelPecas.SaveAs(pathextrac + '\PECAS.xlsx',ffDefault); //without file extension

scExcelOS.LoadDefaultProperties;
scExcelOS.ExcelVisible:=False;
scExcelOS.WorksheetName := 'OS';
scExcelOS.Dataset:= QOrdensDoAno;
scExcelOS.ExportDataset;

scExcelOS.SaveAs(pathextrac + '\OS.xlsx',ffDefault); //without file extension

scExcelOSFinalizados.LoadDefaultProperties;
scExcelOSFinalizados.ExcelVisible:=False;
scExcelOSFinalizados.WorksheetName := 'OS_FINALIZADOS';
scExcelOSFinalizados.Dataset:= QOrdensFinalizadasDoAno;
scExcelOSFinalizados.ExportDataset;

scExcelOSFinalizados.SaveAs(pathextrac + '\OS_FINALIZADOS.xlsx',ffDefault); //without file extension

finally

scExcelCliente.Disconnect(True);
scExcelPecas.Disconnect(True);
scExcelOS.Disconnect(True);
scExcelOSFinalizados.Disconnect(True);
QExpClientes.Close;
QExpPecas.Close;
QOrdensDoAno.Close;
QOrdensFinalizadasDoAno.Close;

end;

end;

procedure TFPrincipal.FormActivate(Sender: TObject);
{ FormActivate dispara a cada vez que o menu volta ao foco (inclusive ao fechar
  um form modal filho). O Caption e remontado a partir de FCaptionBase para nao
  acumular o sufixo de homologacao a cada ativacao.
  A config 4 e lida uma unica vez: no BDE o FindKey era leitura local e barata,
  no MySQL seria uma consulta de rede a cada retorno ao menu. }
begin
  Data.Caption := datetostr(date);

  if FCaptionBase <> '' then Exit;      { ja resolvido na primeira ativacao }
  FCaptionBase := Caption;

  if not GarantirConexao then Exit;
  if LerConfig(4) = '2' then
    Caption := FCaptionBase + ' <<< AMBIENTE DE HOMOLOGAÇAO >>>';
end;

procedure TFPrincipal.Processos1Click(Sender: TObject);
begin
Application.CreateForm(TFProcessos, FProcessos);
FProcessos.showmodal;
end;

procedure TFPrincipal.RankingFaturamentoMs1Click(Sender: TObject);
var
    RequestBody: TStream;
  ResponseBody, msg, msg2, query: string;
  i : Integer;
  Ano, Mes, Dia: Word;
  PesoTotal, FaturamentoTotal: Double;

begin

  Try

      { 'order by 3 desc' era posicional; virou o alias VALOR_G (armadilha #7).
        Mesma consulta ja validada no UGerrelat.BTImprimirClick. }
      query := 'select SUM(A.PESO) PESO, MAX(B.FANTASIA) FANTASIA, SUM(C.VALOR) VALOR_G from tb_os A, tb_clientes B, tb_os_finalizados C where B.CODIGO = A.CLIENTE and C.CODIGO = A.CODIGO ' +
      'and extract(MONTH from c.data_fim) =  :mes1 and extract(YEAR from c.data_fim) = :ano1 group by A.CLIENTE, B.CODIGO order by VALOR_G desc' ;


  DecodeDate(Date, Ano, Mes, Dia);

  if not GarantirConexao then Exit;
  Modulo.NovaLeitura;   { snapshot atualizado - armadilha #1 }

  QRank.close;
  QRank.SQL.Clear;
  QRank.SQL.Text := query;

    QRank.ParamByName('mes1').AsInteger := Mes;
    QRank.ParamByName('ano1').AsInteger := Ano;


    QRank.Prepare;
    QRank.Open;

  i := 1;
  PesoTotal := 0;
  FaturamentoTotal := 0;



  If not QRank.Eof then
    repeat

      { Os TField persistentes foram removidos; o acesso e por FieldByName.
        StrToFloatDef(campo.Text, 0.0) virou .AsFloat: le o valor numerico
        direto, sem passar por string. O FormatFloat da saida e o mesmo, entao
        a mensagem sai identica - mas deixa de depender de como o ZeosLib
        formata .Text para o tipo que inferir de SUM(...) sobre decimal.
        Campo NULL continua valendo 0 nos dois casos. }
      msg := msg + '\n`' + FormatFloat('#,#00', i) + ' ' +  AjustarString(QRank.FieldByName('FANTASIA').AsString,10) + ' ' + FormatFloat('#,##0', QRank.FieldByName('PESO').AsFloat) + ' Kg' + ' R$ ' + FormatFloat('#,##0.00', QRank.FieldByName('VALOR_G').AsFloat) + '`'  ;

      PesoTotal :=   PesoTotal + QRank.FieldByName('PESO').AsFloat;
      FaturamentoTotal :=   FaturamentoTotal + QRank.FieldByName('VALOR_G').AsFloat;

      i := i + 1;

      QRank.Next
    until QRank.Eof;

          msg2 := '📊 *Ranking do mês  ' + FormatDateTime('mmmm/yyyy', Date) +'*';
          msg2 := msg2 + '\n\nFaturamento Total: R$ ' +  AjustarString(FormatFloat('#,##0.00', FaturamentoTotal),12) +'\n';
          msg2 := msg2 + 'Peso Total: ' +  AjustarString(FormatFloat('#,##0.00', PesoTotal),12) +'\n\n';

          msg := msg2 + msg;

          RequestBody := TStringStream.Create('{"to": "5511993093136", "body": "'+Copy(msg,1,4095)+'"} ', TEncoding.UTF8);

          HTTP.Response.KeepAlive := False;

         HTTP.Request.CustomHeaders.FoldLines := False;
         HTTP.Request.CustomHeaders.Clear;
         HTTP.Request.CustomHeaders.Add('Authorization: Bearer itqNkeLirrreGr5wmTQrmJSCY8vHmhB7');
         HTTP.Request.ContentType := 'application/json';

         ResponseBody := HTTP.Post('https://gate.whapi.cloud/messages/text',RequestBody);

         FreeAndNil   ( RequestBody);



          RequestBody := TStringStream.Create('{"to": "5511981649243", "body": "'+Copy(msg,1,4093)+'"} ', TEncoding.UTF8);


         ResponseBody := HTTP.Post('https://gate.whapi.cloud/messages/text',RequestBody);

         FreeAndNil   ( RequestBody);

      Application.MessageBox(PChar('RELATÓRIO ENVIADO COM SUCESSO'),
        PChar('AVISO'),
        MB_Ok + MB_IconInformation);

  except On E : Exception do

        ShowMessage(E.ClassName+' error raised, with message : '+E.Message);

  end;

  FreeAndNil   ( RequestBody);


end;

procedure TFPrincipal.ResumoDirio1Click(Sender: TObject);
var
    RequestBody: TStream;
  ResponseBody, msg, query: string;
  i : Integer;
  Ano, Mes, Dia: Word;
  LeadAtual: Double;

begin

  Try

  { Tabelas com o prefixo tb_ e 'FINALIZADA = false' -> '= 0' (armadilha #6).
    A ordem dos 5 UNION ALL e significativa: o laco abaixo identifica cada
    linha pelo indice i (1=OS hoje, 2=ontem, 3=faturamento, 4=Kg mes,
    5=nao finalizadas). Nao reordenar. }
  query := 'select ' +
'sum(o.peso) vlr ' +
'from  tb_os o ' +
'where ' +
'o.data = :data ' +
'union all ' +
'select ' +
'sum(o.peso) vlr ' +
'from  tb_os o ' +
'where ' +
'o.data = :dataOntem  ' +
'union all ' +
'select ' +
'sum(f.valor) vlr ' +
'from  tb_os o, tb_os_finalizados f ' +
'where ' +
'o.codigo = f.codigo ' +
' and extract(MONTH from f.data_fim) =  :mes1' +
' and extract(YEAR from f.data_fim) =  :ano1'  +
' union all' +
' select ' +
' sum(o.peso) vlr ' +
' from  tb_os o, tb_os_finalizados f ' +
' where ' +
' o.codigo = f.codigo' +
' and f.valor > 0' +
' and extract(MONTH from f.data_fim) = :mes2'  +
' and  extract(YEAR from f.data_fim) = :ano2'  +
' union all ' +
' select ' +
' sum(o.peso) vlr ' +
' from  tb_os o' +
' where ' +
' (o.FINALIZADA is null or o.FINALIZADA = 0)' +
' and extract(YEAR from o.data) >= :ano3 - 1'   ;

  DecodeDate(Date, Ano, Mes, Dia);

  if not GarantirConexao then Exit;
  Modulo.NovaLeitura;   { snapshot atualizado - armadilha #1 }

  QResumo.close;
  QResumo.SQL.Clear;
  QResumo.SQL.Text := query;

    QResumo.ParamByName('data').AsDateTime := Date;
    QResumo.ParamByName('dataOntem').AsDateTime := Date - 1;
    QResumo.ParamByName('mes1').AsInteger := Mes;
    QResumo.ParamByName('ano1').AsInteger := Ano;
    QResumo.ParamByName('mes2').AsInteger := Mes;
    QResumo.ParamByName('ano2').AsInteger := Ano;
    QResumo.ParamByName('ano3').AsInteger := Ano;

    QResumo.Prepare;
    QResumo.Open;

  i := 1;

  msg := '📊 *Relatório do dia: ' + DateToStr(Date) +'*' ;

  If not QResumo.Eof then
    repeat

    { QResumovlr (TFloatField persistente) removido -> FieldByName('vlr').AsFloat.
      O alias da coluna e 'vlr' minusculo no SELECT; FieldByName do Delphi e
      case-insensitive, entao 'vlr' resolve. }
    if i = 1 then
     // msg := msg + 'OS emitidas hoje: ' + StringReplace(QResumoVLR.Text,',','.',[rfReplaceAll, rfIgnoreCase])    ;
      msg := msg + '\n \n  • `' + AjustarString('OS hoje: ',20) + FormatFloat('#,##0', QResumo.FieldByName('vlr').AsFloat) + ' Kg`'
    else  if i = 2 then
      msg := msg + '\n  • `' + AjustarString('OS dia anterior: ',20) + FormatFloat('#,##0', QResumo.FieldByName('vlr').AsFloat) + ' Kg`'
    else  if i = 3 then
      msg := msg + '\n  • `' + AjustarString('Faturamento mensal: ',20) + 'R$ ' + FormatFloat('#,##0.00', QResumo.FieldByName('vlr').AsFloat) + '`'
    else  if i = 4 then
      msg := msg + '\n  • `' + AjustarString('Kg total mensal: ',20) + FormatFloat('#,##0', QResumo.FieldByName('vlr').AsFloat) + ' Kg`'
    else  if i = 5 then
      msg := msg + '\n  • `' + AjustarString('OS não finalizadas: ',20) + FormatFloat('#,##0', QResumo.FieldByName('vlr').AsFloat) + ' Kg`'   ;

      i := i + 1;

      QResumo.Next
    until QResumo.Eof;

    { Reescrito para MySQL:
        - B.CODIGO e C.CODIGO (duplicatas de JOIN) REMOVIDOS do SELECT. O BDE
          as renomeava para CODIGO_1/CODIGO_2; o MySQL nao (armadilha #7).
          Nenhuma delas era usada no laco abaixo;
        - '(:pNow - A.DATA)' -> DATEDIFF(:pNow, A.DATA) (armadilha #14);
        - 'order by 12' era posicional e quebraria ao mudar o SELECT: virou o
          alias LEADTIME;
        - 'FINALIZADA = false' -> '= 0' (armadilha #6).
      Mesma consulta ja validada no UGerrelat (OS EMITIDAS NAO FINALIZADAS). }
    QOs.SQL.Text := 'select A.CODIGO, A.CLIENTE, A.PECA, A.DATA, A.PESO, B.COD_CLI, B.DESCRICAO, C.FANTASIA, A.URGENCIA, DATEDIFF(:pNow, A.DATA) LEADTIME, P.PROCESSO from tb_os A, tb_pecas B, tb_clientes C, tb_proc P' + ' where B.CODIGO = A.PECA and B.COD_CLI = A.CLIENTE and C.CODIGO = A.CLIENTE and (A.FINALIZADA is null or A.FINALIZADA = 0) and A.DATA >=:pInicial and A.DATA <=:pFinal   AND B.COD_PROC = P.CODIGO  order by LEADTIME DESC';
    QOs.ParamByName('pNow').AsDateTime := Now;
    QOs.ParamByName('pInicial').AsDateTime := Now - 120;
    QOs.ParamByName('pFinal').AsDateTime := Now;
    QOs.Prepare;
    QOs.Open;
    QOs.Refresh;

  i :=  1;

   If not QOS.Eof then
    repeat

    if i = 1 then begin
      msg := msg + '\n \n \n 🚨*ATENÇÃO: Existem lotes há muitos dias sem finalização:*';

    end ;

          { QOsCODIGO tinha Size=8 no DFM, mas tb_os.CODIGO e varchar(9)
            ('098800/26'): mantido o TField, o numero da OS sairia truncado
            na mensagem (armadilha #15). Por isso FieldByName. }
          msg := msg + '\n  • `' + AjustarString(QOs.FieldByName('FANTASIA').AsString,12) + ' - ' + QOs.FieldByName('CODIGO').AsString + ' ' + FormatFloat('#,##0', QOs.FieldByName('LEADTIME').AsFloat) + ' dias`' ;

      i := i + 1;

      QOS.Next;
      { O projeto compila com -$B+ (BOOLEVAL ON): NAO ha curto-circuito, os dois
        lados do 'or' sao sempre avaliados. Le-se o LEADTIME so quando ha
        registro, para nao tocar no buffer em EOF. Criterio de parada inalterado:
        para no primeiro lote com <= 10 dias (a query vem ordenada DESC). }
      if QOS.Eof then
        LeadAtual := 0
      else
        LeadAtual := QOs.FieldByName('LEADTIME').AsFloat;
    until (QOS.Eof) or (LeadAtual <= 10);





          RequestBody := TStringStream.Create('{"to": "5511993093136", "body": "'+Copy(msg,1,4095)+'"} ', TEncoding.UTF8);

          HTTP.Response.KeepAlive := False;

         HTTP.Request.CustomHeaders.FoldLines := False;
         HTTP.Request.CustomHeaders.Clear;
         HTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)';
         HTTP.Request.CustomHeaders.Add('Authorization: Bearer itqNkeLirrreGr5wmTQrmJSCY8vHmhB7');

         HTTP.Request.ContentType := 'application/json';

         ResponseBody := HTTP.Post('https://gate.whapi.cloud/messages/text',RequestBody);

         FreeAndNil   ( RequestBody);

          RequestBody := TStringStream.Create('{"to": "5511981649243", "body": "'+Copy(msg,1,4095)+'"} ', TEncoding.UTF8);


         ResponseBody := HTTP.Post('https://gate.whapi.cloud/messages/text',RequestBody);

         FreeAndNil   ( RequestBody);

      Application.MessageBox(PChar('RELATÓRIO ENVIADO COM SUCESSO'),
        PChar('AVISO'),
        MB_Ok + MB_IconInformation);

  except On E : Exception do

        ShowMessage(E.ClassName+' error raised, with message : '+E.Message);

  end;

  FreeAndNil   ( RequestBody);


end;

procedure TFPrincipal.PecasClick(Sender: TObject);
begin
FPecas.showmodal;
end;

procedure TFPrincipal.NotaClick(Sender: TObject);
begin

FNF.showmodal;
end;

procedure TFPrincipal.CertificadodeQualidade1Click(Sender: TObject);
begin
FRelatCQ.showmodal;
end;

procedure TFPrincipal.GerenciadorClick(Sender: TObject);
begin
  Application.CreateForm(TFGerRelat, FGerRelat);
  FGerRelat.Refresh;
 //Relatorios.Refresh;
  FGerrelat.showMODAL;
end;


procedure TFPrincipal.ESenhaEnter(Sender: TObject);
begin
TEdit(Sender).color := $00E2F5FE;
TEdit(Sender).Font.Color := clNavy;
TEdit(sender).Font.style := [fsBold];
end;

procedure TFPrincipal.ESenhaExit(Sender: TObject);
begin
TEdit(Sender).color := clWhite;
TEdit(Sender).Font.Color := clBlack;
TEdit(Sender).Font.style := [];
end;


procedure TFPrincipal.Abertura1Click(Sender: TObject);
begin
FOs.showmodal;
end;

procedure TFPrincipal.PrecoClick(Sender: TObject);
begin
Application.CreateForm(TFReajuste, FReajuste);
FReajuste.showmodal;
end;

procedure TFPrincipal.UsuarioClick(Sender: TObject);
begin
Application.CreateForm(TFUsuarios, FUsuarios);
FUsuarios.showmodal;
end;

Function TFPrincipal.ExecAndWait( Const FileName, Params: String; Const WindowState: Word ) : Boolean;
Var SUInfo: TStartupInfo;
   ProcInfo: TProcessInformation;
   CmdLine: string;
Begin

  CmdLine := '"' + Filename + '"' + Params;
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  With SUInfo Do Begin
      cb := SizeOf(SUInfo);
      dwFlags := STARTF_USESHOWWINDOW;
      wShowWindow := WindowState;

  End;
  Result := CreateProcess( Nil, PChar(CmdLine), Nil, Nil, False,
  CREATE_NEW_CONSOLE Or NORMAL_PRIORITY_CLASS, Nil,
  PChar(ExtractFilePath(Filename)), SUInfo, ProcInfo );
  If Result Then Begin
      WaitForSingleObject( ProcInfo.hProcess, INFINITE );
      CloseHandle(ProcInfo.hProcess);
      CloseHandle(ProcInfo.hThread);
  End;
End;

procedure TFPrincipal.NMFTP1TransactionStart(Sender: TObject);
begin
ShowMessage('Iniciou');

end;

procedure TFPrincipal.NMFTP1TransactionStop(Sender: TObject);
begin
ShowMessage('Finalizou');

end;

procedure TFPrincipal.NMFTP1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin

ShowMessage(Errmsg);

end;

function TFPrincipal.TamArquivo(Arquivo: string): Integer;
begin
with TFileStream.Create(Arquivo, fmOpenRead or fmShareExclusive) do
try
Result := Size;
finally
Free;
end;
end;



procedure TFPrincipal.Timer1Timer(Sender: TObject);
begin
if not GarantirConexao then Exit;

scExcelExport1.ExcelVisible:=False;

Modulo.NovaLeitura;   { snapshot atualizado - armadilha #1 }

QVendasGerais.Close;
QVendasGerais.SQL.Text :=
  'select c.fantasia CLIENTE, c.codigo CODIGO_CLIENTE, f.codigo CODIGO_OS, ' +
  'o.data DATA_ABERTURA, f.data_fim DATA_FIM, f.valor VALOR, ' +
  'o.quantidade QUANTIDADE, o.peso PESO, p.codigo CODIGO_PECA, ' +
  'p.descricao PECA, p.preco PRECO_KG, f.valor / o.peso PRECO_COBRADO, ' +
  'extract(MONTH from f.data_fim) MES_OS_FIM, ' +
  'extract(YEAR from f.data_fim) ANO_OS_FIM ' +
  'from tb_os_finalizados f, tb_os o, tb_clientes c, tb_pecas p ' +
  'where extract(MONTH from f.data_fim) >= 1 ' +
  'and extract(YEAR from f.data_fim) >= 2013 ' +
  'and f.codigo = o.codigo and o.cliente = c.codigo ' +
  'and o.peca = p.codigo and c.codigo = p.cod_cli';
QVendasGerais.Open;

try
scExcelExport1.LoadDefaultProperties;
scExcelExport1.ExcelVisible:=False;
scExcelExport1.WorksheetName := 'Vendas Gerais';
scExcelExport1.Dataset:= QVendasGerais;
scExcelExport1.ExportDataset;

scExcelExport1.SaveAs('D:\AMORTRAT\powerBI\VENDAS_GERAIS.xlsx',ffDefault); //without file extension



finally
scExcelExport1.Disconnect(True);
QVendasGerais.Close;

end;

end;

procedure TFPrincipal.OrdemdeServio1Click(Sender: TObject);
begin
FOs.showmodal;
end;

procedure TFPrincipal.MatriaPrima1Click(Sender: TObject);
begin
//FFornec.ShowModal;
end;

procedure TFPrincipal.Fornecedores1Click(Sender: TObject);
begin
//FFornec.ShowModal;
end;

function EscapeJSON(const S: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    case S[I] of
      '\': Result := Result + '\\';
      '"': Result := Result + '\"';
      #8: Result := Result + '\b';
      #9: Result := Result + '\t';
      #10: Result := Result + '\n'; // quebra de linha
      #13: ; // ignora isolado
      #12: Result := Result + '\f';
    else
      Result := Result + String(S[I]); // <<< AQUI: forçar Char -> String
    end;
  end;
end;

function AjustarString(const S: string; N: integer): string;
begin
  if Length(S) >= N then
    Result := Copy(S, 1, N)
  else
    Result := S + StringOfChar(' ', N - Length(S));
end;

end.
