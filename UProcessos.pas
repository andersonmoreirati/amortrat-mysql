unit UProcessos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mdTabEnter, ExtCtrls, StdCtrls, IAeverButton, jpeg, Grids;

type
  TFProcessos = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EProcesso: TEdit;
    BTOK: TIAeverButton;
    Panel1: TPanel;
    Panel2: TPanel;
    ECodigo: TEdit;
    GroupBox2: TGroupBox;
    BTGravar: TIAeverButton;
    BTDeletar: TIAeverButton;
    BTLocalizar: TIAeverButton;
    BTSair: TIAeverButton;
    TabEnter1: TTabEnter;
    EObs: TMemo;
    Label13: TLabel;
    Elinha1: TEdit;
    Elinha2: TEdit;
    Elinha3: TEdit;
    Elinha4: TEdit;
    Elinha5: TEdit;
    Elinha6: TEdit;
    Label3: TLabel;
    Image1: TImage;
    procedure BTSairClick(Sender: TObject);
    procedure EProcessoEnter(Sender: TObject);
    procedure BTOKClick(Sender: TObject);
    procedure ECodigoExit(Sender: TObject);
    procedure EProcessoExit(Sender: TObject);
    procedure BTGravarClick(Sender: TObject);
    procedure BTDeletarClick(Sender: TObject);
    procedure BTCancelarClick(Sender: TObject);
    procedure BTLocalizarClick(Sender: TObject);
    procedure BTGravarEnter(Sender: TObject);
    procedure BTGravarExit(Sender: TObject);
    procedure BTDeletarEnter(Sender: TObject);
    procedure BTDeletarExit(Sender: TObject);
    procedure BTLocalizarEnter(Sender: TObject);
    procedure BTLocalizarExit(Sender: TObject);
    procedure BTSairEnter(Sender: TObject);
    procedure BTSairExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Elinha1Enter(Sender: TObject);
    procedure Elinha1Exit(Sender: TObject);
    procedure EObsEnter(Sender: TObject);
    procedure EObsExit(Sender: TObject);
  private
    FEmEdicao: Boolean;   // True quando form está em modo de edição (após BTOKClick)
    FTipo:     string;    // 'gravar' = INSERT, 'alterar' = UPDATE
    { Private declarations }
  public
    procedure Limpar;
    procedure Desabilitar;
    procedure Habilitar;
    procedure FormRefresh(Sender: TObject);
    function  ObterProximoCodigo: string;
    function  ReservarCodigo: Boolean;
    procedure LiberarCodigoReservado;
    { Public declarations }
  end;

var
  FProcessos: TFProcessos;

implementation

uses UModulo, ULocalizar, ZDataset;

{$R *.dfm}

{ ---------------------------------------------------------------------------
  Helpers internos
  --------------------------------------------------------------------------- }

function TFProcessos.ObterProximoCodigo: string;
// Retorna o próximo código disponível em tb_proc formatado com 3 dígitos.
// Ex: se MAX(CODIGO) = '005' → retorna '006'; se tabela vazia → '001'.
var
  Q:      TZQuery;
  MaxCod: Integer;
begin
  Result := '001';
  if (Modulo = nil) or (Modulo.ZConexao = nil) or (not Modulo.ZConexao.Connected) then
    Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text   := 'SELECT MAX(CAST(CODIGO AS UNSIGNED)) FROM tb_proc';
    try
      Q.Open;
      if not Q.Fields[0].IsNull then
      begin
        MaxCod := Q.Fields[0].AsInteger + 1;
        Result := Modulo.RetZero(IntToStr(MaxCod), 3);
      end;
    except
      // manter '001' em caso de falha de conexão
    end;
  finally
    Q.Free;
  end;
end;

function TFProcessos.ReservarCodigo: Boolean;
// Grava um registro-stub só com a chave, RESERVANDO o código no instante do
// clique em OK. Reproduz o Append/Post do BDE, cuja função era justamente
// impedir que dois operadores cadastrassem com o mesmo código.
//
// Se outro usuário reservou o mesmo código no meio do caminho, o MySQL recusa
// com erro 1062 (Duplicate entry). Nesse caso pegamos o próximo código livre e
// tentamos de novo, avisando o operador.
var
  Q:   TZQuery;
  i:   Integer;
  ini: string;
