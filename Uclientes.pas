unit Uclientes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mdTabEnter, ExtCtrls, StdCtrls, Mask, mdCpfCnpj,
  IAeverButton, jpeg, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Grids, BaseGrid,
  AdvGrid, rxCurrEdit, UModulo;

type
  TFClientes = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    ERazao: TEdit;
    EFantasia: TEdit;
    ECNPJ: TCpfCnpj;
    EEnd: TEdit;
    EBairro: TEdit;
    ECidade: TEdit;
    EEstado: TComboBox;
    ECEP: TMaskEdit;
    ETel1: TMaskEdit;
    ETel2: TMaskEdit;
    EResp: TEdit;
    ECargo: TEdit;
    BTOK: TIAeverButton;
    Panel1: TPanel;
    Panel2: TPanel;
    TabEnter1: TTabEnter;
    ECodigo: TEdit;
    Image1: TImage;
    GroupBox2: TGroupBox;
    BTGravar: TIAeverButton;
    BTDeletar: TIAeverButton;
    BTLimpar: TIAeverButton;
    BTLocalizar: TIAeverButton;
    BTSair: TIAeverButton;
    EEmail: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    EHome: TEdit;
    OPInativo: TCheckBox;       { era TDBCheckBox — BDE removido }
    ECodMunicipio: TEdit;
    Label17: TLabel;
    Enumero: TEdit;
    Label18: TLabel;
    BTBuscar: TIAeverButton;
    IdHTTP1: TIdHTTP;
    BTMais: TIAeverButton;
    BTMenos: TIAeverButton;
    Label19: TLabel;
    ELtMinimo: TCurrencyEdit;
    Label20: TLabel;
    OPEmailCQ: TCheckBox;
    GridEmail: TAdvStringGrid;
    EInsc: TEdit;
    procedure BTLimparClick(Sender: TObject);
    procedure BTSairClick(Sender: TObject);
    procedure BTOKClick(Sender: TObject);
    procedure ERazaoEnter(Sender: TObject);
    procedure ECodigoEnter(Sender: TObject);
    procedure EFantasiaEnter(Sender: TObject);
    procedure ECNPJEnter(Sender: TObject);
    procedure EInscEnter(Sender: TObject);
    procedure EEndEnter(Sender: TObject);
    procedure EBairroEnter(Sender: TObject);
    procedure ECidadeEnter(Sender: TObject);
    procedure EEstadoEnter(Sender: TObject);
    procedure ECEPEnter(Sender: TObject);
    procedure ETel1Enter(Sender: TObject);
    procedure ETel2Enter(Sender: TObject);
    procedure ERespEnter(Sender: TObject);
    procedure ECargoEnter(Sender: TObject);
    procedure ECodigoExit(Sender: TObject);
    procedure ERazaoExit(Sender: TObject);
    procedure EFantasiaExit(Sender: TObject);
    procedure ECNPJExit(Sender: TObject);
    procedure EInscExit(Sender: TObject);
    procedure EEndExit(Sender: TObject);
    procedure EBairroExit(Sender: TObject);
    procedure ECidadeExit(Sender: TObject);
    procedure EEstadoExit(Sender: TObject);
    procedure ECEPExit(Sender: TObject);
    procedure ETel1Exit(Sender: TObject);
    procedure ETel2Exit(Sender: TObject);
    procedure ERespExit(Sender: TObject);
    procedure ECargoExit(Sender: TObject);
    procedure BTGravarClick(Sender: TObject);
    procedure BTCancelarClick(Sender: TObject);
    procedure BTDeletarClick(Sender: TObject);
    procedure ECodigoKeyPress(Sender: TObject; var Key: Char);
    procedure BTLocalizarClick(Sender: TObject);
    procedure BTDeletarEnter(Sender: TObject);
    procedure BTDeletarExit(Sender: TObject);
    procedure BTGravarEnter(Sender: TObject);
    procedure BTLimparEnter(Sender: TObject);
    procedure BTLocalizarEnter(Sender: TObject);
    procedure BTSairEnter(Sender: TObject);
    procedure BTGravarExit(Sender: TObject);
    procedure BTLimparExit(Sender: TObject);
    procedure BTLocalizarExit(Sender: TObject);
    procedure BTSairExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EEmailEnter(Sender: TObject);
    procedure EEmailExit(Sender: TObject);
    procedure EnumeroEnter(Sender: TObject);
    procedure ECodMunicipioEnter(Sender: TObject);
    procedure EnumeroExit(Sender: TObject);
    procedure ECodMunicipioExit(Sender: TObject);
    procedure BTBuscarEnter(Sender: TObject);
    procedure BTBuscarExit(Sender: TObject);
    procedure BTBuscarClick(Sender: TObject);
    procedure BTMaisClick(Sender: TObject);
    procedure BTMenosClick(Sender: TObject);
  private
    FEmEdicao: Boolean;
    FTipo:     string;   // 'gravar' | 'alterar'
    procedure Limpar;
    procedure Desabilitar;
    procedure Habilitar;
    procedure FormRefresh(Sender: TObject);
    function  ObterProximoCodigo: string;
    function  ReservarCodigo: Boolean;
    procedure LiberarCodigoReservado;
    function  splitstr(Frase, Inicio, Fim: String): String;
    function  func_VerifEmail(email: string): boolean;
    { Helpers de máscara — ver comentário em SoDigitos }
    function  SoDigitos(const s: string): string;
    function  MascaraCnpjParaTela(const valor: string): string;
    function  MascaraCnpjParaBanco(const valor: string): string;
    function  MascaraTelParaTela(const valor: string): string;
  public
    { Public declarations }
  end;

