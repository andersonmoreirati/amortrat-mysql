unit ULogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IAeverButton, mdTabEnter;

type
  TFLogin = class(TForm)
    ELogin: TComboBox;
    Label1: TLabel;
    ESenha: TEdit;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    BTSair: TIAeverButton;
    BTEntrar: TIAeverButton;
    TabEnter1: TTabEnter;
    procedure FormShow(Sender: TObject);
    procedure ELoginEnter(Sender: TObject);
    procedure ELoginExit(Sender: TObject);
    procedure ESenhaExit(Sender: TObject);
    procedure BTSairClick(Sender: TObject);
    procedure BTEntrarClick(Sender: TObject);
    procedure MigrarSenhaParaBCrypt(const ALogin, ASenha: string);
    procedure BTEntrarEnter(Sender: TObject);
    procedure BTSairExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLogin: TFLogin;

implementation

uses principal, Umodulo, ZDataset, UBCrypt;

{$R *.dfm}

procedure TFLogin.FormShow(Sender: TObject);
// OnShow dispara quando FLogin.ShowModal é chamado (amortrat.dpr linha 106),
// DEPOIS de Modulo ter sido criado (linha 73). OnCreate dispararia na linha 54,
// quando Modulo ainda é nil → AV.
var
  Q: TZQuery;
