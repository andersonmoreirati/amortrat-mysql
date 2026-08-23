{$OPTIMIZATION ON}
unit principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, BarMenus, BcDrawModule, BcCustomDrawModule, ImgList,
  ComCtrls, AdvStatus, VrControls, VrLcd, VrLabel,
  ExtCtrls, jpeg, BDE, ShellApi, StdCtrls,
  mdTabEnter,mdShell, PkgAdvStatus, scExcelExport, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdSSLOpenSSL, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  DB, DBTables, RxQuery, IdAuthentication;

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
    QResumo: TRxQuery;
    Resumo1: TMenuItem;
    QResumovlr: TFloatField;
    QOs: TRxQuery;
    QOsCODIGO: TStringField;
    QOsCLIENTE: TStringField;
    QOsPECA: TStringField;
    QOsDATA: TDateField;
    QOsCODIGO_1: TStringField;
    QOsCOD_CLI: TStringField;
    QOsDESCRICAO: TStringField;
    QOsCODIGO_2: TStringField;
    QOsFANTASIA: TStringField;
    QOsPESO: TFloatField;
    QOsURGENCIA: TStringField;
    QOsLEADTIME: TFloatField;
    QOsPROCESSO: TStringField;
    ResumoDirio1: TMenuItem;
    RankingFaturamentoMs1: TMenuItem;
    QRank: TRxQuery;
    QRankPESO: TFloatField;
    QRankFANTASIA: TStringField;
    QRankVALOR_G: TCurrencyField;
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

scExcelExport1.ExcelVisible:=False;
scExcelExport2.ExcelVisible:=False;
scExcelExport3.ExcelVisible:=False;
With Modulo do begin

  VendasGerais.Active := true;
  OrdensNaoFilalizadas.Active := true;
  PesoTotal.Active := true;

 try

   TBConfig.FindKey(['24']);
  If TBConfig.GotoKey then
  begin
     pathextrac := TBConfigVLR_CONFIG.Value;
  end;

scExcelExport1.LoadDefaultProperties;
scExcelExport1.ExcelVisible:=False;
scExcelExport1.WorksheetName := 'Vendas Gerais';
scExcelExport1.Dataset:= VendasGerais;
scExcelExport1.ExportDataset;

scExcelExport1.SaveAs(pathextrac + '\VENDAS_GERAIS.xlsx',ffDefault); //without file extension

scExcelExport2.LoadDefaultProperties;
scExcelExport2.ExcelVisible:=False;
scExcelExport2.WorksheetName := 'OS Nao finalizada';
scExcelExport2.Dataset:= OrdensNaoFilalizadas;
scExcelExport2.ExportDataset;

scExcelExport2.SaveAs(pathextrac + '\OS_NAO_FINALIZADA.xlsx',ffDefault); //without file extension

scExcelExport3.LoadDefaultProperties;
scExcelExport3.ExcelVisible:=False;
scExcelExport3.WorksheetName := 'Peso Total';
scExcelExport3.Dataset:= PesoTotal;
scExcelExport3.ExportDataset;

scExcelExport3.SaveAs(pathextrac + '\PESO_TOTAL.xlsx',ffDefault); //without file extension


finally
scExcelExport1.Disconnect(True);
scExcelExport2.Disconnect(True);
scExcelExport3.Disconnect(True);
end;

end;

end;

function TFPrincipal.AliasToPath(Alias : String) : String;
var
Desc : dbDesc;
szAlias : Array[0..255] of Char;
szAlias2 : string;
begin
//StrPCopy(szAlias2,Alias);
//anderson.moreira MIGRACAO
//DbiGetDatabaseDesc(Alias,@Desc);
//Result := StrPas(Desc.szPhyName);
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

scExcelCliente.ExcelVisible:=False;
scExcelPecas.ExcelVisible:=False;
scExcelOS.ExcelVisible:=False;
scExcelOSFinalizados.ExcelVisible:=False;