const
  msg1  = 'Caractere(s) inválido(s) no início do e-mail.';
  msg2  = 'Símbolo @ não foi encontrado.';
  msg3  = 'Excesso do símbolo @.';
  msg4  = 'Caractere(s) inválido(s) antes do símbolo @.';
  msg5  = 'Caractere(s) inválido(s) depois do símbolo @.';
  msg6  = 'Agrupamento de caractere(s) inválido(s) a esquerda do @.';
  msg7  = 'Não existe ponto(s) digitado(s).';
  msg8  = 'Ponto encontrado no final do e-mail.';
  msg9  = 'Ausência de caractere(s) após o último ponto.';
  msg10 = 'Excesso de ponto(s) a direita do @.';
  msg11 = 'Ponto(s) disposto(s) de forma errada após o @.';
  msg12 = 'Caractere(s) inválido(s) antes do ponto.';
  msg13 = 'Caractere(s) inválido(s) depois do ponto.';

var
  FClientes: TFClientes;
  vet_valido: array [0..35] of string = (
    '0','1','2','3','4','5','6','7','8','9',
    'a','b','c','d','e','f','g','h','i','j',
    'k','l','m','n','o','p','q','r','s','t',
    'u','v','w','x','y','z');

implementation

uses ULocalizar, ZDataset;

{$R *.dfm}

{ ---------------------------------------------------------------------------
  Helpers de máscara

  Contexto do problema (BDE/Paradox -> MySQL):

  O terceiro parâmetro do EditMask controla MaskSave:
    '99.999.999/9999-99;0;_'  -> MaskSave = FALSE -> .Text contém SÓ os slots
    '99999-999;1;_'           -> MaskSave = TRUE  -> .Text contém os literais

  No MySQL os dados chegaram em formatos MISTOS:
    CNPJ = '01.150.252/0001-60'  (formatado)   mas a máscara é MaskSave=False
    CEP  = '09688-000'           (formatado) e a máscara é MaskSave=True  -> OK
    TEL1 = '1143437703'          (dígitos)    e a máscara tem 11 slots

  Atribuir '01.150.252/0001-60' num MaskEdit MaskSave=False faz o controle
  consumir cada '.' e '/' como se fosse um dígito, produzindo
  '01..15.0.2/52/0-00'. Por isso todo valor precisa ser normalizado.
  --------------------------------------------------------------------------- }

function TFClientes.SoDigitos(const s: string): string;
// Remove qualquer caractere que não seja dígito.
var i: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if (s[i] >= '0') and (s[i] <= '9') then
      Result := Result + s[i];
end;

function TFClientes.MascaraCnpjParaTela(const valor: string): string;
// ECNPJ tem máscara MaskSave=False (14 slots) -> devolve apenas os dígitos.
begin
  Result := SoDigitos(valor);
end;

function TFClientes.MascaraCnpjParaBanco(const valor: string): string;
// O banco guarda o CNPJ FORMATADO ('01.150.252/0001-60') e existe sincronização
// com o Paradox por sync_hash — gravar dígitos puros divergiria o hash.
// Reaplica a formatação a partir dos dígitos.
var d: string;
begin
  d := SoDigitos(valor);
  if Length(d) = 14 then
    Result := Copy(d, 1, 2)  + '.' + Copy(d, 3, 3)  + '.' +
              Copy(d, 6, 3)  + '/' + Copy(d, 9, 4)  + '-' + Copy(d, 13, 2)
  else if Length(d) = 11 then   // CPF, quando o cliente é pessoa física
    Result := Copy(d, 1, 3)  + '.' + Copy(d, 4, 3)  + '.' +
              Copy(d, 7, 3)  + '-' + Copy(d, 10, 2)
  else
    Result := valor;   // formato inesperado: preserva o que veio, não corrompe
end;

function TFClientes.MascaraTelParaTela(const valor: string): string;
// ETel1/ETel2 têm máscara '(99)99999-9999;0;_' = 11 slots (celular de 9 dígitos).
// Telefone fixo antigo tem 10 dígitos (DDD + 8). Alinhar à esquerda produziria
// '(11)43437-703_'. O '9' da máscara aceita espaço, então injetamos um espaço
// no 3º slot para o número cair como 4+4: '(11) 4343-7703'.
var d: string;
begin
  d := SoDigitos(valor);
  if Length(d) = 10 then
    Result := Copy(d, 1, 2) + ' ' + Copy(d, 3, 8)
  else
    Result := d;
end;

{ ---------------------------------------------------------------------------
  Helpers internos
  --------------------------------------------------------------------------- }

function TFClientes.ReservarCodigo: Boolean;
// Grava um registro-stub só com a chave, RESERVANDO o código no instante do
// clique em OK. Reproduz o Append/Post do BDE, cuja função era justamente
// impedir que dois operadores cadastrassem com o mesmo código.
//
// Colisão (MySQL 1062 Duplicate entry) => pega o próximo código livre e tenta
// de novo, avisando o operador.
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
    Q.SQL.Text := 'INSERT INTO tb_clientes (CODIGO) VALUES (:pCodigo)';
    for i := 1 to 10 do
    begin
      Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 4);
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

