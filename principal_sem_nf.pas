unit principal_sem_nf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, BarMenus, BcDrawModule, BcCustomDrawModule, ImgList,
  ComCtrls, AdvStatus, VrControls, VrLcd, VrLabel, XPMenu, MXPMenu,
  ExtCtrls, jpeg, BDE, ShellApi, RxLogin, StdCtrls, IAeverButton,
  mdTabEnter, Psock, NMFtp, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP, dsButton, mdShell;

type
  TFprincipal = class(TForm)
    ImageList1: TImageList;
    AdvStatus1: TAdvStatus;
    Data: TVrLabel;
    Menu: TBcBarMainMenu;
    Cadastro: TMenuItem;
    Clientes1: TMenuItem;
    Processos1: TMenuItem;
    Pecas: TMenuItem;
    OrdemdeServio: TMenuItem;
    Relatorios: TMenuItem;
    Utilitrios1: TMenuItem;
    Sair1: TMenuItem;
    MXPMenu1: TMXPMenu;
    Nota: TMenuItem;
    Image1: TImage;
    Backup1: TMenuItem;
    Calculadora1: TMenuItem;
    Editordetexto1: TMenuItem;
    Gerenciador: TMenuItem;
    VrClock1: TVrClock;
    CertificadodeQualidade1: TMenuItem;
    Criar1: TMenuItem;
    TabEnter1: TTabEnter;
    Abertura1: TMenuItem;
    Finalizao1: TMenuItem;
    Preco: TMenuItem;
    Usuario: TMenuItem;
    Restaurar1: TMenuItem;
    IdFTP1: TIdFTP;
    PB: TProgressBar;
    Shell1: TShell;
    procedure Sair1Click(Sender: TObject);
    procedure Clientes1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Processos1Click(Sender: TObject);
    procedure PecasClick(Sender: TObject);
    procedure NotaClick(Sender: TObject);
    procedure CertificadodeQualidade1Click(Sender: TObject);
    procedure Criar1Click(Sender: TObject);
    procedure GerenciadorClick(Sender: TObject);
    procedure ESenhaEnter(Sender: TObject);
    procedure ESenhaExit(Sender: TObject);
    procedure Abertura1Click(Sender: TObject);
    procedure Finalizao1Click(Sender: TObject);
    procedure PrecoClick(Sender: TObject);
    procedure UsuarioClick(Sender: TObject);
    procedure Restaurar1Click(Sender: TObject);
    procedure NMFTP1TransactionStart(Sender: TObject);
    procedure NMFTP1TransactionStop(Sender: TObject);
    procedure NMFTP1Error(Sender: TComponent; Errno: Word; Errmsg: String);
    procedure IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);

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
  Fprincipal: TFprincipal;

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
  UFinalizar, UReajuste, UUsuarios;

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

function TFPrincipal.AliasToPath(Alias : String) : String;
var
Desc : dbDesc;
szAlias : Array[0..255] of Char;
begin
StrPCopy(szAlias,Alias);
DbiGetDatabaseDesc(szAlias,@Desc);
Result := StrPas(Desc.szPhyName);
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

procedure TFprincipal.Sair1Click(Sender: TObject);
begin
close;
end;


procedure TFprincipal.Clientes1Click(Sender: TObject);
begin
Fclientes.ShowModal;
end;

procedure TFprincipal.FormActivate(Sender: TObject);
begin
With Modulo do
begin
 Data.Caption := datetostr(date);
end;
end;

procedure TFprincipal.FormCreate(Sender: TObject);
begin
//83512898
end;

procedure TFprincipal.Processos1Click(Sender: TObject);
begin
  FProcessos.showmodal;
end;

procedure TFprincipal.PecasClick(Sender: TObject);
begin
FPecas.showmodal;
end;

procedure TFprincipal.NotaClick(Sender: TObject);
begin
FNF.showmodal;
end;

procedure TFprincipal.CertificadodeQualidade1Click(Sender: TObject);
begin
FRelatCQ.showmodal;
end;

procedure TFprincipal.Criar1Click(Sender: TObject);
var
 //retCode: LongInt;
 //Dados: TSHFileOpStruct;
 path,texto,sNomeZip,sNomeArq: string;
 log: textfile;
begin
with Modulo do begin