With Modulo do begin

  OrdensDoAno.Active := true;
  OrdensFinalizadasDoAno.Active := true;

 try

   TBConfig.FindKey(['24']);
  If TBConfig.GotoKey then
  begin
     pathextrac := TBConfigVLR_CONFIG.Value;
  end;

scExcelCliente.LoadDefaultProperties;
scExcelCliente.ExcelVisible:=False;
scExcelCliente.WorksheetName := 'Clientes';
scExcelCliente.Dataset:= TBClientes;
scExcelCliente.ExportDataset;

scExcelCliente.SaveAs(pathextrac + '\CLIENTES.xlsx',ffDefault); //without file extension

scExcelPecas.LoadDefaultProperties;
scExcelPecas.ExcelVisible:=False;
scExcelPecas.WorksheetName := 'PECAS';
scExcelPecas.Dataset:= TBPecas;
scExcelPecas.ExportDataset;

scExcelPecas.SaveAs(pathextrac + '\PECAS.xlsx',ffDefault); //without file extension

scExcelOS.LoadDefaultProperties;
scExcelOS.ExcelVisible:=False;
scExcelOS.WorksheetName := 'OS';
scExcelOS.Dataset:= OrdensDoAno;
scExcelOS.ExportDataset;

scExcelOS.SaveAs(pathextrac + '\OS.xlsx',ffDefault); //without file extension

scExcelOSFinalizados.LoadDefaultProperties;
scExcelOSFinalizados.ExcelVisible:=False;
scExcelOSFinalizados.WorksheetName := 'OS_FINALIZADOS';
scExcelOSFinalizados.Dataset:= OrdensFinalizadasDoAno;
scExcelOSFinalizados.ExportDataset;

scExcelOSFinalizados.SaveAs(pathextrac + '\OS_FINALIZADOS.xlsx',ffDefault); //without file extension

finally

scExcelCliente.Disconnect(True);
scExcelPecas.Disconnect(True);
scExcelOS.Disconnect(True);
scExcelOSFinalizados.Disconnect(True);


end;

end;

end;

procedure TFPrincipal.FormActivate(Sender: TObject);
begin
With Modulo do
begin
 Data.Caption := datetostr(date);

   TBConfig.FindKey(['4']);
  If TBConfig.GotoKey then
  begin
    IF TBConfigVLR_CONFIG.Text = '2' then
       Fprincipal.Caption := Fprincipal.Caption + ' <<< AMBIENTE DE HOMOLOGAÇAO >>>';
  end;


end;
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

      query := 'select SUM(A.PESO) PESO, MAX(B.FANTASIA) FANTASIA, SUM(C.VALOR) VALOR_G from OS A, CLIENTES B, OS_FINALIZADOS C where B.CODIGO = A.CLIENTE and C.CODIGO = A.CODIGO ' +
      'and extract(MONTH from c.data_fim) =  :mes1 and extract(YEAR from c.data_fim) = :ano1 group by A.CLIENTE, B.CODIGO order by 3 desc' ;


  DecodeDate(Date, Ano, Mes, Dia);

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

      msg := msg + '\n`' + FormatFloat('#,#00', i) + ' ' +  AjustarString(QRankFANTASIA.text,10) + ' ' + FormatFloat('#,##0', StrToFloatDef(QRankPESO.Text, 0.0)) + ' Kg' + ' R$ ' + FormatFloat('#,##0.00', StrToFloatDef(QRankVALOR_G.Text, 0.0)) + '`'  ;

      PesoTotal :=   PesoTotal + QRankPESO.Value;
      FaturamentoTotal :=   FaturamentoTotal + QRankVALOR_G.Value;

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

begin

  Try

  query := 'select ' +