begin
  if ELogin.Items.Count > 0 then Exit; // já populado (re-exibição do form)

  if (Modulo = nil) or (Modulo.ZConexao = nil) or (not Modulo.ZConexao.Connected) then
    Exit;

  try
    Q := TZQuery.Create(nil);
    try
      Q.Connection := Modulo.ZConexao;
      Q.SQL.Text   := 'SELECT LOGIN FROM tb_usuario ORDER BY LOGIN';
      Q.Open;
      while not Q.Eof do
      begin
        ELogin.Items.Add(Q.FieldByName('LOGIN').AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  except
    // falhou ao carregar lista — ELogin continua funcional como campo de texto
  end;
end;

procedure TFLogin.ELoginEnter(Sender: TObject);
begin
  // ELogin é TComboBox; ESenha é TEdit — ambos usam este handler
  if Sender is TComboBox then
  begin
    TComboBox(Sender).Color      := $00E2F5FE;
    TComboBox(Sender).Font.Color := clNavy;
    TComboBox(Sender).Font.Style := [fsBold];
  end
  else
  begin
    TEdit(Sender).Color      := $00E2F5FE;
    TEdit(Sender).Font.Color := clNavy;
    TEdit(Sender).Font.Style := [fsBold];
  end;
end;

procedure TFLogin.ELoginExit(Sender: TObject);
begin
  if Sender is TComboBox then
  begin
    TComboBox(Sender).Color      := clWhite;
    TComboBox(Sender).Font.Color := clBlack;
    TComboBox(Sender).Font.Style := [];
  end
  else
  begin
    TEdit(Sender).Color      := clWhite;
    TEdit(Sender).Font.Color := clBlack;
    TEdit(Sender).Font.Style := [];
  end;
end;

procedure TFLogin.ESenhaExit(Sender: TObject);
begin
TEdit(Sender).color := clWhite;
TEdit(Sender).Font.Color := clBlack;
TEdit(Sender).Font.style := [];
end;

procedure TFLogin.BTSairClick(Sender: TObject);
begin
FPrincipal.close;
end;

procedure TFLogin.MigrarSenhaParaBCrypt(const ALogin, ASenha: string);
// Upgrade transparente: a senha estava em texto puro e acabou de ser validada,
// então regravamos como bcrypt. O usuário não percebe nada e no próximo login
// já entra pelo caminho criptografado.
//
// Falha aqui NÃO deve impedir o login (o usuário já se autenticou), por isso o
// erro é silencioso — na pior das hipóteses a senha continua em texto puro e a
// migração é tentada de novo no próximo login.
var Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'UPDATE tb_usuario SET SENHA = :pSenha WHERE LOGIN = :pLogin';
    Q.ParamByName('pSenha').AsString := BCryptHashPassword(ASenha);
    Q.ParamByName('pLogin').AsString := ALogin;
    try Q.ExecSQL; except end;
  finally
    Q.Free;
  end;
end;

procedure TFLogin.BTEntrarClick(Sender: TObject);
var
  Q: TZQuery;
  senhaArmazenada: string;
  senhaOk: Boolean;
  precisaUpgrade: Boolean;
begin
  senhaOk := False;
  precisaUpgrade := False;
  // Verificar conexão MySQL
  if Modulo.ZConexao = nil then
  begin
    Application.MessageBox(
      pchar('Sem conexão com o banco de dados MySQL.' + #13#10 +
            'Verifique o arquivo amortrat.ini.'),
      pchar('ERRO DE CONEXÃO'), MB_OK + MB_IconError);
    Exit;
  end;

  // Reconectar se a conexão foi derrubada pelo servidor por inatividade
  if not Modulo.ZConexao.Connected then
  begin
    try
      Modulo.ZConexao.Connect;
    except
      on E: Exception do
      begin
        Application.MessageBox(
          pchar('Não foi possível reconectar ao banco de dados.' + #13#10 + E.Message),
          pchar('ERRO DE CONEXÃO'), MB_OK + MB_IconError);
        Exit;
      end;
    end;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text :=
      'SELECT LOGIN, SENHA, PRECO, USUARIO, CLIENTE, NF, RELATORIOS ' +
      'FROM tb_usuario ' +
      'WHERE LOGIN = :pLogin';
    Q.ParamByName('pLogin').AsString := ELogin.text;

    // Tentar abrir; se o servidor derrubou a conexão (2006), reconectar e tentar de novo
    try
      Q.Open;
    except
      on E: Exception do
      begin
        try
          Modulo.ZConexao.Disconnect;
          Modulo.ZConexao.Connect;
          Q.Open;
        except
          on E2: Exception do
          begin
            Application.MessageBox(
              pchar('Erro ao acessar o banco de dados.' + #13#10 + E2.Message),
              pchar('ERRO DE CONEXÃO'), MB_OK + MB_IconError);
            Exit;
          end;
        end;
      end;
    end;

    if Q.IsEmpty then
    begin
      Application.MessageBox(
        pchar('Seu login de USUÁRIO não existe! Favor entrar com login correto.'),
        pchar('LOGIN INEXISTENTE'), MB_OK + MB_IconInformation);
      ELogin.SetFocus;
      Exit;
    end;

    // ---------------------------------------------------------------------
    // Validação da senha.
    //
    // A coluna SENHA é compartilhada com o portal web, que grava bcrypt
    // ($2a$/$2b$/$2y$, 60 chars). Ainda existem senhas legadas em TEXTO PURO
    // gravadas pelo Delphi antigo. Portanto:
    //   • hash bcrypt   -> valida com BCryptCheckPassword
    //   • texto puro    -> compara direto E, se conferir, faz o UPGRADE
    //                      transparente para bcrypt (o usuário não percebe;
    //                      a partir do próximo login já entra pelo caminho
    //                      criptografado).
    // A unit UBCrypt é verificada contra os vetores oficiais OpenBSD/jBCrypt
    // por TestBCrypt.dpr — não alterar sem rodar aquele teste.
    // ---------------------------------------------------------------------
    senhaArmazenada := Q.FieldByName('SENHA').AsString;

    if IsBCryptHash(senhaArmazenada) then
      senhaOk := BCryptCheckPassword(ESenha.Text, senhaArmazenada)
    else
    begin
      senhaOk := (senhaArmazenada = ESenha.Text);
      precisaUpgrade := senhaOk;   // legado em texto puro que acabou de conferir
    end;

    if not senhaOk then
    begin
      Application.MessageBox(
        pchar('Sua senha de USUÁRIO não confere! Favor entrar com senha correta.'),
        pchar('SENHA INCORRETA'), MB_OK + MB_IconInformation);
      ESenha.SetFocus;
      Exit;
    end;

    if precisaUpgrade then
      MigrarSenhaParaBCrypt(ELogin.Text, ESenha.Text);

    // Guarda quem entrou. Substitui a leitura de TBUsuarioLOGIN.Value que os
    // outros forms faziam sobre o cursor BDE (ex.: UGerrelat, que restringe
    // relatórios para o usuário PRODUCAO).
    Modulo.UsuarioLogado := ELogin.Text;

    // Habilitar/desabilitar itens de menu conforme permissões do usuário.
    // Campos são TINYINT(1) no MySQL → ZeosLib mapeia como TShortIntField,
    // não TBooleanField; usar AsInteger = 0 (0 = liberado, 1 = bloqueado).
    FPrincipal.Menu.Items[0].Items[4].Enabled := Q.FieldByName('PRECO').AsInteger      = 0;
    FPrincipal.Menu.Items[0].Items[3].Enabled := Q.FieldByName('USUARIO').AsInteger    = 0;
    FPrincipal.Menu.Items[0].Items[0].Enabled := Q.FieldByName('CLIENTE').AsInteger    = 0;
    FPrincipal.Menu.Items[0].Items[2].Enabled := Q.FieldByName('CLIENTE').AsInteger    = 0;
    FPrincipal.Menu.Items[0].Items[1].Enabled := Q.FieldByName('CLIENTE').AsInteger    = 0;
    FPrincipal.Menu.Items[2].Enabled          := Q.FieldByName('NF').AsInteger         = 0;
    FPrincipal.Menu.Items[3].Enabled          := Q.FieldByName('RELATORIOS').AsInteger = 0;

    close;
  finally
    Q.Free;
  end;
end;

procedure TFLogin.BTEntrarEnter(Sender: TObject);
begin
TIAeverButton(sender).ButtonColor := $00E2F5FE;
TIAeverButton(sender).ButtonColor1 := clGray;

end;

procedure TFLogin.BTSairExit(Sender: TObject);
begin
TIAeverbutton(sender).ButtonColor := $00CACACA;
TIAeverbutton(sender).ButtonColor1 := $00CACACA;

end;

end.