If Application.MessageBox('Bem vindo ao assiste para criação de backup! Esta ferramenta fará um backup online do banco de dados. Deseja continuar?', 'Assistente para criação de BACKUP', MB_YesNo+MB_IconQuestion) = IDYes then
begin
 Application.MessageBox('Antes de iniciar o processo, certifique-se de que APENAS esta estação está conectada ao sistema, que há conexão com a internet e acompanhe o progresso na barra de status inferior da tela!', 'Assistente para criação de BACKUP', mb_oK+mB_IconInformation);

 path := AliasToPAth('Amortrat');

  AssignFile(log, path + '\log.txt');
  if not FileExists(path + '\log.txt') then Rewrite(log,path + '\log.txt');
  Append(log);
  WriteLn(log, 'SISTEMA AMORTRAT');
  WriteLn(log, 'ARQUIVO DE BACKUP CRIADO COM ÊXITO!');
  WriteLn(log, ('DATA DE CRIAÇÃO:' + datetostr(date)));
  CloseFile(log);

texto := AdvStatus1.Panels[0].Text;
AdvStatus1.Panels[0].Text := 'Criando backup...';
sleep(500);
AdvStatus1.Panels[0].Text := 'Fechando o banco de dados...';

    TBClientes.Active := false;
    TBProc.Active := false;
    TBPecas.Active := false;
    TBOs.Active := false;
    TBOs_Finalizados.Active := false;
    TBNf.Active := false;
    TBUsuario.Active := false;
  TBNf_Ref.Active := false;
  TBNf_Itens.Active := false;
  TBConfig.Active := false;
  TBEmail.Active := false;


AdvStatus1.Panels[0].Text := 'Conectando-se ao servidor...';

  idFTP1.Host := 'ftp.amortrat.com.br';
  idFTP1.Port := 21;
//  NMFTP1.Timeout := 5000;
  idFTP1.User := 'admin@amortrat.com.br';
  idFTP1.Password := '3251cz';
   try
    idFTP1.Connect;
   except
   On E:Exception do
       writeln(E.message);
   end;

AdvStatus1.Panels[0].Text := 'Conectado!';
sleep(500);
Application.ProcessMessages;
AdvStatus1.Panels[0].Text := 'Selecionando diretório para backup...';
Application.ProcessMessages;
   idFTP1.ChangeDir('web');
   idFTP1.ChangeDir('backup');


//criando arquivo ZIP
sNomeZip := path + '\Backup.rar';
sNomeArq := path + '\*.*';
AdvStatus1.Panels[0].Text := 'Criando arquivo ZIP';
Shell1.CommandLine := PChar('"C:\Arquivos de Programas\WinRar\winrar.exe" a -ep ' + sNomeZip + ' ' + sNomeArq);
//Shell1.CommandLine := PChar('"C:\Program Files\WinRAR\winrar.exe" a -ep ' + sNomeZip + ' ' + sNomeArq);

Shell1.Execute;
//WinExec( PChar('"C:\Arquivos de Programas\WinRar\winrar.exe" a  -pamortrat -ep ' + sNomeZip + ' ' + sNomeArq), SW_SHOWNORMAL );

//Sleep(10000);
//Application.ProcessMessages;

PB.Min := 1;
PB.Max := TamArquivo(path + '\Backup.rar');
PB.Visible := true;

AdvStatus1.Panels[0].Text := 'Arquivo ZIP criado com êxito';

AdvStatus1.Panels[0].Text := 'Enviando log.txt...';
   idFTP1.put(path + '\log.txt','log.txt');
Application.ProcessMessages;
AdvStatus1.Panels[0].Text := 'Enviando arquivo compactado para o servidor! Aguarde...';
   idFTP1.put(path + '\Backup.rar','Backup.rar');

   idFTP1.Disconnect;
AdvStatus1.Panels[0].Text := 'Desconectando do servidor...';

  TBClientes.Active := true;
  TBProc.Active := true;
  TBPecas.Active := true;
  TBOs.Active := true;
  TBOs_Finalizados.Active := true;
  TBNf.Active := true;
  TBUsuario.Active := true;
    TBUsuario.Active := true;
  TBNf_Ref.Active := true;
  TBNf_Itens.Active := true;
  TBConfig.Active := true;
  TBEmail.Active := true;

  AdvStatus1.Panels[0].Text := texto;
  Application.ProcessMessages;
  Application.MessageBox('BACKUP criado com êxito!', 'Assistente para criação de BACKUP', mb_oK+mB_IconInformation);
  PB.Visible := false;
end;
end;

end;

procedure TFprincipal.GerenciadorClick(Sender: TObject);
begin
  FGerrelat.showMODAL;
end;

procedure TFprincipal.ESenhaEnter(Sender: TObject);
begin
TEdit(Sender).color := $00E2F5FE;
TEdit(Sender).Font.Color := clNavy;
TEdit(sender).Font.style := [fsBold];
end;

