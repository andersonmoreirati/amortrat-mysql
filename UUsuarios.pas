unit UUsuarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IAeverButton, DB, DBCtrls, Grids, DBGrids,
  RXDBCtrl, mdTabEnter, ZDataset;

type
  TFUsuarios = class(TForm)
    GroupBox3: TGroupBox;
    GroupBox2: TGroupBox;
    BTSair: TIAeverButton;
    ESenha: TEdit;
    ELogin: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BTLocalizar: TIAeverButton;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    RxDBGrid1: TRxDBGrid;
    TabEnter1: TTabEnter;
    BTDeletar: TIAeverButton;
    { Dataset MySQL local. Antes os controles liam Modulo.DSUsuario -> TBUsuario
      (TTable BDE); o UModulo segue BDE para os forms ainda nao migrados, por
      isso o dataset vive aqui. TZTable e editavel, igual ao TTable, de modo que
      os TDBCheckBox continuam gravando direto no registro selecionado. }
    ZUsuarios: TZTable;
    DSUsu: TDataSource;
    procedure BTSairClick(Sender: TObject);
    procedure BTLocalizarClick(Sender: TObject);
    procedure ELoginEnter(Sender: TObject);
    procedure ELoginExit(Sender: TObject);
    procedure BTLocalizarEnter(Sender: TObject);
    procedure BTLocalizarExit(Sender: TObject);
    procedure BTDeletarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function GarantirConexao: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FUsuarios: TFUsuarios;


implementation
uses
  UModulo, UBCrypt;
{$R *.dfm}

function TFUsuarios.GarantirConexao: Boolean;
// ZUsuarios vem do DFM, mas Modulo.ZConexao e criado em RUNTIME
// (DataModuleCreate) e nao existe em design time — a ligacao e feita aqui.
begin
  Result := False;
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  if not Modulo.ZConexao.Connected then
    try
      Modulo.ZConexao.Connect;
    except
      on E: Exception do
      begin
        Application.MessageBox(pchar('Erro de conexão: ' + E.Message),
          pchar('ERRO'), MB_OK + MB_IconError);
        Exit;
      end;
    end;

  ZUsuarios.Connection := Modulo.ZConexao;
  Result := True;
end;

procedure TFUsuarios.FormShow(Sender: TObject);
begin
  if not GarantirConexao then Exit;
  Modulo.NovaLeitura;   // lista sempre com dados atuais
  ZUsuarios.Close;
  try
    ZUsuarios.Open;
  except
    on E: Exception do
      Application.MessageBox(pchar('Erro ao abrir os usuários: ' + E.Message),
        pchar('ERRO'), MB_OK + MB_IconError);
  end;
  ELogin.Clear;
  ESenha.Clear;
  ELogin.SetFocus;
end;

procedure TFUsuarios.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Grava uma marcação de permissão que ainda esteja pendente no buffer.
  // Os TDBCheckBox editam o registro direto, como no BDE.
  if ZUsuarios.Active and (ZUsuarios.State in [dsEdit, dsInsert]) then
    try ZUsuarios.Post; except end;
  ZUsuarios.Close;
end;

procedure TFUsuarios.BTSairClick(Sender: TObject);
begin
close;
end;

procedure TFUsuarios.BTLocalizarClick(Sender: TObject);
// ATENÇÃO: apesar do nome, este botão INCLUI um novo usuário.
// Comportamento preservado da versão BDE.
var Q: TZQuery;
begin
  if ELogin.Text = '' then
  begin
    Application.MessageBox('Informe o LOGIN do usuário!', 'AVISO',
      MB_OK + MB_IconInformation);
    ELogin.SetFocus;
    Exit;
  end;

  if ESenha.Text = '' then
  begin
    Application.MessageBox('Informe a SENHA do usuário!', 'AVISO',
      MB_OK + MB_IconInformation);
    ESenha.SetFocus;
    Exit;
  end;

  if not GarantirConexao then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    // Permissões entram todas em 0 (tinyint(1)), como no BDE, que gravava false.
    Q.SQL.Text :=
      'INSERT INTO tb_usuario (LOGIN, SENHA, PRECO, CLIENTE, NF, USUARIO, RELATORIOS) ' +
      'VALUES (:pLogin, :pSenha, 0, 0, 0, 0, 0)';
    Q.ParamByName('pLogin').AsString := ELogin.Text;
    // Senha SEMPRE gravada como hash bcrypt — nunca em texto puro. O formato
    // ($2a$10$...) é o mesmo usado pelo portal web, então os dois sistemas
    // conseguem autenticar o mesmo usuário.
    Q.ParamByName('pSenha').AsString := BCryptHashPassword(ESenha.Text);
    try
      Q.ExecSQL;
    except
      on E: Exception do
      begin
        if (Pos('duplicate', LowerCase(E.Message)) > 0) or (Pos('1062', E.Message) > 0) then
          Application.MessageBox(
            pchar('Já existe um usuário com o login ' + ELogin.Text + '.'),
            pchar('AVISO'), MB_OK + MB_IconInformation)
        else
          Application.MessageBox(pchar('Erro ao incluir o usuário: ' + E.Message),
            pchar('ERRO'), MB_OK + MB_IconError);
        Exit;
      end;
    end;
  finally
    Q.Free;
  end;

  // Recarrega a grid para mostrar o novo usuário
  ZUsuarios.Close;
  try ZUsuarios.Open; except end;

  ELogin.Clear;
  ESenha.Clear;
  ELogin.SetFocus;
end;

procedure TFUsuarios.ELoginEnter(Sender: TObject);
begin
TEdit(Sender).color := $00E2F5FE;
TEdit(Sender).Font.Color := clNavy;
TEdit(sender).Font.style := [fsBold];

end;

procedure TFUsuarios.ELoginExit(Sender: TObject);
begin
TEdit(Sender).color := clWhite;
TEdit(Sender).Font.Color := clBlack;
TEdit(Sender).Font.style := [];
end;

procedure TFUsuarios.BTLocalizarEnter(Sender: TObject);
begin
TIAeverButton(sender).ButtonColor := $00E2F5FE;
TIAeverButton(sender).ButtonColor1 := clGray;

end;

procedure TFUsuarios.BTLocalizarExit(Sender: TObject);
begin
TIAeverbutton(sender).ButtonColor := $00CACACA;
TIAeverbutton(sender).ButtonColor1 := $00CACACA;

end;

procedure TFUsuarios.BTDeletarClick(Sender: TObject);
var login: string;
begin
  if not ZUsuarios.Active then Exit;
  if ZUsuarios.IsEmpty then Exit;

  login := ZUsuarios.FieldByName('LOGIN').AsString;
  if Application.MessageBox(
       pchar('Deseja realmente deletar o usuário ' + login + '?'),
       pchar('Confirmação de Exclusão'),
       MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) <> IDYes then Exit;

  try
    ZUsuarios.Delete;
  except
    on E: Exception do
      Application.MessageBox(pchar('Erro ao deletar o usuário: ' + E.Message),
        pchar('ERRO'), MB_OK + MB_IconError);
  end;
end;

end.