begin
  Result := False;
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  ini := ECodigo.Text;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'INSERT INTO tb_proc (CODIGO) VALUES (:pCodigo)';
    for i := 1 to 10 do
    begin
      Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 3);
      try
        Q.ExecSQL;
        Result := True;
        if ECodigo.Text <> ini then
          Application.MessageBox(
            pchar('O código ' + ini + ' acabou de ser usado por outro usuário.' + #13#10 +
                  'Este cadastro recebeu o código ' + ECodigo.Text + '.'),
            pchar('Código alterado'), MB_OK + MB_IconInformation);
        Exit;
      except
        on E: Exception do
        begin
          if (Pos('duplicate', LowerCase(E.Message)) = 0) and
             (Pos('1062', E.Message) = 0) then
          begin
            Application.MessageBox(pchar('Erro ao reservar o código: ' + E.Message),
              pchar('ERRO'), MB_OK + MB_IconError);
            Exit;
          end;
          ECodigo.Text := ObterProximoCodigo;
        end;
      end;
    end;
  finally
    Q.Free;
  end;

  Application.MessageBox(pchar('Não foi possível reservar um código. Tente novamente.'),
    pchar('AVISO'), MB_OK + MB_IconInformation);
end;

procedure TFProcessos.LiberarCodigoReservado;
// Remove o registro-stub reservado no OK que nunca chegou a ser gravado.
// Equivale ao Delete que o BDE fazia no FormClose.
var Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    // Só apaga se continuar sendo um stub (sem PROCESSO), para nunca remover
    // por engano um cadastro que chegou a ser gravado.
    Q.SQL.Text :=
      'DELETE FROM tb_proc WHERE CODIGO = :pCodigo ' +
      'AND (PROCESSO IS NULL OR PROCESSO = '''')';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 3);
    try Q.ExecSQL; except end;
  finally
    Q.Free;
  end;
end;

procedure TFProcessos.FormRefresh(Sender: TObject);
begin
  // Sem dataset persistente — sem ação necessária.
  // Mantido para compatibilidade com chamadas externas.
end;

procedure TFProcessos.Limpar;
// Limpa todos os campos de texto exceto ECodigo.
// TEdit e TMemo: Clear é público em TCustomEdit — cast genérico OK aqui.
var
  i: Integer;
  C: TComponent;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    C := Components[i];
    if C.Name = 'ECodigo' then Continue;
    if C is TEdit then TEdit(C).Clear
    else if C is TMemo then TMemo(C).Clear;
  end;
end;

procedure TFProcessos.Desabilitar;
// Desabilita campos e botões de edição.
// Color é protegida em TCustomEdit — deve-se usar TEdit ou TMemo diretamente.
var
  i: Integer;
  C: TComponent;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    C := Components[i];
    if C.Name = 'ECodigo' then Continue;

    if C is TEdit then
    begin
      TEdit(C).Enabled := False;
      TEdit(C).Color   := $00EAEAEA;
    end
    else if C is TMemo then
    begin
      TMemo(C).Enabled := False;
      TMemo(C).Color   := $00EAEAEA;
    end;

    if (C is TIAeverButton) and
       (C.Name <> 'BTOK') and
       (C.Name <> 'BTLocalizar') and
       (C.Name <> 'BTSair') then
      TIAeverButton(C).Enabled := False;

    if C is TRadioButton then
      TRadioButton(C).Enabled := False;
  end;
end;

procedure TFProcessos.Habilitar;
// Reabilita campos e botões de edição.
var
  i: Integer;
  C: TComponent;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    C := Components[i];
    if C.Name = 'ECodigo' then Continue;

    if C is TEdit then
    begin
      TEdit(C).Enabled := True;
      TEdit(C).Color   := clWhite;
    end
    else if C is TMemo then
    begin
      TMemo(C).Enabled := True;
      TMemo(C).Color   := clWhite;
    end;

    if (C is TIAeverButton) and
       (C.Name <> 'BTOK') and
       (C.Name <> 'BTLocalizar') and
       (C.Name <> 'BTSair') then
      TIAeverButton(C).Enabled := True;

    if C is TRadioButton then
      TRadioButton(C).Enabled := True;
  end;
end;

{ ---------------------------------------------------------------------------
  Eventos de formulário
  --------------------------------------------------------------------------- }

procedure TFProcessos.FormShow(Sender: TObject);
// A inicialização vive no OnShow, não no OnActivate.
//
// O form é sempre aberto por ShowModal (principal.pas), então o OnShow dispara
// a cada ENTRADA no formulário — e o form nunca reabre sujo, nem depois de um
// processo apenas CONSULTADO.
//
// Por que não no OnActivate: ele dispara também quando o form volta a ganhar
// foco (ex.: ao fechar o FLocalizar ou um dialog de confirmação), e ali a
// reinicialização apagaria o que acabou de ser preenchido.
begin
  FormRefresh(Sender);
  Modulo.NovaLeitura;   // form reabre enxergando dados atuais
  FEmEdicao := False;
  FTipo := '';
  ECodigo.Text := ObterProximoCodigo;
  ECodigo.SetFocus;
  Limpar;
  Desabilitar;
end;

procedure TFProcessos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Saindo com um cadastro cujo código foi reservado no OK mas nunca gravado:
  // apaga o registro-stub, liberando o código. Mesmo comportamento do BDE.
  if FEmEdicao and (FTipo = 'gravar') then
  begin
    if Application.MessageBox(
         pchar('VOCÊ ESTÁ SAINDO COM UM CADASTRO EM ABERTO! ELE SERÁ DELETADO! Deseja prosseguir?'),
         pchar('Saindo do formulário'),
         MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) <> IDYes then
    begin
      Action := caNone;
      Exit;
    end;
    LiberarCodigoReservado;
  end;
  FEmEdicao := False;
  FTipo := '';
end;

{ ---------------------------------------------------------------------------
  Botões principais
  --------------------------------------------------------------------------- }

procedure TFProcessos.BTOKClick(Sender: TObject);
// Determina se o código informado existe (alterar) ou não (gravar),
// habilita os campos e popula-os se for alteração.
var
  Q: TZQuery;
begin
  FTipo := '';

  if ECodigo.Text = '' then
  begin
    ECodigo.SetFocus;
    Exit;
  end;

  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;
  Modulo.NovaLeitura;   // consulta sempre sobre dados atuais

  Habilitar;
  Limpar;
  EProcesso.SetFocus;
  EProcesso.Color := $00E2F5FE;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text :=
      'SELECT CODIGO, PROCESSO, LINHA1, LINHA2, LINHA3, LINHA4, LINHA5, LINHA6, OBS ' +
      'FROM tb_proc WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := ECodigo.Text;

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
              pchar('Erro ao acessar o banco: ' + E2.Message),
              pchar('ERRO DE CONEXÃO'), MB_OK + MB_IconError);
            Exit;
          end;
        end;
      end;
    end;

    if Q.IsEmpty then
    begin
      Q.Close;
      // RESERVA o código agora, como o Append/Post do BDE fazia: sem isso dois
      // usuários simultâneos cadastrariam com o mesmo código.
      if not ReservarCodigo then Exit;
      FTipo := 'gravar';
    end
    else
    begin
      FTipo          := 'alterar';
      EProcesso.Text := Q.FieldByName('PROCESSO').AsString;
      ELinha1.Text   := Q.FieldByName('LINHA1').AsString;
      ELinha2.Text   := Q.FieldByName('LINHA2').AsString;
      ELinha3.Text   := Q.FieldByName('LINHA3').AsString;
      ELinha4.Text   := Q.FieldByName('LINHA4').AsString;
      ELinha5.Text   := Q.FieldByName('LINHA5').AsString;
      ELinha6.Text   := Q.FieldByName('LINHA6').AsString;
      EObs.Text      := Q.FieldByName('OBS').AsString;
    end;
  finally
    Q.Free;
  end;

  FEmEdicao := True;
end;

procedure TFProcessos.BTGravarClick(Sender: TObject);
// INSERT (gravar) ou UPDATE (alterar) conforme FTipo.
var
  Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  if Application.MessageBox(
       pchar('Deseja realmente ' + FTipo + ' esse cadastro?'),
       pchar('Confirmação para ' + FTipo),
       MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) <> IDYes then
  begin
    EProcesso.SetFocus;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;

    // Sempre UPDATE: no caminho 'gravar' o registro já existe, reservado pelo
    // BTOK (ReservarCodigo). Espelha o BDE, onde o Post do Append acontecia no
    // OK e o Gravar apenas preenchia os campos do registro já criado.
    Q.SQL.Text :=
      'UPDATE tb_proc SET ' +
      'PROCESSO=:pProcesso, LINHA1=:pLinha1, LINHA2=:pLinha2, LINHA3=:pLinha3, ' +
      'LINHA4=:pLinha4, LINHA5=:pLinha5, LINHA6=:pLinha6, OBS=:pObs ' +
      'WHERE CODIGO=:pCodigo';

    Q.ParamByName('pCodigo').AsString   := ECodigo.Text;
    Q.ParamByName('pProcesso').AsString := EProcesso.Text;
    Q.ParamByName('pLinha1').AsString   := ELinha1.Text;
    Q.ParamByName('pLinha2').AsString   := ELinha2.Text;
    Q.ParamByName('pLinha3').AsString   := ELinha3.Text;
    Q.ParamByName('pLinha4').AsString   := ELinha4.Text;
    Q.ParamByName('pLinha5').AsString   := ELinha5.Text;
    Q.ParamByName('pLinha6').AsString   := ELinha6.Text;
    Q.ParamByName('pObs').AsString      := EObs.Text;

    try
      Q.ExecSQL;
    except
      on E: Exception do
      begin
        try
          Modulo.ZConexao.Disconnect;
          Modulo.ZConexao.Connect;
          Q.ExecSQL;
        except
          on E2: Exception do
          begin
            Application.MessageBox(
              pchar('Erro ao salvar: ' + E2.Message),
              pchar('ERRO'), MB_OK + MB_IconError);
            Exit;
          end;
        end;
      end;
    end;

    Limpar;
    ECodigo.Text := ObterProximoCodigo;
    ECodigo.SetFocus;
    Desabilitar;
    FEmEdicao := False;
  finally
    Q.Free;
  end;
end;

procedure TFProcessos.BTDeletarClick(Sender: TObject);
// DELETE do processo pelo CODIGO atual.
var
  Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  if Application.MessageBox(
       'Deseja realmente deletar esse cadastro?',
       'Confirmação de Exclusão',
       MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) <> IDYes then
  begin
    EProcesso.SetFocus;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text   := 'DELETE FROM tb_proc WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := ECodigo.Text;

    try
      Q.ExecSQL;
    except
      on E: Exception do
      begin
        try
          Modulo.ZConexao.Disconnect;
          Modulo.ZConexao.Connect;
          Q.ExecSQL;
        except
          on E2: Exception do
          begin
            Application.MessageBox(
              pchar('Erro ao deletar: ' + E2.Message),
              pchar('ERRO'), MB_OK + MB_IconError);
            Exit;
          end;
        end;
      end;
    end;

    Limpar;
    ECodigo.Text := ObterProximoCodigo;
    ECodigo.SetFocus;
    Desabilitar;
    FEmEdicao := False;
  finally
    Q.Free;
  end;
end;

procedure TFProcessos.BTCancelarClick(Sender: TObject);
// Cancela a edição atual sem alterar o banco.
// No MySQL, BTOKClick não pré-insere nada, então apenas resetar a tela.
begin
  if Application.MessageBox(
       'Deseja realmente cancelar esse cadastro?',
       'Confirmação de Cancelamento',
       MB_YESNO + MB_IconQuestion) <> IDYes then
  begin
    EProcesso.SetFocus;
    Exit;
  end;

  Limpar;
  ECodigo.Text := ObterProximoCodigo;
  ECodigo.SetFocus;
  Desabilitar;
  FEmEdicao := False;
end;

procedure TFProcessos.BTLocalizarClick(Sender: TObject);
begin
  FLocalizar.GridProc.Visible  := True;
  FLocalizar.GridCli.Visible   := False;
  FLocalizar.GridPeca.Visible  := False;
  FLocalizar.ShowModal;
end;

procedure TFProcessos.BTSairClick(Sender: TObject);
begin
  Close;
end;

{ ---------------------------------------------------------------------------
  Eventos visuais dos campos (cores de foco — sem alteração de lógica)
  --------------------------------------------------------------------------- }

procedure TFProcessos.EProcessoEnter(Sender: TObject);
begin
  EProcesso.Color      := $00E2F5FE;
  EProcesso.Font.Color := clNavy;
  EProcesso.Font.Style := [fsBold];
end;

procedure TFProcessos.EProcessoExit(Sender: TObject);
begin
  EProcesso.Color      := clWhite;
  EProcesso.Font.Color := clBlack;
  EProcesso.Font.Style := [];
end;

procedure TFProcessos.Elinha1Enter(Sender: TObject);
begin
  TEdit(Sender).Color      := $00E2F5FE;
  TEdit(Sender).Font.Color := clNavy;
  TEdit(Sender).Font.Style := [fsBold];
end;

procedure TFProcessos.Elinha1Exit(Sender: TObject);
begin
  TEdit(Sender).Color      := clWhite;
  TEdit(Sender).Font.Color := clBlack;
  TEdit(Sender).Font.Style := [];
  if ECodigo.Text <> '' then
    ECodigo.Text := Modulo.RetZero(ECodigo.Text, 3);
end;

procedure TFProcessos.ECodigoExit(Sender: TObject);
begin
  ECodigo.Color      := clWhite;
  ECodigo.Font.Color := clBlack;
  ECodigo.Font.Style := [];
  if ECodigo.Text <> '' then
    ECodigo.Text := Modulo.RetZero(ECodigo.Text, 3);
end;

procedure TFProcessos.EObsEnter(Sender: TObject);
begin
  TMemo(Sender).Color      := $00E2F5FE;
  TMemo(Sender).Font.Color := clNavy;
  TMemo(Sender).Font.Style := [fsBold];
end;

procedure TFProcessos.EObsExit(Sender: TObject);
begin
  TMemo(Sender).Color      := clWhite;
  TMemo(Sender).Font.Color := clBlack;
  TMemo(Sender).Font.Style := [];
end;

{ ---------------------------------------------------------------------------
  Eventos visuais dos botões (cores de foco — sem alteração de lógica)
  --------------------------------------------------------------------------- }

procedure TFProcessos.BTGravarEnter(Sender: TObject);
begin
  BTGravar.ButtonColor  := $00E2F5FE;
  BTGravar.ButtonColor1 := clGray;
end;

procedure TFProcessos.BTGravarExit(Sender: TObject);
begin
  BTGravar.ButtonColor  := $00CACACA;
  BTGravar.ButtonColor1 := $00CACACA;
end;

procedure TFProcessos.BTDeletarEnter(Sender: TObject);
begin
  BTDeletar.ButtonColor  := $00E2F5FE;
  BTDeletar.ButtonColor1 := clGray;
end;

procedure TFProcessos.BTDeletarExit(Sender: TObject);
begin
  BTDeletar.ButtonColor  := $00CACACA;
  BTDeletar.ButtonColor1 := $00CACACA;
end;

procedure TFProcessos.BTLocalizarEnter(Sender: TObject);
begin
  BTLocalizar.ButtonColor  := $00E2F5FE;
  BTLocalizar.ButtonColor1 := clGray;
end;

procedure TFProcessos.BTLocalizarExit(Sender: TObject);
begin
  BTLocalizar.ButtonColor  := $00CACACA;
  BTLocalizar.ButtonColor1 := $00CACACA;
end;

procedure TFProcessos.BTSairEnter(Sender: TObject);
begin
  BTSair.ButtonColor  := $00E2F5FE;
  BTSair.ButtonColor1 := clGray;
end;

procedure TFProcessos.BTSairExit(Sender: TObject);
begin
  BTSair.ButtonColor  := $00CACACA;
  BTSair.ButtonColor1 := $00CACACA;
end;

end.