procedure TFClientes.LiberarCodigoReservado;
// Remove o registro-stub reservado no OK que nunca chegou a ser gravado.
// Equivale ao Delete que o BDE fazia no FormClose.
var Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    // Só apaga se continuar sendo um stub (sem RAZAO — campo obrigatório no
    // Gravar), para nunca remover por engano um cadastro já gravado.
    Q.SQL.Text :=
      'DELETE FROM tb_clientes WHERE CODIGO = :pCodigo ' +
      'AND (RAZAO IS NULL OR RAZAO = '''')';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 4);
    try Q.ExecSQL; except end;
  finally
    Q.Free;
  end;
end;

function TFClientes.ObterProximoCodigo: string;
// Retorna o próximo CODIGO de cliente formatado com 4 dígitos.
var
  Q:      TZQuery;
  MaxCod: Integer;
begin
  Result := '0001';
  if (Modulo = nil) or (Modulo.ZConexao = nil) or not Modulo.ZConexao.Connected then
    Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text   := 'SELECT MAX(CAST(CODIGO AS UNSIGNED)) FROM tb_clientes';
    try
      Q.Open;
      if not Q.Fields[0].IsNull then
      begin
        MaxCod := Q.Fields[0].AsInteger + 1;
        Result := Modulo.RetZero(IntToStr(MaxCod), 4);
      end;
    except
      // manter '0001' em caso de falha
    end;
  finally
    Q.Free;
  end;
end;

procedure TFClientes.FormRefresh(Sender: TObject);
begin
  // Sem dataset persistente — sem ação necessária.
end;

procedure TFClientes.Limpar;
var
  i: Integer;
  C: TComponent;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    C := Components[i];
    if C.Name = 'ECodigo' then Continue;
    if C is TEdit     then TEdit(C).Clear
    else if C is TMaskEdit then TMaskEdit(C).Clear
    else if C is TMemo then TMemo(C).Clear;
  end;
  // Componentes customizados — limpeza direta
  ECNPJ.Clear;
  ELtMinimo.Text := '';

  OPInativo.Checked := False;

  // Limpar grid de e-mails — a guarda evita RemoveRows(1, 0) quando a grid
  // já está reduzida somente à linha fixa de cabeçalho.
  if GridEmail.RowCount > 1 then
  begin
    for i := 1 to GridEmail.RowCount - 1 do
      GridEmail.Rows[i].Clear;
    GridEmail.RemoveRows(1, GridEmail.RowCount - 1);
  end;
end;

procedure TFClientes.Desabilitar;
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
    else if C is TMaskEdit then
    begin
      TMaskEdit(C).Enabled := False;
      TMaskEdit(C).Color   := $00EAEAEA;
    end
    else if C is TMemo then
    begin
      TMemo(C).Enabled := False;
      TMemo(C).Color   := $00EAEAEA;
    end
    else if C is TComboBox then
    begin
      TComboBox(C).Enabled := False;
      TComboBox(C).Color   := $00EAEAEA;
    end;

    if (C is TIAeverButton) and
       (C.Name <> 'BTOK') and
       (C.Name <> 'BTLocalizar') and
       (C.Name <> 'BTSair') then
      TIAeverButton(C).Enabled := False;
  end;
  // Componentes customizados
  ECNPJ.Enabled      := False;
  ELtMinimo.Enabled  := False;
  OPInativo.Enabled  := False;
end;

procedure TFClientes.Habilitar;
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
    else if C is TMaskEdit then
    begin
      TMaskEdit(C).Enabled := True;
      TMaskEdit(C).Color   := clWhite;
    end
    else if C is TMemo then
    begin
      TMemo(C).Enabled := True;
      TMemo(C).Color   := clWhite;
    end
    else if C is TComboBox then
    begin
      TComboBox(C).Enabled := True;
      TComboBox(C).Color   := clWhite;
    end;

    if (C is TIAeverButton) and
       (C.Name <> 'BTOK') and
       (C.Name <> 'BTLocalizar') and
       (C.Name <> 'BTSair') then
      TIAeverButton(C).Enabled := True;
  end;
  ECNPJ.Enabled     := True;
  ELtMinimo.Enabled := True;
  OPInativo.Enabled := True;
end;

{ ---------------------------------------------------------------------------
  Eventos de formulário
  --------------------------------------------------------------------------- }

procedure TFClientes.FormShow(Sender: TObject);
// A inicialização vive no OnShow, não no OnActivate.
//
// O form é sempre aberto por ShowModal (principal.pas), então o OnShow dispara
// a cada ENTRADA no formulário — e o form nunca reabre sujo, nem depois de um
// cadastro apenas CONSULTADO.
//
// Por que não no OnActivate: ele dispara também quando o form volta a ganhar
// foco (ex.: ao fechar o FLocalizar), e ali a reinicialização apagaria o que
// acabou de ser preenchido.
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


procedure TFClientes.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TFClientes.BTOKClick(Sender: TObject);
// Verifica se o código existe (alterar) ou não (gravar).
// NÃO pré-insere nada no banco.
var
  Q:   TZQuery;
  idx: Integer;
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
  ERazao.SetFocus;
  ERazao.Color := $00E2F5FE;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text :=
      'SELECT CODIGO, RAZAO, FANTASIA, CNPJ, INSC_EST, ENDERECO, NUMERO, ' +
      'BAIRRO, CIDADE, COD_MUNICIPIO, ESTADO, CEP, TEL1, TEL2, ' +
      'RESPONSAVEL, CARGO, HOME, INATIVO, LT_MINIMO ' +
      'FROM tb_clientes WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 4);

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
            Application.MessageBox(pchar('Erro ao acessar o banco: ' + E2.Message),
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
      FTipo := 'alterar';
      ERazao.Text       := Q.FieldByName('RAZAO').AsString;
      EFantasia.Text    := Q.FieldByName('FANTASIA').AsString;
      ECNPJ.Text        := MascaraCnpjParaTela(Q.FieldByName('CNPJ').AsString);
      EInsc.Text        := Q.FieldByName('INSC_EST').AsString;
      EEnd.Text         := Q.FieldByName('ENDERECO').AsString;
      Enumero.Text      := Q.FieldByName('NUMERO').AsString;
      EBairro.Text      := Q.FieldByName('BAIRRO').AsString;
      ECidade.Text      := Q.FieldByName('CIDADE').AsString;
      ECodMunicipio.Text := Q.FieldByName('COD_MUNICIPIO').AsString;
      EEstado.Text      := Q.FieldByName('ESTADO').AsString;
      ECEP.Text         := Q.FieldByName('CEP').AsString;
      ETel1.Text        := MascaraTelParaTela(Q.FieldByName('TEL1').AsString);
      ETel2.Text        := MascaraTelParaTela(Q.FieldByName('TEL2').AsString);
      EResp.Text        := Q.FieldByName('RESPONSAVEL').AsString;
      ECargo.Text       := Q.FieldByName('CARGO').AsString;
      EHome.Text        := Q.FieldByName('HOME').AsString;
      ELtMinimo.Value   := Q.FieldByName('LT_MINIMO').AsFloat;
      OPInativo.Checked := Q.FieldByName('INATIVO').AsInteger <> 0;
    end;
  finally
    Q.Free;
  end;

  // Carregar e-mails na grid se for alteração
  if FTipo = 'alterar' then
  begin
    Q := TZQuery.Create(nil);
    try
      Q.Connection := Modulo.ZConexao;
      // DISTINCT: a tabela tem linhas repetidas herdadas de sincronizações
      // anteriores com o Paradox (mesmo EMAIL para o mesmo COD_CLIENTE).
      Q.SQL.Text   :=
        'SELECT DISTINCT EMAIL, FLG_CQ FROM tb_email ' +
        'WHERE COD_CLIENTE = :pCodigo ORDER BY EMAIL';
      Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 4);
      try
        Q.Open;
        idx := 1;
        while not Q.Eof do
        begin
          GridEmail.AddRow;
          GridEmail.Cells[0, idx] := Q.FieldByName('EMAIL').AsString;
          GridEmail.Cells[1, idx] := Q.FieldByName('FLG_CQ').AsString;
          Inc(idx);
          Q.Next;
        end;
      except end;
    finally
      Q.Free;
    end;
  end;

  FEmEdicao := True;
end;

procedure TFClientes.BTGravarClick(Sender: TObject);
var
  Q:   TZQuery;
  idx: Integer;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  if ERazao.Text = '' then
  begin
    Application.MessageBox('O campo Razão Social deve ser preenchido!',
      'AVISO', MB_OK + MB_IconInformation);
    ERazao.SetFocus;
    Exit;
  end;

  if ECNPJ.Text = '' then
  begin
    Application.MessageBox('O campo CNPJ deve ser preenchido!',
      'AVISO', MB_OK + MB_IconInformation);
    ECNPJ.SetFocus;
    Exit;
  end;

  if EInsc.Text = '' then
  begin
    Application.MessageBox('O campo Inscrição Estadual deve ser preenchido!',
      'AVISO', MB_OK + MB_IconInformation);
    EInsc.SetFocus;
    Exit;
  end;

  if Application.MessageBox(
       pchar('Deseja realmente ' + FTipo + ' esse cadastro?'),
       pchar('Confirmação para ' + FTipo),
       MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) <> IDYes then
  begin
    ERazao.SetFocus;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;

    // Sempre UPDATE: no caminho 'gravar' o registro já existe, reservado pelo
    // BTOK (ReservarCodigo). Espelha o BDE, onde o Post do Append acontecia no
    // OK e o Gravar apenas preenchia os campos do registro já criado.
    Q.SQL.Text :=
      'UPDATE tb_clientes SET ' +
      'RAZAO=:pRazao, FANTASIA=:pFantasia, CNPJ=:pCnpj, INSC_EST=:pInsc, ' +
      'ENDERECO=:pEnd, NUMERO=:pNum, BAIRRO=:pBairro, CIDADE=:pCidade, ' +
      'COD_MUNICIPIO=:pCodMun, ESTADO=:pEstado, CEP=:pCep, ' +
      'TEL1=:pTel1, TEL2=:pTel2, RESPONSAVEL=:pResp, CARGO=:pCargo, ' +
      'HOME=:pHome, INATIVO=:pInativo, LT_MINIMO=:pLtMin ' +
      'WHERE CODIGO=:pCodigo';

    Q.ParamByName('pCodigo').AsString  := Modulo.RetZero(ECodigo.Text, 4);
    Q.ParamByName('pRazao').AsString   := ERazao.Text;
    Q.ParamByName('pFantasia').AsString := EFantasia.Text;
    Q.ParamByName('pCnpj').AsString    := MascaraCnpjParaBanco(ECNPJ.Text);
    Q.ParamByName('pInsc').AsString    := EInsc.Text;
    Q.ParamByName('pEnd').AsString     := EEnd.Text;
    Q.ParamByName('pNum').AsString     := Enumero.Text;
    Q.ParamByName('pBairro').AsString  := EBairro.Text;
    Q.ParamByName('pCidade').AsString  := ECidade.Text;
    Q.ParamByName('pCodMun').AsString  := ECodMunicipio.Text;
    Q.ParamByName('pEstado').AsString  := EEstado.Text;
    Q.ParamByName('pCep').AsString     := ECEP.Text;
    // O banco guarda telefone como dígitos puros — remove o espaço de
    // alinhamento que MascaraTelParaTela injeta para o fixo de 8 dígitos.
    Q.ParamByName('pTel1').AsString    := SoDigitos(ETel1.Text);
    Q.ParamByName('pTel2').AsString    := SoDigitos(ETel2.Text);
    Q.ParamByName('pResp').AsString    := EResp.Text;
    Q.ParamByName('pCargo').AsString   := ECargo.Text;
    Q.ParamByName('pHome').AsString    := EHome.Text;
    Q.ParamByName('pLtMin').AsFloat    := ELtMinimo.Value;
    if OPInativo.Checked then
      Q.ParamByName('pInativo').AsInteger := 1
    else
      Q.ParamByName('pInativo').AsInteger := 0;

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
            Application.MessageBox(pchar('Erro ao salvar cliente: ' + E2.Message),
              pchar('ERRO'), MB_OK + MB_IconError);
            Exit;
          end;
        end;
      end;
    end;
  finally
    Q.Free;
  end;

  // Gerenciar e-mails: apagar os antigos e re-inserir da grid
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'DELETE FROM tb_email WHERE COD_CLIENTE = :pCodigo';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 4);
    try Q.ExecSQL; except end;

    for idx := 1 to GridEmail.RowCount - 1 do
    begin
      Q.SQL.Text :=
        'INSERT INTO tb_email (COD_CLIENTE, EMAIL, FLG_CQ) ' +
        'VALUES (:pCodigo, :pEmail, :pFlg)';
      Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 4);
      Q.ParamByName('pEmail').AsString  := GridEmail.Cells[0, idx];
      Q.ParamByName('pFlg').AsString    := GridEmail.Cells[1, idx];
      try Q.ExecSQL; except end;
    end;
  finally
    Q.Free;
  end;

  Limpar;
  ECodigo.Text := ObterProximoCodigo;
  ECodigo.SetFocus;
  Desabilitar;
  FEmEdicao := False;
end;

procedure TFClientes.BTDeletarClick(Sender: TObject);
var
  Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  if Application.MessageBox('Deseja realmente deletar esse cadastro?',
     'Confirmação de Exclusão',
     MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) <> IDYes then
  begin
    ERazao.SetFocus;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;

    // Apagar e-mails vinculados
    Q.SQL.Text := 'DELETE FROM tb_email WHERE COD_CLIENTE = :pCodigo';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 4);
    try Q.ExecSQL; except end;

    // Apagar o cliente
    Q.SQL.Text := 'DELETE FROM tb_clientes WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 4);
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
            Application.MessageBox(pchar('Erro ao deletar: ' + E2.Message),
              pchar('ERRO'), MB_OK + MB_IconError);
            Exit;
          end;
        end;
      end;
    end;
  finally
    Q.Free;
  end;

  Limpar;
  ECodigo.Text := ObterProximoCodigo;
  ECodigo.SetFocus;
  Desabilitar;
  FEmEdicao := False;
end;

procedure TFClientes.BTCancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja realmente cancelar esse cadastro?',
     'Confirmação de Cancelamento',
     MB_YESNO + MB_IconQuestion) <> IDYes then
  begin
    ERazao.SetFocus;
    Exit;
  end;
  // No MySQL, BTOKClick não pré-inseriu nada — apenas resetar a tela.
  Limpar;
  ECodigo.Text := ObterProximoCodigo;
  ECodigo.SetFocus;
  Desabilitar;
  FEmEdicao := False;
end;

procedure TFClientes.BTLimparClick(Sender: TObject);
begin
  Limpar;
end;

procedure TFClientes.BTSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFClientes.BTLocalizarClick(Sender: TObject);
begin
  FLocalizar.GridCli.Visible   := True;
  FLocalizar.GridProc.Visible  := False;
  FLocalizar.GridPeca.Visible  := False;
  FLocalizar.ShowModal;
end;

{ ---------------------------------------------------------------------------
  Busca de CEP por HTTP
  --------------------------------------------------------------------------- }

procedure TFClientes.BTBuscarClick(Sender: TObject);
var
  retorno, codRetorno: String;
begin
  retorno    := IdHTTP1.Get('http://www.buscarcep.com.br/?cep=' + ECEP.Text + '&formato=string');
  codRetorno := splitstr(retorno, 'resultado=', '&resultado_txt');

  if StrToIntDef(codRetorno, -1) < 1 then
  begin
    Application.MessageBox(
      PChar('Não foi possível localizar o código do município CEP=[' + ECEP.Text + '].' +
            #13 + 'O serviço de consulta pode estar indisponível ou o CEP informado é inválido.' +
            #13 + 'Verifique o CEP e tente novamente.'),
      'AVISO', MB_OK + MB_IconInformation);
    ECodMunicipio.SetFocus;
    Exit;
  end;
  ECodMunicipio.Text := splitstr(retorno, 'ibge_municipio=', '&ibge_municipio_verificador');
  if ECodMunicipio.Text = '' then
    Application.MessageBox(
      PChar('Não foi possível localizar o código do município CEP=[' + ECEP.Text + '].' +
            #13 + 'O serviço de consulta pode estar indisponível ou o CEP informado é inválido.' +
            #13 + 'Verifique o CEP e tente novamente.'),
      'AVISO', MB_OK + MB_IconInformation);
end;

function TFClientes.splitstr(Frase, Inicio, Fim: String): String;
var
  iAux, kAux: Integer;
begin
  Result := '';
  if (Pos(Fim, Frase) <> 0) and (Pos(Inicio, Frase) <> 0) then
  begin
    iAux   := Pos(Inicio, Frase) + Length(Inicio);
    kAux   := Pos(Fim, Frase);
    Result := Copy(Frase, iAux, kAux - iAux);
  end;
end;

{ ---------------------------------------------------------------------------
  Grid de e-mails
  --------------------------------------------------------------------------- }

procedure TFClientes.BTMaisClick(Sender: TObject);
var
  indice: Integer;
begin
  if func_VerifEmail(EEmail.Text) then
  begin
    indice := GridEmail.RowCount;
    GridEmail.AddRow;
    GridEmail.Cells[0, indice] := EEmail.Text;
    if OPEmailCQ.Checked then GridEmail.Cells[1, indice] := 'X';
    EEmail.Clear;
    EEmail.SetFocus;
  end;
end;

procedure TFClientes.BTMenosClick(Sender: TObject);
begin
  if GridEmail.RowCount > 1 then
    GridEmail.RemoveRows(GridEmail.Row, 1);
end;

function TFClientes.func_VerifEmail(email: string): boolean;
var
  i, j, tam_email, simb_arroba, simb_arroba2, qtd_arroba, qtd_pontos,
  qtd_pontos_esq, qtd_pontos_dir, posicao, posicao2, ponto, ponto2: integer;
  vet_email: array [0..49] of string;
  msg: string;
begin
  qtd_pontos := 0; qtd_pontos_esq := 0; qtd_pontos_dir := 0; qtd_arroba := 0;
  posicao := 0; posicao2 := 0; simb_arroba := 0; simb_arroba2 := 0;
  ponto := 0; ponto2 := 0; msg := '';
  Result := True;

  tam_email := Length(email);
  for i := 0 to tam_email - 1 do
  begin
    vet_email[i] := Copy(email, i + 1, 1);
    if vet_email[i] = '@' then
    begin
      Inc(qtd_arroba);
      posicao := i;
    end;
  end;

  if (vet_email[0] = '@') or (vet_email[0] = '.') or (vet_email[0] = '-') then
  begin Result := False; msg := msg1; end;

  if qtd_arroba < 1 then
  begin Result := False; msg := msg2; end
  else if qtd_arroba > 1 then
  begin Result := False; msg := msg3 + ' Encontrado(s): ' + IntToStr(qtd_arroba) + '.'; end
  else
  begin
    for i := 0 to 35 do
    begin
      if vet_email[posicao - 1] <> vet_valido[i] then Inc(simb_arroba)
      else Dec(simb_arroba);
      if vet_email[posicao + 1] <> vet_valido[i] then Inc(simb_arroba2)
      else Dec(simb_arroba2);
    end;
    if simb_arroba = 36 then
    begin Result := False; msg := msg4; end
    else if simb_arroba2 = 36 then
    begin Result := False; msg := msg5; end;
  end;

  for j := 0 to tam_email - 1 do
    if vet_email[j] = '-' then
      if (vet_email[j - 1] = '.') or (vet_email[j - 1] = '-') then
      begin Result := False; msg := msg6; end;

  for i := 0 to tam_email - 1 do
    if vet_email[i] = '.' then
    begin
      Inc(qtd_pontos);
      posicao2 := i + 1;
      if i > posicao then Inc(qtd_pontos_dir)
      else Inc(qtd_pontos_esq);
      if (vet_email[i - 1] = '.') or (vet_email[i - 1] = '-') then
      begin Result := False; msg := msg6; end;
    end;

  if qtd_pontos < 1 then
  begin Result := False; msg := msg7; end
  else if vet_email[tam_email - 1] = '.' then
  begin Result := False; msg := msg8; end
  else if vet_email[tam_email - 2] = '.' then
  begin Result := False; msg := msg9; end
  else if qtd_pontos_dir > 2 then
  begin
    Result := False;
    msg := msg10 + ' Encontrado(s): ' + IntToStr(qtd_pontos) +
           #10 + 'Encontrado(s) a direita do @: ' + IntToStr(qtd_pontos_dir) + '.';
  end
  else if not ((((tam_email - posicao2) = 3) and (qtd_pontos_dir = 1)) or
               (((tam_email - posicao2) = 2) and (qtd_pontos_dir = 2)) or
               (((tam_email - posicao2) = 2) and (qtd_pontos_dir = 1))) then
  begin
    Result := False;
    msg := msg11 + #10 + 'Encontrado(s) a esquerda do @: ' + IntToStr(qtd_pontos_esq) +
           #10 + 'Encontrado(s) a direita do @: ' + IntToStr(qtd_pontos_dir) + '.';
  end
  else
  begin
    for i := 0 to 35 do
    begin
      if vet_email[posicao2 - 2] <> vet_valido[i] then Inc(ponto)
      else Dec(ponto);
      if vet_email[posicao2] <> vet_valido[i] then Inc(ponto2)
      else Dec(ponto2);
    end;
    if ponto = 36 then
    begin Result := False; msg := msg12; end
    else if ponto2 = 36 then
    begin Result := False; msg := msg13; end;
  end;

  if not Result then
    MessageDlg(msg + #10 + 'Formato de E-mail não aceitável!!', mtWarning, [mbRetry], 0);
end;

{ ---------------------------------------------------------------------------
  Eventos visuais — cores de foco
  --------------------------------------------------------------------------- }

procedure TFClientes.ECodigoEnter(Sender: TObject);
begin
  ECodigo.Color := $00E2F5FE;
  ECodigo.Font.Color := clNavy;
  ECodigo.Font.Style := [fsBold];
end;

procedure TFClientes.ECodigoExit(Sender: TObject);
begin
  ECodigo.Color := clWhite;
  ECodigo.Font.Color := clBlack;
  if ECodigo.Text <> '' then
    ECodigo.Text := Modulo.RetZero(ECodigo.Text, 4);
end;

procedure TFClientes.ECodigoKeyPress(Sender: TObject; var Key: Char);
begin
  Key := Modulo.Number(Key);
end;

procedure TFClientes.ERazaoEnter(Sender: TObject);
begin
  ERazao.Color := $00E2F5FE;
  ERazao.Font.Color := clNavy;
  ERazao.Font.Style := [fsBold];
end;

procedure TFClientes.ERazaoExit(Sender: TObject);
begin
  ERazao.Color := clWhite;
  ERazao.Font.Color := clBlack;
  ERazao.Font.Style := [];
end;

procedure TFClientes.EFantasiaEnter(Sender: TObject);
begin
  EFantasia.Color := $00E2F5FE;
  EFantasia.Font.Color := clNavy;
  EFantasia.Font.Style := [fsBold];
end;

procedure TFClientes.EFantasiaExit(Sender: TObject);
begin
  EFantasia.Color := clWhite;
  EFantasia.Font.Color := clBlack;
  EFantasia.Font.Style := [];
end;

procedure TFClientes.ECNPJEnter(Sender: TObject);
begin
  ECNPJ.Color := $00E2F5FE;
  ECNPJ.Font.Color := clNavy;
  ECNPJ.Font.Style := [fsBold];
end;

procedure TFClientes.ECNPJExit(Sender: TObject);
begin
  ECNPJ.Color := clWhite;
  ECNPJ.Font.Color := clBlack;
  ECNPJ.Font.Style := [];
end;

procedure TFClientes.EInscEnter(Sender: TObject);
begin
  EInsc.Color := $00E2F5FE;
  EInsc.Font.Color := clNavy;
  EInsc.Font.Style := [fsBold];
end;

procedure TFClientes.EInscExit(Sender: TObject);
begin
  EInsc.Color := clWhite;
  EInsc.Font.Color := clBlack;
  EInsc.Font.Style := [];
end;

procedure TFClientes.EEndEnter(Sender: TObject);
begin
  EEnd.Color := $00E2F5FE;
  EEnd.Font.Color := clNavy;
  EEnd.Font.Style := [fsBold];
end;

procedure TFClientes.EEndExit(Sender: TObject);
begin
  EEnd.Color := clWhite;
  EEnd.Font.Color := clBlack;
  EEnd.Font.Style := [];
end;

procedure TFClientes.EBairroEnter(Sender: TObject);
begin
  EBairro.Color := $00E2F5FE;
  EBairro.Font.Color := clNavy;
  EBairro.Font.Style := [fsBold];
end;

procedure TFClientes.EBairroExit(Sender: TObject);
begin
  EBairro.Color := clWhite;
  EBairro.Font.Color := clBlack;
  EBairro.Font.Style := [];
end;

procedure TFClientes.ECidadeEnter(Sender: TObject);
begin
  ECidade.Color := $00E2F5FE;
  ECidade.Font.Color := clNavy;
  ECidade.Font.Style := [fsBold];
end;

procedure TFClientes.ECidadeExit(Sender: TObject);
begin
  ECidade.Color := clWhite;
  ECidade.Font.Color := clBlack;
  ECidade.Font.Style := [];
end;

procedure TFClientes.EEstadoEnter(Sender: TObject);
begin
  EEstado.Color := $00E2F5FE;
  EEstado.Font.Color := clNavy;
end;

procedure TFClientes.EEstadoExit(Sender: TObject);
begin
  EEstado.Color := clWhite;
  EEstado.Font.Color := clBlack;
  EEstado.Font.Style := [];
end;

procedure TFClientes.ECEPEnter(Sender: TObject);
begin
  ECEP.Color := $00E2F5FE;
  ECEP.Font.Color := clNavy;
  ECEP.Font.Style := [fsBold];
end;

procedure TFClientes.ECEPExit(Sender: TObject);
begin
  ECEP.Color := clWhite;
  ECEP.Font.Color := clBlack;
  ECEP.Font.Style := [];
end;

procedure TFClientes.ETel1Enter(Sender: TObject);
begin
  ETel1.Color := $00E2F5FE;
  ETel1.Font.Color := clNavy;
  ETel1.Font.Style := [fsBold];
end;

procedure TFClientes.ETel1Exit(Sender: TObject);
begin
  ETel1.Color := clWhite;
  ETel1.Font.Color := clBlack;
  ETel1.Font.Style := [];
end;

procedure TFClientes.ETel2Enter(Sender: TObject);
begin
  ETel2.Color := $00E2F5FE;
  ETel2.Font.Color := clNavy;
  ETel2.Font.Style := [fsBold];
end;

procedure TFClientes.ETel2Exit(Sender: TObject);
begin
  ETel2.Color := clWhite;
  ETel2.Font.Color := clBlack;
  ETel2.Font.Style := [];
end;

procedure TFClientes.ERespEnter(Sender: TObject);
begin
  EResp.Color := $00E2F5FE;
  EResp.Font.Color := clNavy;
  EResp.Font.Style := [fsBold];
end;

procedure TFClientes.ERespExit(Sender: TObject);
begin
  EResp.Color := clWhite;
  EResp.Font.Color := clBlack;
  EResp.Font.Style := [];
end;

procedure TFClientes.ECargoEnter(Sender: TObject);
begin
  ECargo.Color := $00E2F5FE;
  ECargo.Font.Color := clNavy;
  ECargo.Font.Style := [fsBold];
end;

procedure TFClientes.ECargoExit(Sender: TObject);
begin
  ECargo.Color := clWhite;
  ECargo.Font.Color := clBlack;
  ECargo.Font.Style := [];
end;

procedure TFClientes.EEmailEnter(Sender: TObject);
begin
  TEdit(Sender).Color := $00E2F5FE;
  TEdit(Sender).Font.Color := clNavy;
  TEdit(Sender).Font.Style := [fsBold];
end;

procedure TFClientes.EEmailExit(Sender: TObject);
begin
  TEdit(Sender).Color := clWhite;
  TEdit(Sender).Font.Color := clBlack;
  TEdit(Sender).Font.Style := [];
end;

procedure TFClientes.EnumeroEnter(Sender: TObject);
begin
  Enumero.Color := $00E2F5FE;
  Enumero.Font.Color := clNavy;
  Enumero.Font.Style := [fsBold];
end;

procedure TFClientes.EnumeroExit(Sender: TObject);
begin
  Enumero.Color := clWhite;
  Enumero.Font.Color := clBlack;
  Enumero.Font.Style := [];
end;

procedure TFClientes.ECodMunicipioEnter(Sender: TObject);
begin
  ECodMunicipio.Color := $00E2F5FE;
  ECodMunicipio.Font.Color := clNavy;
  ECodMunicipio.Font.Style := [fsBold];
end;

procedure TFClientes.ECodMunicipioExit(Sender: TObject);
begin
  ECodMunicipio.Color := clWhite;
  ECodMunicipio.Font.Color := clBlack;
  ECodMunicipio.Font.Style := [];
end;

{ ---------------------------------------------------------------------------
  Eventos visuais dos botões
  --------------------------------------------------------------------------- }

procedure TFClientes.BTGravarEnter(Sender: TObject);
begin
  BTGravar.ButtonColor  := $00E2F5FE;
  BTGravar.ButtonColor1 := clGray;
end;

procedure TFClientes.BTGravarExit(Sender: TObject);
begin
  BTGravar.ButtonColor  := $00CACACA;
  BTGravar.ButtonColor1 := $00CACACA;
end;

procedure TFClientes.BTDeletarEnter(Sender: TObject);
begin
  BTDeletar.ButtonColor  := $00E2F5FE;
  BTDeletar.ButtonColor1 := clGray;
end;

procedure TFClientes.BTDeletarExit(Sender: TObject);
begin
  BTDeletar.ButtonColor  := $00CACACA;
  BTDeletar.ButtonColor1 := $00CACACA;
end;

procedure TFClientes.BTLimparEnter(Sender: TObject);
begin
  BTLimpar.ButtonColor  := $00E2F5FE;
  BTLimpar.ButtonColor1 := clGray;
end;

procedure TFClientes.BTLimparExit(Sender: TObject);
begin
  BTLimpar.ButtonColor  := $00CACACA;
  BTLimpar.ButtonColor1 := $00CACACA;
end;

procedure TFClientes.BTLocalizarEnter(Sender: TObject);
begin
  BTLocalizar.ButtonColor  := $00E2F5FE;
  BTLocalizar.ButtonColor1 := clGray;
end;

procedure TFClientes.BTLocalizarExit(Sender: TObject);
begin
  BTLocalizar.ButtonColor  := $00CACACA;
  BTLocalizar.ButtonColor1 := $00CACACA;
end;

procedure TFClientes.BTSairEnter(Sender: TObject);
begin
  BTSair.ButtonColor  := $00E2F5FE;
  BTSair.ButtonColor1 := clGray;
end;

procedure TFClientes.BTSairExit(Sender: TObject);
begin
  BTSair.ButtonColor  := $00CACACA;
  BTSair.ButtonColor1 := $00CACACA;
end;

procedure TFClientes.BTBuscarEnter(Sender: TObject);
begin
  BTBuscar.ButtonColor  := $00E2F5FE;
  BTBuscar.ButtonColor1 := clGray;
end;

procedure TFClientes.BTBuscarExit(Sender: TObject);
begin
  BTBuscar.ButtonColor  := $00CACACA;
  BTBuscar.ButtonColor1 := $00CACACA;
end;

end.