'sum(o.peso) vlr ' +
'from  os o ' +
'where ' +
'o.data = :data ' +
'union all ' +
'select ' +
'sum(o.peso) vlr ' +
'from  os o ' +
'where ' +
'o.data = :dataOntem  ' +
'union all ' +
'select ' +
'sum(f.valor) vlr ' +
'from  os o, os_finalizados f ' +
'where ' +
'o.codigo = f.codigo ' +
' and extract(MONTH from f.data_fim) =  :mes1' +
' and extract(YEAR from f.data_fim) =  :ano1'  +
' union all' +
' select ' +
' sum(o.peso) vlr ' +
' from  os o, os_finalizados f ' +
' where ' +
' o.codigo = f.codigo' +
' and f.valor > 0' +
' and extract(MONTH from f.data_fim) = :mes2'  +
' and  extract(YEAR from f.data_fim) = :ano2'  +
' union all ' +
' select ' +
' sum(o.peso) vlr ' +
' from  os o' +
' where ' +
' (o.FINALIZADA is null or o.FINALIZADA = false)' +
' and extract(YEAR from o.data) >= :ano3 - 1'   ;

  DecodeDate(Date, Ano, Mes, Dia);

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

    if i = 1 then
     // msg := msg + 'OS emitidas hoje: ' + StringReplace(QResumoVLR.Text,',','.',[rfReplaceAll, rfIgnoreCase])    ;
      msg := msg + '\n \n  • `' + AjustarString('OS hoje: ',20) + FormatFloat('#,##0', StrToFloatDef(QResumoVLR.Text, 0.0)) + ' Kg`'
    else  if i = 2 then
      msg := msg + '\n  • `' + AjustarString('OS dia anterior: ',20) + FormatFloat('#,##0', StrToFloatDef(QResumoVLR.Text, 0.0)) + ' Kg`'
    else  if i = 3 then
      msg := msg + '\n  • `' + AjustarString('Faturamento mensal: ',20) + 'R$ ' + FormatFloat('#,##0.00', StrToFloatDef(QResumoVLR.Text, 0.0)) + '`'
    else  if i = 4 then
      msg := msg + '\n  • `' + AjustarString('Kg total mensal: ',20) + FormatFloat('#,##0', StrToFloatDef(QResumoVLR.Text, 0.0)) + ' Kg`'
    else  if i = 5 then
      msg := msg + '\n  • `' + AjustarString('OS não finalizadas: ',20) + FormatFloat('#,##0', StrToFloatDef(QResumoVLR.Text, 0.0)) + ' Kg`'   ;

      i := i + 1;

      QResumo.Next
    until QResumo.Eof;

    QOs.SQL.Text := 'select A.CODIGO, A.CLIENTE, A.PECA, A.DATA, A.PESO, B.CODIGO, B.COD_CLI, B.DESCRICAO, C.CODIGO, C.FANTASIA, A.URGENCIA, (:pNow - A.DATA) LEADTIME, P.PROCESSO from OS A, PECAS B, CLIENTES C, PROC P' + ' where B.CODIGO = A.PECA and B.COD_CLI = A.CLIENTE and C.CODIGO = A.CLIENTE and (A.FINALIZADA is null or A.FINALIZADA = false) and A.DATA >=:pInicial and A.DATA <=:pFinal   AND B.COD_PROC = P.CODIGO  order by 12 DESC';
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

          msg := msg + '\n  • `' + AjustarString(QOsFANTASIA.Text,12) + ' - ' + QOsCODIGO.Value + ' ' + FormatFloat('#,##0', StrToFloatDef(QOsLEADTIME.Text, 0.0)) + ' dias`' ;

      i := i + 1;

      QOS.Next
    until (QOS.Eof) or (StrToFloatDef(QOsLEADTIME.Text, 0.0) <= 10);





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
scExcelExport1.ExcelVisible:=False;

With Modulo do begin

try
scExcelExport1.LoadDefaultProperties;
scExcelExport1.ExcelVisible:=False;
scExcelExport1.WorksheetName := 'Vendas Gerais';
scExcelExport1.Dataset:= VendasGerais;
scExcelExport1.ExportDataset;

scExcelExport1.SaveAs('D:\AMORTRAT\powerBI\VENDAS_GERAIS.xlsx',ffDefault); //without file extension



finally
scExcelExport1.Disconnect(True);

end;

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
