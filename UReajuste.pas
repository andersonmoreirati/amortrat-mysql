unit UReajuste;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IAeverButton, Mask,
  mdTabEnter, rxCurrEdit, rxToolEdit, DB, ZDataset;

type
  TFReajuste = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ECliente: TEdit;
    EFantasia: TComboBox;   { era TRxLookupEdit — LookupSource=Modulo.DSClientes }
    EPreco: TCurrencyEdit;
    Label5: TLabel;
    GroupBox2: TGroupBox;
    BTGravar: TIAeverButton;
    BTSair: TIAeverButton;
    TabEnter1: TTabEnter;
    QPeca: TZQuery;         { era TRxQuery }
    procedure EClienteEnter(Sender: TObject);
    procedure EFantasiaEnter(Sender: TObject);
    procedure EPrecoEnter(Sender: TObject);
    procedure EClienteExit(Sender: TObject);
    procedure EPrecoExit(Sender: TObject);
    procedure EFantasiaExit(Sender: TObject);
    procedure BTGravarEnter(Sender: TObject);
    procedure BTGravarExit(Sender: TObject);
    procedure BTSairEnter(Sender: TObject);
    procedure BTSairExit(Sender: TObject);
    procedure BTSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EFantasiaChange(Sender: TObject);   { novo — era OnCloseUp+OnKeyUp }
    procedure EClienteChange(Sender: TObject);
    procedure EClienteKeyPress(Sender: TObject; var Key: Char);
    procedure BTGravarClick(Sender: TObject);
  private
    FClientesCod: TStringList;  // ItemIndex -> CODIGO do cliente
    FUpdatingCli: Boolean;      // guard ECliente <-> EFantasia
    function  GarantirConexao: Boolean;
    procedure PopularCombo;
    { Private declarations }
  public
     procedure Limpar;
     procedure FormRefresh(Sender: TObject);
    { Public declarations }
  end;

var
  FReajuste: TFReajuste;

implementation

uses UModulo;

{$R *.dfm}

function TFReajuste.GarantirConexao: Boolean;
// QPeca vem do DFM, mas Modulo.ZConexao é criado em RUNTIME
// (DataModuleCreate) e não existe em design time — a ligação é feita aqui.
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

  QPeca.Connection := Modulo.ZConexao;
  Result := True;
end;

procedure TFReajuste.PopularCombo;
var Q: TZQuery;
begin
  if not GarantirConexao then Exit;
  if FClientesCod = nil then FClientesCod := TStringList.Create;
  if FClientesCod.Count > 0 then Exit;   // já carregado

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'SELECT CODIGO, FANTASIA FROM tb_clientes ORDER BY FANTASIA';
    try
      Q.Open;
      EFantasia.Items.BeginUpdate;
      try
        EFantasia.Items.Clear;
        while not Q.Eof do
        begin
          EFantasia.Items.Add(Q.FieldByName('FANTASIA').AsString);
          FClientesCod.Add(Q.FieldByName('CODIGO').AsString);
          Q.Next;
        end;
      finally
        EFantasia.Items.EndUpdate;
      end;
    except end;
  finally
    Q.Free;
  end;
end;

procedure TFReajuste.FormRefresh(Sender: TObject);
begin
  // Antes fazia TBPecas.Refresh + TBClientes.Refresh (datasets BDE persistentes).
  // Aqui não há dataset persistente aberto — nada a atualizar.
end;

procedure TFReajuste.Limpar;
var
i : Integer;
begin
for i := 0 to FReajuste.ComponentCount - 1 do
if (Freajuste.Components[i] is TCustomEdit) and (FReajuste.Components[i].Name <> 'ECodigo')
 and (FReajuste.Components[i].Name <> 'ECliente')
 then
(Freajuste.Components[i] as TCustomEdit).Clear;
// TComboBox não descende de TCustomEdit, logo fica fora do laço acima
// (antes EFantasia era TRxLookupEdit, que É TCustomEdit).
EFantasia.Text := '';
end;

procedure TFReajuste.EClienteEnter(Sender: TObject);
begin
ECliente.color := $00E2F5FE;
ECliente.Font.Color := clNavy;
ECliente.Font.style := [fsBold];
end;

procedure TFReajuste.EFantasiaEnter(Sender: TObject);
begin
EFantasia.color := $00E2F5FE;
EFantasia.Font.Color := clNavy;
EFantasia.Font.style := [fsBold];
end;

procedure TFReajuste.EPrecoEnter(Sender: TObject);
begin
EPreco.color := $00E2F5FE;
EPreco.Font.Color := clNavy;
EPreco.Font.style := [fsBold];
end;

procedure TFReajuste.EClienteExit(Sender: TObject);
begin
ECliente.color := clWhite;
ECliente.Font.Color := clBlack;
ECliente.Font.style := [];

end;

procedure TFReajuste.EPrecoExit(Sender: TObject);
begin
EPreco.color := clWhite;
EPreco.Font.Color := clBlack;
EPreco.Font.style := [];
end;

procedure TFReajuste.EFantasiaExit(Sender: TObject);
begin
EFantasia.color := clWhite;
Efantasia.Font.Color := clBlack;
Efantasia.Font.style := [];
end;

procedure TFReajuste.BTGravarEnter(Sender: TObject);
begin
BTGravar.ButtonColor := $00E2F5FE;
BTGravar.ButtonColor1 := clGray;

end;