procedure TFprincipal.ESenhaExit(Sender: TObject);
begin
TEdit(Sender).color := clWhite;
TEdit(Sender).Font.Color := clBlack;
TEdit(Sender).Font.style := [];
end;


procedure TFprincipal.Abertura1Click(Sender: TObject);
begin
FOs.showmodal;
end;

procedure TFprincipal.Finalizao1Click(Sender: TObject);
begin
FFinalizar.showmodal;
end;

procedure TFprincipal.PrecoClick(Sender: TObject);
begin
FReajuste.showmodal;
end;

procedure TFprincipal.UsuarioClick(Sender: TObject);
begin
FUsuarios.showmodal;
end;

procedure TFprincipal.Restaurar1Click(Sender: TObject);
var
 path,texto,sNomeZip, sNomeArq: string;
 log: textfile;
begin
with Modulo do begin


If Application.MessageBox('Bem vindo ao assiste para restauração de backup! Esta ferramenta copiará o último backup online do banco de dados. Deseja continuar?', 'Assistente para restauração de BACKUP', MB_YesNo+MB_IconQuestion) = IDYes then
begin
 Application.MessageBox('Antes de iniciar o processo, certifique-se de que APENAS esta estação está conectada ao sistema, que há conexão com a internet e acompanhe o progresso na barra de status inferior da tela!', 'Assistente para restauração de BACKUP', mb_oK+mB_IconInformation);

 path := AliasToPAth('Amortrat');

texto := AdvStatus1.Panels[0].Text;
AdvStatus1.Panels[0].Text := 'Restaurando backup...';
sleep(500);
AdvStatus1.Panels[0].Text := 'Fechando o banco de dados...';

  TBClientes.Active := false;
  TBProc.Active := false;
  TBPecas.Active := false;
  TBOs.Active := false;
  TBOs_Finalizados.Active := false;
  TBNf.Active := false;
  TBUsuario.Active := false;


AdvStatus1.Panels[0].Text := 'Conectando-se ao servidor...';



  idFTP1.Host := 'ftp.amortrat.com.br';
  idFTP1.Port := 21;
  //NMFTP1.Timeout := 5000;
  idFTP1.User := 'admin@amortrat.com.br';
  idFTP1.Password := '3251cz';
  //NMFTP1.Mode(MODE_BYTE);

   try
    idFTP1.Connect;
   except
   On E:Exception do
       writeln(E.message);
   end;

AdvStatus1.Panels[0].Text := 'Conectado!';
sleep(500);
AdvStatus1.Panels[0].Text := 'Selecionando diretório para backup...';

   idFTP1.ChangeDir('web');
   idFTP1.ChangeDir('backup');

//criando arquivo ZIP
sNomeZip := path + '\Backup.rar';
sNomeArq := path + '\';

PB.Min := 1;
PB.Max := idFTP1.Size('Backup.rar');
PB.Visible := true;

AdvStatus1.Panels[0].Text := 'Executando download do arquivo de backup...';

   idFTP1.Get('Backup.rar', path + '\Backup.rar', true);
   idFTP1.Disconnect;

   AdvStatus1.Panels[0].Text := 'Executando download do arquivo de backup...';

Shell1.CommandLine:= PChar('"C:\Arquivos de Programas\WinRar\winrar.exe" e -o+ -pamortrat$ ' + sNomeZip + ' ' + sNomeArq);
Shell1.Execute;
//WinExec( PChar('"C:\Arquivos de Programas\WinRar\winrar.exe" e -o+ -pamortrat$ ' + sNomeZip + ' ' + sNomeArq), SW_SHOWNORMAL );
//Sleep(10000);
Application.ProcessMessages;
AdvStatus1.Panels[0].Text := 'Desconectando do servidor...';
  TBClientes.Active := true;
  TBProc.Active := true;
  TBPecas.Active := true;
  TBOs.Active := true;
  TBOs_Finalizados.Active := true;
  TBNf.Active := true;
  TBUsuario.Active := true;
  AdvStatus1.Panels[0].Text := texto;

  Application.MessageBox('BACKUP restaurado com êxito!', 'Assistente para restauração de BACKUP', mb_oK+mB_IconInformation);
PB.Visible := false;
end;
end;



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

procedure TFprincipal.NMFTP1TransactionStart(Sender: TObject);
begin
ShowMessage('Iniciou');

end;

procedure TFprincipal.NMFTP1TransactionStop(Sender: TObject);
begin
ShowMessage('Finalizou');

end;

procedure TFprincipal.NMFTP1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin

ShowMessage(Errmsg);

end;

procedure TFprincipal.IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
PB.Position := AWorkCount;
AdvStatus1.Refresh;
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



end.