procedure TFReajuste.BTGravarExit(Sender: TObject);
begin
BTGravar.ButtonColor := $00CACACA;
BTGravar.ButtonColor1 := $00CACACA;

end;

procedure TFReajuste.BTSairEnter(Sender: TObject);
begin
BTSAir.ButtonColor := $00E2F5FE;
BTSair.ButtonColor1 := clGray;

end;

procedure TFReajuste.BTSairExit(Sender: TObject);
begin
BTSAir.ButtonColor := $00CACACA;
BTSair.ButtonColor1 := $00CACACA;

end;

procedure TFReajuste.BTSairClick(Sender: TObject);
begin
close;
end;

procedure TFReajuste.FormShow(Sender: TObject);
// A inicialização vive no OnShow (o form é aberto por ShowModal), garantindo
// que ele nunca reabra sujo. Ver mesma decisão nos demais forms migrados.
//
// Removido daqui o `Application.OnActivate := FormRefresh` que existia no
// OnActivate: aquilo instalava um handler GLOBAL da aplicação que dava
// Refresh nos datasets BDE a cada ativação de qualquer janela — efeito
// colateral em todo o sistema, e sem sentido agora que não há dataset
// persistente aberto.
begin
  if not GarantirConexao then Exit;
  Modulo.NovaLeitura;   // combo sempre com dados atuais
  PopularCombo;
  Limpar;
  EFantasia.Text := '';
  ECliente.Text  := '';
  EFantasia.SetFocus;
end;

procedure TFReajuste.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  QPeca.Close;
end;

procedure TFReajuste.EFantasiaChange(Sender: TObject);
// Usuário escolhe o cliente no combo -> preenche ECliente com o CODIGO.
// Substitui o par OnCloseUp/OnKeyUp do antigo TRxLookupEdit, que lia o
// registro corrente de Modulo.DSClientes.
var idx: Integer;
begin
  if FUpdatingCli then Exit;

  idx := EFantasia.ItemIndex;
  if (FClientesCod <> nil) and (idx >= 0) and (idx < FClientesCod.Count) then
  begin
    FUpdatingCli := True;
    try
      ECliente.Text := FClientesCod[idx];
    finally
      FUpdatingCli := False;
    end;
  end
  else if EFantasia.Text = '' then
  begin
    FUpdatingCli := True;
    try
      ECliente.Text := '';
    finally
      FUpdatingCli := False;
    end;
  end;
end;

procedure TFReajuste.EClienteChange(Sender: TObject);
// Usuário digita o código -> resolve a FANTASIA.
// Antes usava TBClientes.FindKey/GotoKey e ainda aplicava um Filter em TBPecas
// (que aqui não é necessário: o UPDATE em lote filtra pelo COD_CLI direto).
var Q: TZQuery;
begin
  if FUpdatingCli then Exit;
  if not GarantirConexao then Exit;

  if ECliente.Text = '' then
  begin
    FUpdatingCli := True;
    try EFantasia.Text := ''; finally FUpdatingCli := False; end;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'SELECT FANTASIA FROM tb_clientes WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECliente.Text, 4);
    try
      Q.Open;
      FUpdatingCli := True;
      try
        if not Q.IsEmpty then
          EFantasia.Text := Q.FieldByName('FANTASIA').AsString
        else
          EFantasia.Text := '';
      finally
        FUpdatingCli := False;
      end;
    except end;
  finally
    Q.Free;
  end;
end;

procedure TFReajuste.EClienteKeyPress(Sender: TObject; var Key: Char);
begin
  Key := Modulo.Number(Key);
end;

procedure TFReajuste.BTGravarClick(Sender: TObject);
// Reajuste em LOTE: aplica o preço informado a TODAS as peças do cliente.
var afetadas: Integer;
begin
  if ECliente.Text = '' then
  begin
    Application.MessageBox('Escolha primeiro o cliente!', 'AVISO',
      MB_OK + MB_IconInformation);
    EFantasia.SetFocus;
    Exit;
  end;

  if EPreco.Value <= 0 then
  begin
    Application.MessageBox('Informe o novo preço!', 'AVISO',
      MB_OK + MB_IconInformation);
    EPreco.SetFocus;
    Exit;
  end;

  if not GarantirConexao then Exit;

  If Application.MessageBox(
       pchar('Voce tem certeza que deseja atualizar os preços dos produtos para este cliente?'),
       pchar('Confirmação para Reajuste de Preço'),
       MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) <> IDYes then Exit;

  Try
    QPeca.Close;
    // Antes: SQL concatenado, com aspas duplas (sintaxe Paradox) e troca manual
    // de ',' por '.' no valor. Agora parametrizado — o driver cuida do formato
    // decimal e não há como injetar nada pelo campo.
    QPeca.SQL.Text :=
      'UPDATE tb_pecas SET PRECO = :pPreco WHERE COD_CLI = :pCli';
    QPeca.ParamByName('pPreco').AsFloat := EPreco.Value;
    QPeca.ParamByName('pCli').AsString  := Modulo.RetZero(ECliente.Text, 4);
    QPeca.ExecSQL;
    afetadas := QPeca.RowsAffected;
    QPeca.Close;

    Application.MessageBox(
      pchar('Preços atualizados com êxito!' + #13#10 +
            IntToStr(afetadas) + ' peça(s) reajustada(s).'),
      'AVISO', MB_Ok + MB_IconInformation);
  except
    on E: Exception do
      ShowMessage(E.ClassName + ': ' + E.Message);
  end;
end;

end.
