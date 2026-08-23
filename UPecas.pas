unit UPecas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mdTabEnter, ExtCtrls, StdCtrls, IAeverButton, Mask,
  jpeg, Grids, printers, ComCtrls, BaseGrid, AdvGrid,
  AdvObj, rxToolEdit, rxCurrEdit, AdvPicture;

type
  TFPecas = class(TForm)
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    EDesc: TEdit;
    ECliente: TEdit;
    GroupBox2: TGroupBox;
    BTGravar: TIAeverButton;
    BTDeletar: TIAeverButton;
    BTLimpar: TIAeverButton;
    BTLocalizar: TIAeverButton;
    BTSair: TIAeverButton;
    TabEnter1: TTabEnter;
    EMat: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ECod_proc: TEdit;
    Label7: TLabel;
    EDureza: TEdit;
    Panel2: TPanel;
    BTOK: TIAeverButton;
    ECodigo: TEdit;
    Label8: TLabel;
    EPreco: TCurrencyEdit;
    EFantasia: TComboBox;         { era TRxLookupEdit — LookupSource=Modulo.DSClientes }
    EProcesso: TComboBox;         { era TRxLookupEdit — LookupSource=Modulo.DSProc    }
    EObs: TEdit;
    Label9: TLabel;
    EFigura: TFilenameEdit;
    Label2: TLabel;
    ECodPecaCliente: TEdit;
    Label10: TLabel;
    BTMais: TIAeverButton;
    BTMenos: TIAeverButton;
    Label15: TLabel;
    Label11: TLabel;
    ECodEquip: TEdit;
    Eequip: TComboBox;            { era TRxLookupEdit — LookupSource=DataSource2(QEquip) }
    EProdTeorica: TCurrencyEdit;
    ERevisao: TEdit;
    Label12: TLabel;
    EDataRevisao: TDateEdit;
    Label13: TLabel;
    GridEquip: TAdvStringGrid;
    EMarcha: TEdit;
    Label14: TLabel;
    OpItemSeg: TCheckBox;
    OpAnaliseDet: TCheckBox;
    EPicture: TAdvPicture;
    procedure EFiguraAfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure BTGravarClick(Sender: TObject);
    procedure EClienteEnter(Sender: TObject);
    procedure EFantasiaEnter(Sender: TObject);
    procedure ECodigoEnter(Sender: TObject);
    procedure EDescEnter(Sender: TObject);
    procedure EMatEnter(Sender: TObject);
    procedure EFiguraEnter(Sender: TObject);
    procedure EPrecoEnter(Sender: TObject);
    procedure ECod_procEnter(Sender: TObject);
    procedure EProcessoEnter(Sender: TObject);
    procedure EDurezaEnter(Sender: TObject);
    procedure EClienteExit(Sender: TObject);
    procedure EFantasiaExit(Sender: TObject);
    procedure ECodigoExit(Sender: TObject);
    procedure EDescExit(Sender: TObject);
    procedure EMatExit(Sender: TObject);
    procedure EFiguraExit(Sender: TObject);
    procedure EPrecoExit(Sender: TObject);
    procedure ECod_procExit(Sender: TObject);
    procedure EDurezaExit(Sender: TObject);
    procedure EFantasiaChange(Sender: TObject);   { novo — era EFantasiaCloseUp+KeyUp }
    procedure EProcessoChange(Sender: TObject);   { novo — era EProcessoCloseUp+KeyUp }
    procedure EequipChange(Sender: TObject);      { novo — era EequipCloseUp+KeyUp    }
    procedure BTOKClick(Sender: TObject);
    procedure EClienteChange(Sender: TObject);
    procedure BTSairClick(Sender: TObject);
    procedure BTDeletarClick(Sender: TObject);
    procedure BTCancelarClick(Sender: TObject);
    procedure BTLimparClick(Sender: TObject);
    procedure EClienteKeyPress(Sender: TObject; var Key: Char);
    procedure ECodigoKeyPress(Sender: TObject; var Key: Char);
    procedure ECod_procKeyPress(Sender: TObject; var Key: Char);
    procedure BTLocalizarClick(Sender: TObject);
    procedure ECod_procChange(Sender: TObject);
    procedure BTGravarEnter(Sender: TObject);
    procedure BTDeletarEnter(Sender: TObject);
    procedure BTLimparEnter(Sender: TObject);
    procedure BTLocalizarEnter(Sender: TObject);
    procedure BTSairEnter(Sender: TObject);
    procedure BTGravarExit(Sender: TObject);
    procedure BTDeletarExit(Sender: TObject);
    procedure BTLimparExit(Sender: TObject);
    procedure BTLocalizarExit(Sender: TObject);
    procedure BTSairExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EProcessoExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EObsEnter(Sender: TObject);
    procedure EObsExit(Sender: TObject);
    procedure BTMaisClick(Sender: TObject);
    procedure BTMenosClick(Sender: TObject);
    procedure EMarchaEnter(Sender: TObject);
    procedure EMarchaExit(Sender: TObject);
  private
    FEmEdicao:     Boolean;
    FTipo:         string;      // 'gravar' | 'alterar'
    FClientesCod:  TStringList; // mapeia EFantasia.ItemIndex → CODIGO do cliente
    FProcCod:      TStringList; // mapeia EProcesso.ItemIndex → CODIGO do processo
    FEquipCod:     TStringList; // mapeia Eequip.ItemIndex → CODIGO do equipamento
    FFromFantasia: Boolean;     // guard: EClienteChange chamado por EFantasiaChange
    FUpdatingProc: Boolean;     // guard: sincronização bidirecional ECod_proc ↔ EProcesso
    procedure PopularCombos;
    procedure RefreshEquipCombo;
    function  ProximoCodigoPeca: string;
    function  ReservarCodigo: Boolean;
    procedure LiberarCodigoReservado;
    { Private declarations }
  public
    procedure FormRefresh(Sender: TObject);
    procedure Limpar;
    procedure Desabilitar;
    procedure Habilitar;
    { Public declarations }
  end;

var
  FPecas: TFPecas;

implementation

uses UModulo, ULocalizar, ZDataset;

{$R *.dfm}

{ ---------------------------------------------------------------------------
  Populacao dos combos de autocomplete (clientes e processos)
  --------------------------------------------------------------------------- }

procedure TFPecas.PopularCombos;
var Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) or not Modulo.ZConexao.Connected then
    Exit;

  // Inicializar listas na primeira chamada
  if FClientesCod = nil then FClientesCod := TStringList.Create;
  if FProcCod     = nil then FProcCod     := TStringList.Create;
  if FEquipCod    = nil then FEquipCod    := TStringList.Create;

  // Clientes → EFantasia
  EFantasia.Items.Clear;
  FClientesCod.Clear;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text   := 'SELECT CODIGO, FANTASIA FROM tb_clientes ORDER BY FANTASIA';
    try
      Q.Open;
      while not Q.Eof do
      begin
        EFantasia.Items.Add(Q.FieldByName('FANTASIA').AsString);
        FClientesCod.Add(Q.FieldByName('CODIGO').AsString);
        Q.Next;
      end;
    except end;
  finally
    Q.Free;
  end;

  // Processos → EProcesso
  EProcesso.Items.Clear;
  FProcCod.Clear;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text   := 'SELECT CODIGO, PROCESSO FROM tb_proc ORDER BY PROCESSO';
    try
      Q.Open;
      while not Q.Eof do
      begin
        EProcesso.Items.Add(Q.FieldByName('PROCESSO').AsString);
        FProcCod.Add(Q.FieldByName('CODIGO').AsString);
        Q.Next;
      end;
    except end;
  finally
    Q.Free;
  end;
end;

function TFPecas.ProximoCodigoPeca: string;
// Próximo CODIGO de peça DO CLIENTE corrente (a chave de tb_pecas é composta:
// COD_CLI + CODIGO, logo a numeração é sequencial por cliente).
var Q: TZQuery;
begin
  Result := '001';
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text :=
      'SELECT MAX(CAST(CODIGO AS UNSIGNED)) FROM tb_pecas WHERE COD_CLI = :pCodigo';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECliente.Text, 4);
    try
      Q.Open;
      if not Q.Fields[0].IsNull then
        Result := Modulo.RetZero(IntToStr(Q.Fields[0].AsInteger + 1), 3);
    except
      // mantem '001'
    end;
  finally
    Q.Free;
  end;
end;

function TFPecas.ReservarCodigo: Boolean;
// Grava um registro-stub só com a chave (COD_CLI + CODIGO), RESERVANDO o código
// no instante do clique em OK. Reproduz o Append/Post do BDE, cuja função era
// justamente impedir que dois operadores cadastrassem com o mesmo código.
//
// A chave de tb_pecas é composta, então a numeração é sequencial POR CLIENTE.
// Colisão (MySQL 1062) => recalcula o próximo código do cliente e tenta de novo.
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
    Q.SQL.Text := 'INSERT INTO tb_pecas (COD_CLI, CODIGO) VALUES (:pCli, :pCodigo)';
    for i := 1 to 10 do
    begin
      Q.ParamByName('pCli').AsString    := Modulo.RetZero(ECliente.Text, 4);
      Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 3);
      try
        Q.ExecSQL;
        Result := True;
        if ECodigo.Text <> ini then
          Application.MessageBox(
            pchar('O código ' + ini + ' acabou de ser usado por outro usuário.' + #13#10 +
                  'Esta peça recebeu o código ' + ECodigo.Text + '.'),
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
          // próximo código da peça DESTE cliente
          ECodigo.Text := ProximoCodigoPeca;
        end;
      end;
    end;
  finally
    Q.Free;
  end;

  Application.MessageBox(pchar('Não foi possível reservar um código. Tente novamente.'),
    pchar('AVISO'), MB_OK + MB_IconInformation);
end;

procedure TFPecas.LiberarCodigoReservado;
// Remove o registro-stub reservado no OK que nunca chegou a ser gravado.
// Equivale ao Delete que o BDE fazia no FormClose.
var Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    // Só apaga se continuar sendo um stub (sem DESCRICAO — campo obrigatório no
    // Gravar), para nunca remover por engano uma peça já gravada.
    Q.SQL.Text :=
      'DELETE FROM tb_pecas WHERE COD_CLI = :pCli AND CODIGO = :pCodigo ' +
      'AND (DESCRICAO IS NULL OR DESCRICAO = '''')';
    Q.ParamByName('pCli').AsString    := Modulo.RetZero(ECliente.Text, 4);
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECodigo.Text, 3);
    try Q.ExecSQL; except end;
  finally
    Q.Free;
  end;
end;

procedure TFPecas.RefreshEquipCombo;
// Popula Eequip com equipamentos ainda NÃO adicionados à grid.
var
  Q:       TZQuery;
  equips:  string;
  i:       Integer;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) or not Modulo.ZConexao.Connected then
    Exit;
  if FEquipCod = nil then FEquipCod := TStringList.Create;

  // Construir lista NOT IN baseada no que já está na grid
  // Começa com '' para garantir que a cláusula IN nunca seja vazia
  equips := '''''';
  for i := 1 to GridEquip.RowCount - 1 do
    equips := equips + ', ''' + GridEquip.Cells[0, i] + '''';

  Eequip.Items.Clear;
  FEquipCod.Clear;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text :=
      'SELECT CODIGO, DESCRICAO FROM tb_equipamentos ' +
      'WHERE CODIGO NOT IN (' + equips + ') ORDER BY DESCRICAO';
    try
      Q.Open;
      while not Q.Eof do
      begin
        Eequip.Items.Add(Q.FieldByName('DESCRICAO').AsString);
        FEquipCod.Add(Q.FieldByName('CODIGO').AsString);
        Q.Next;
      end;
    except end;
  finally
    Q.Free;
  end;
end;

{ ---------------------------------------------------------------------------
  Helpers públicos
  --------------------------------------------------------------------------- }

procedure TFPecas.FormRefresh(Sender: TObject);
begin
  // Sem datasets persistentes — sem ação necessária.
end;

procedure TFPecas.Limpar;
var
  i: Integer;
  C: TComponent;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    C := Components[i];
    if (C.Name = 'ECodigo') or (C.Name = 'ECliente') then Continue;
    if C is TEdit then TEdit(C).Clear
    else if C is TMemo then TMemo(C).Clear;
  end;
  // Tipos customizados (não capturados por "is TEdit")
  EPreco.Clear;
  EProdTeorica.Clear;
  EFigura.Text := '';
  EProcesso.Text := '';
  Eequip.Text := '';
  try EDataRevisao.Text := ''; except end;

  OpItemSeg.Checked   := False;
  OpAnaliseDet.Checked := False;

  if GridEquip.RowCount > 1 then
  begin
    for i := 1 to GridEquip.RowCount - 1 do
      GridEquip.Rows[i].Clear;
    GridEquip.RemoveRows(1, GridEquip.RowCount - 1);
  end;
end;

procedure TFPecas.Desabilitar;
var
  i: Integer;
  C: TComponent;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    C := Components[i];
    if (C.Name = 'ECodigo') or (C.Name = 'ECliente') then Continue;

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
  end;
  // Tipos customizados
  EPreco.Enabled      := False;
  EProdTeorica.Enabled := False;
  EFigura.Enabled     := False;
  EDataRevisao.Enabled := False;
  EProcesso.Enabled   := False;
  EProcesso.Color     := $00EAEAEA;
  Eequip.Enabled      := False;
  Eequip.Color        := $00EAEAEA;
  EPicture.Visible    := False;
  OpItemSeg.Enabled   := False;
  OpAnaliseDet.Enabled := False;
end;

procedure TFPecas.Habilitar;
var
  i: Integer;
  C: TComponent;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    C := Components[i];
    if (C.Name = 'ECodigo') or (C.Name = 'ECliente') then Continue;

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
  end;
  EPreco.Enabled      := True;
  EProdTeorica.Enabled := True;
  EFigura.Enabled     := True;
  EDataRevisao.Enabled := True;
  EProcesso.Enabled   := True;
  EProcesso.Color     := clWhite;
  Eequip.Enabled      := True;
  Eequip.Color        := clWhite;
  EPicture.Visible    := True;
  OpItemSeg.Enabled   := True;
  OpAnaliseDet.Enabled := True;
end;

{ ---------------------------------------------------------------------------
  Eventos de formulário
  --------------------------------------------------------------------------- }

procedure TFPecas.FormShow(Sender: TObject);
// A inicialização vive no OnShow, não no OnActivate.
//
// O form é sempre aberto por ShowModal (principal.pas e também pelo FOS), então
// o OnShow dispara a cada ENTRADA — e o form nunca reabre sujo, nem depois de
// uma peça apenas CONSULTADA.
//
// Por que não no OnActivate: ele dispara também quando o form volta a ganhar
// foco (ex.: ao fechar o FLocalizar), e ali a reinicialização apagaria o que
// acabou de ser preenchido.
begin
  Modulo.NovaLeitura;   // combos/consultas sempre sobre dados atuais
  PopularCombos;
  FormRefresh(Sender);
  FEmEdicao := False;
  FTipo := '';
  Habilitar;
  EFantasia.SetFocus;
  Limpar;
  Desabilitar;
  EFantasia.Text := '';
  ECodigo.Text   := '';
  ECliente.Text  := '';
end;


procedure TFPecas.FormClose(Sender: TObject; var Action: TCloseAction);
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
  Autocomplete — sincronização EFantasia ↔ ECliente
  --------------------------------------------------------------------------- }

procedure TFPecas.EFantasiaChange(Sender: TObject);
// Dispara quando o usuário seleciona um item no combo de fantasia.
// Define ECliente.Text com o CODIGO, o que por sua vez dispara EClienteChange.
var idx: Integer;
begin
  if FFromFantasia then Exit;
  idx := EFantasia.ItemIndex;
  if (FClientesCod <> nil) and (idx >= 0) and (idx < FClientesCod.Count) then
  begin
    FFromFantasia := True;
    try
      ECliente.Text := FClientesCod[idx];
      // EClienteChange vai calcular ECodigo
    finally
      FFromFantasia := False;
    end;
  end
  else if EFantasia.Text = '' then
  begin
    ECliente.Text := '';
    ECodigo.Text  := '';
  end;
end;

procedure TFPecas.EClienteChange(Sender: TObject);
// Dispara quando ECliente.Text muda (digitação direta ou por EFantasiaChange).
// Se FFromFantasia=True, FANTASIA já está corretamente preenchida — apenas calcula ECodigo.
// Caso contrário, busca FANTASIA no MySQL e depois calcula ECodigo.
var Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  if ECliente.Text = '' then
  begin
    if not FFromFantasia then EFantasia.Text := '';
    ECodigo.Text := '';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;

    // Sincronizar FANTASIA somente quando não vier de EFantasiaChange
    if not FFromFantasia then
    begin
      Q.SQL.Text := 'SELECT FANTASIA FROM tb_clientes WHERE CODIGO = :pCodigo';
      Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECliente.Text, 4);
      try
        Q.Open;
        if not Q.IsEmpty then
          EFantasia.Text := Q.FieldByName('FANTASIA').AsString
        else
        begin
          EFantasia.Text := '';
          Exit;
        end;
        Q.Close;
      except
        EFantasia.Text := '';
        Exit;
      end;
    end;

  finally
    Q.Free;
  end;

  // Próximo CODIGO de peça para este cliente
  ECodigo.Text := ProximoCodigoPeca;
end;

{ ---------------------------------------------------------------------------
  Autocomplete — sincronização EProcesso ↔ ECod_proc
  --------------------------------------------------------------------------- }

procedure TFPecas.EProcessoChange(Sender: TObject);
// Usuário seleciona processo no combo → preenche ECod_proc.
var idx: Integer;
begin
  if FUpdatingProc then Exit;
  idx := EProcesso.ItemIndex;
  if (FProcCod <> nil) and (idx >= 0) and (idx < FProcCod.Count) then
  begin
    FUpdatingProc := True;
    try
      ECod_proc.Text := FProcCod[idx];
      // ECod_procChange vai disparar mas FUpdatingProc=True então sai logo
    finally
      FUpdatingProc := False;
    end;
  end;
end;

procedure TFPecas.ECod_procChange(Sender: TObject);
// Usuário digita código do processo → busca PROCESSO e preenche EProcesso.
var Q: TZQuery;
begin
  if FUpdatingProc then Exit;
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  FUpdatingProc := True;
  try
    if ECod_proc.Text = '' then
    begin
      EProcesso.Text := '';
      Exit;
    end;
    Q := TZQuery.Create(nil);
    try
      Q.Connection := Modulo.ZConexao;
      Q.SQL.Text := 'SELECT PROCESSO FROM tb_proc WHERE CODIGO = :pCodigo';
      Q.ParamByName('pCodigo').AsString := Modulo.RetZero(ECod_proc.Text, 3);
      try
        Q.Open;
        if not Q.IsEmpty then
          EProcesso.Text := Q.FieldByName('PROCESSO').AsString
        else
          EProcesso.Text := '';
      except
        EProcesso.Text := '';
      end;
    finally
      Q.Free;
    end;
  finally
    FUpdatingProc := False;
  end;
end;

{ ---------------------------------------------------------------------------
  Autocomplete — equipamentos (filtrado pelo que está na grid)
  --------------------------------------------------------------------------- }

procedure TFPecas.EequipChange(Sender: TObject);
// Usuário seleciona equipamento → preenche ECodEquip.
var idx: Integer;
begin
  idx := Eequip.ItemIndex;
  if (FEquipCod <> nil) and (idx >= 0) and (idx < FEquipCod.Count) then
    ECodEquip.Text := FEquipCod[idx]
  else if Eequip.Text = '' then
    ECodEquip.Text := '';
end;

{ ---------------------------------------------------------------------------
  Botão OK — SELECT para determinar modo gravar/alterar
  --------------------------------------------------------------------------- }

procedure TFPecas.BTOKClick(Sender: TObject);
var
  Q:   TZQuery;
  idx: Integer;
begin
  FTipo := '';

  if (ECodigo.Text = '') or (ECliente.Text = '') then
  begin
    EFantasia.SetFocus;
    Exit;
  end;

  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;
  Modulo.NovaLeitura;   // consulta sempre sobre dados atuais

  ECodigo.Text := Modulo.RetZero(ECodigo.Text, 3);

  Habilitar;
  Limpar;
  EDesc.SetFocus;
  EDesc.Color := $00E2F5FE;

  // Verificar se a peça já existe
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text :=
      'SELECT COD_CLI, CODIGO, COD_PROC, DESCRICAO, MATERIAL, PRECO, DUREZA, OBS, ' +
      'COD_PECA_CLI, FIGURA, ITEM_SEG, REVISAO, DATA_REVISAO, ANALISE_DET, MARCHA ' +
      'FROM tb_pecas WHERE COD_CLI = :pCli AND CODIGO = :pCodigo';
    Q.ParamByName('pCli').AsString    := Modulo.RetZero(ECliente.Text, 4);
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
            Application.MessageBox(pchar('Erro ao acessar o banco: ' + E2.Message),
              pchar('ERRO'), MB_OK + MB_IconError);
            Exit;
          end;
        end;
      end;
    end;

    if Q.IsEmpty then
    begin
      Q.Close;
      // RESERVA o código agora, como o Append/Post do BDE fazia: sem isso dois
      // usuários simultâneos cadastrariam peças com o mesmo código.
      if not ReservarCodigo then Exit;
      FTipo := 'gravar';
    end
    else
    begin
      FTipo := 'alterar';
      EDesc.Text           := Q.FieldByName('DESCRICAO').AsString;
      EMat.Text            := Q.FieldByName('MATERIAL').AsString;
      EFigura.Text         := Q.FieldByName('FIGURA').AsString;
      if EFigura.Text <> '' then
        try EPicture.Picture.LoadFromFile(EFigura.Text); except end;
      EPreco.Value         := Q.FieldByName('PRECO').AsFloat;
      ECod_proc.Text       := Q.FieldByName('COD_PROC').AsString;
      EDureza.Text         := Q.FieldByName('DUREZA').AsString;
      EObs.Text            := Q.FieldByName('OBS').AsString;
      ECodPecaCliente.Text := Q.FieldByName('COD_PECA_CLI').AsString;
      ERevisao.Text        := Q.FieldByName('REVISAO').AsString;
      try EDataRevisao.Date := Q.FieldByName('DATA_REVISAO').AsDateTime; except end;
      OpItemSeg.Checked    := Q.FieldByName('ITEM_SEG').AsInteger <> 0;
      OpAnaliseDet.Checked := Q.FieldByName('ANALISE_DET').AsInteger <> 0;
      EMarcha.Text         := Q.FieldByName('MARCHA').AsString;
    end;
  finally
    Q.Free;
  end;

  // Carregar equipamentos da peça na grid (apenas se alterar)
  if FTipo = 'alterar' then
  begin
    Q := TZQuery.Create(nil);
    try
      Q.Connection := Modulo.ZConexao;
      Q.SQL.Text :=
        'SELECT peca.CODIGO_EQUIP, equip.DESCRICAO, peca.VL_PRODUTIVIDADE ' +
        'FROM tb_equipamentos equip ' +
        'JOIN tb_equipamentos_peca peca ON equip.CODIGO = peca.CODIGO_EQUIP ' +
        'WHERE peca.CODIGO_CLI = :pCli AND peca.CODIGO_PECA = :pCodigo';
      Q.ParamByName('pCli').AsString    := Modulo.RetZero(ECliente.Text, 4);
      Q.ParamByName('pCodigo').AsString := ECodigo.Text;
      try
        Q.Open;
        idx := 1;
        while not Q.Eof do
        begin
          GridEquip.AddRow;
          GridEquip.Cells[0, idx] := Q.FieldByName('CODIGO_EQUIP').AsString;
          GridEquip.Cells[1, idx] := Q.FieldByName('DESCRICAO').AsString;
          GridEquip.Cells[2, idx] := FloatToStr(Q.FieldByName('VL_PRODUTIVIDADE').AsFloat);
          Inc(idx);
          Q.Next;
        end;
      except end;
    finally
      Q.Free;
    end;

    RefreshEquipCombo;
  end
  else
    RefreshEquipCombo;

  FEmEdicao := True;
end;

{ ---------------------------------------------------------------------------
  Gravar — INSERT ou UPDATE
  --------------------------------------------------------------------------- }

procedure TFPecas.BTGravarClick(Sender: TObject);
var
  Q:        TZQuery;
  idx:      Integer;
  fileName: string;
  img:      TJPegImage;
  configPath: string;
begin
  if ECliente.Text = '' then
  begin
    Application.MessageBox('O campo Cliente deve ser preenchido!',
      'AVISO', MB_OK + MB_IconInformation);
    ECliente.SetFocus;
    Exit;
  end;
  if EDesc.Text = '' then
  begin
    Application.MessageBox('O campo Descrição deve ser preenchido!',
      'AVISO', MB_OK + MB_IconInformation);
    EDesc.SetFocus;
    Exit;
  end;
  if EPreco.Text = '' then
  begin
    Application.MessageBox('O campo Preço deve ser preenchido!',
      'AVISO', MB_OK + MB_IconInformation);
    EPreco.SetFocus;
    Exit;
  end;
  if EDureza.Text = '' then
  begin
    Application.MessageBox('O campo Dureza deve ser preenchido!',
      'AVISO', MB_OK + MB_IconInformation);
    EDureza.SetFocus;
    Exit;
  end;

  if Application.MessageBox(
       pchar('Deseja realmente ' + FTipo + ' esse cadastro?'),
       pchar('Confirmação para ' + FTipo),
       MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) <> IDYes then
  begin
    EDesc.SetFocus;
    Exit;
  end;

  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  // Tratamento da imagem
  fileName := '';
  if EFigura.Text <> '' then
  begin
    // Buscar caminho de armazenamento de imagens da configuração (COD_CONFIG=25)
    Q := TZQuery.Create(nil);
    try
      Q.Connection := Modulo.ZConexao;
      Q.SQL.Text := 'SELECT VLR_CONFIG FROM tb_config WHERE COD_CONFIG = 25';
      try
        Q.Open;
        if not Q.IsEmpty then configPath := Q.Fields[0].AsString;
      except end;
    finally
      Q.Free;
    end;

    if configPath <> '' then
    begin
      fileName := configPath + '\' + Modulo.RetZero(ECliente.Text, 4) + '_' +
                  ECodigo.Text + ExtractFileExt(EFigura.Text);
      img := TJPegImage.Create;
      try
        img.LoadFromFile(EFigura.Text);
        img.CompressionQuality := 99;
        try img.SaveToFile(fileName); except fileName := ''; end;
      finally
        img.Free;
      end;
    end;
  end;

  // INSERT ou UPDATE em tb_pecas
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;

    // Sempre UPDATE: no caminho 'gravar' o registro já existe, reservado pelo
    // BTOK (ReservarCodigo). Espelha o BDE, onde o Post do Append acontecia no
    // OK e o Gravar apenas preenchia os campos do registro já criado.
    Q.SQL.Text :=
      'UPDATE tb_pecas SET ' +
      'COD_PROC=:pCodProc, DESCRICAO=:pDesc, MATERIAL=:pMat, PRECO=:pPreco, ' +
      'DUREZA=:pDureza, OBS=:pObs, COD_PECA_CLI=:pCodPecaCli, FIGURA=:pFigura, ' +
      'ITEM_SEG=:pItemSeg, REVISAO=:pRevisao, DATA_REVISAO=:pDataRev, ' +
      'ANALISE_DET=:pAnaliseDet, MARCHA=:pMarcha ' +
      'WHERE COD_CLI=:pCli AND CODIGO=:pCodigo';

    Q.ParamByName('pCli').AsString      := Modulo.RetZero(ECliente.Text, 4);
    Q.ParamByName('pCodigo').AsString   := ECodigo.Text;
    Q.ParamByName('pCodProc').AsString  := ECod_proc.Text;
    Q.ParamByName('pDesc').AsString     := EDesc.Text;
    Q.ParamByName('pMat').AsString      := EMat.Text;
    Q.ParamByName('pPreco').AsFloat     := EPreco.Value;
    Q.ParamByName('pDureza').AsString   := EDureza.Text;
    Q.ParamByName('pObs').AsString      := EObs.Text;
    Q.ParamByName('pCodPecaCli').AsString := ECodPecaCliente.Text;
    Q.ParamByName('pFigura').AsString   := fileName;
    Q.ParamByName('pRevisao').AsString  := ERevisao.Text;
    Q.ParamByName('pMarcha').AsString   := EMarcha.Text;
    if OpItemSeg.Checked then Q.ParamByName('pItemSeg').AsInteger := 1
    else Q.ParamByName('pItemSeg').AsInteger := 0;
    if OpAnaliseDet.Checked then Q.ParamByName('pAnaliseDet').AsInteger := 1
    else Q.ParamByName('pAnaliseDet').AsInteger := 0;
    try
      Q.ParamByName('pDataRev').AsDate := EDataRevisao.Date;
    except
      Q.ParamByName('pDataRev').Clear;
    end;

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
            Application.MessageBox(pchar('Erro ao salvar peça: ' + E2.Message),
              pchar('ERRO'), MB_OK + MB_IconError);
            Exit;
          end;
        end;
      end;
    end;
  finally
    Q.Free;
  end;

  // Gerenciar equipamentos: apagar os antigos e re-inserir da grid
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text :=
      'DELETE FROM tb_equipamentos_peca WHERE CODIGO_CLI = :pCli AND CODIGO_PECA = :pCodigo';
    Q.ParamByName('pCli').AsString    := Modulo.RetZero(ECliente.Text, 4);
    Q.ParamByName('pCodigo').AsString := ECodigo.Text;
    try Q.ExecSQL; except end;

    for idx := 1 to GridEquip.RowCount - 1 do
    begin
      Q.SQL.Text :=
        'INSERT INTO tb_equipamentos_peca (CODIGO_PECA, CODIGO_CLI, CODIGO_EQUIP, VL_PRODUTIVIDADE) ' +
        'VALUES (:pCodigo, :pCli, :pEquip, :pProd)';
      Q.ParamByName('pCodigo').AsString := ECodigo.Text;
      Q.ParamByName('pCli').AsString    := Modulo.RetZero(ECliente.Text, 4);
      Q.ParamByName('pEquip').AsString  := GridEquip.Cells[0, idx];
      try
        Q.ParamByName('pProd').AsFloat := StrToFloat(GridEquip.Cells[2, idx]);
      except
        Q.ParamByName('pProd').AsFloat := 0;
      end;
      try Q.ExecSQL; except end;
    end;
  finally
    Q.Free;
  end;

  Limpar;
  EFantasia.SetFocus;
  ECliente.Text  := '';
  EFantasia.Text := '';
  ECodigo.Text   := '';
  Desabilitar;
  FEmEdicao := False;
end;

{ ---------------------------------------------------------------------------
  Deletar
  --------------------------------------------------------------------------- }

procedure TFPecas.BTDeletarClick(Sender: TObject);
var Q: TZQuery;
begin
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  if Application.MessageBox('Deseja realmente deletar esse cadastro?',
     'Confirmação de Exclusão',
     MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) <> IDYes then
  begin
    EDesc.SetFocus;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;

    // Apagar equipamentos vinculados
    Q.SQL.Text :=
      'DELETE FROM tb_equipamentos_peca WHERE CODIGO_CLI = :pCli AND CODIGO_PECA = :pCodigo';
    Q.ParamByName('pCli').AsString    := Modulo.RetZero(ECliente.Text, 4);
    Q.ParamByName('pCodigo').AsString := ECodigo.Text;
    try Q.ExecSQL; except end;

    // Apagar a peça
    Q.SQL.Text :=
      'DELETE FROM tb_pecas WHERE COD_CLI = :pCli AND CODIGO = :pCodigo';
    Q.ParamByName('pCli').AsString    := Modulo.RetZero(ECliente.Text, 4);
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
  EFantasia.SetFocus;
  ECliente.Text  := '';
  EFantasia.Text := '';
  ECodigo.Text   := '';
  Desabilitar;
  FEmEdicao := False;
end;

procedure TFPecas.BTCancelarClick(Sender: TObject);
// BTCancelar não tem botão no DFM (handler mantido por compatibilidade).
begin
  if Application.MessageBox('Deseja realmente cancelar esse cadastro?',
     'Confirmação de Cancelamento',
     MB_YESNO + MB_IconQuestion) <> IDYes then
  begin
    EDesc.SetFocus;
    Exit;
  end;
  Limpar;
  ECliente.Text  := '';
  EFantasia.Text := '';
  ECodigo.Text   := '';
  EFantasia.SetFocus;
  Desabilitar;
  FEmEdicao := False;
end;

procedure TFPecas.BTLimparClick(Sender: TObject);
begin
  Limpar;
end;

procedure TFPecas.BTLocalizarClick(Sender: TObject);
begin
  FLocalizar.GridPeca.Visible := True;
  FLocalizar.GridProc.Visible := False;
  FLocalizar.GridCli.Visible  := False;
  FLocalizar.ShowModal;
end;

procedure TFPecas.BTSairClick(Sender: TObject);
begin
  Close;
end;

{ ---------------------------------------------------------------------------
  Grid de equipamentos — BTMais e BTMenos
  --------------------------------------------------------------------------- }

procedure TFPecas.BTMaisClick(Sender: TObject);
var indice: Integer;
begin
  if ECodEquip.Text = '' then
  begin
    Application.MessageBox(
      'Um equipamento deve ser escolhido antes de ser inserido!',
      'AVISO', MB_OK + MB_IconInformation);
    EProdTeorica.SetFocus;
    Exit;
  end;

  indice := GridEquip.RowCount;
  GridEquip.AddRow;
  GridEquip.Cells[0, indice] := ECodEquip.Text;
  GridEquip.Cells[1, indice] := Eequip.Text;
  GridEquip.Cells[2, indice] := EProdTeorica.Text;
  Eequip.Text      := '';
  ECodEquip.Clear;
  EProdTeorica.Clear;
  Eequip.SetFocus;

  // Atualizar combo excluindo o equipamento recém adicionado
  RefreshEquipCombo;
end;

procedure TFPecas.BTMenosClick(Sender: TObject);
begin
  if GridEquip.RowCount > 1 then
    GridEquip.RemoveRows(GridEquip.Row, 1);
  RefreshEquipCombo;
end;

{ ---------------------------------------------------------------------------
  Figura (imagem da peça)
  --------------------------------------------------------------------------- }

procedure TFPecas.EFiguraAfterDialog(Sender: TObject; var Name: String;
  var Action: Boolean);
begin
  EPicture.Picture.LoadFromFile(Name);
end;

{ ---------------------------------------------------------------------------
  Eventos visuais — cores de foco
  --------------------------------------------------------------------------- }

procedure TFPecas.EClienteEnter(Sender: TObject);
begin
  ECliente.Color      := $00E2F5FE;
  ECliente.Font.Color := clNavy;
  ECliente.Font.Style := [fsBold];
end;

procedure TFPecas.EClienteExit(Sender: TObject);
begin
  ECliente.Color      := clWhite;
  ECliente.Font.Color := clBlack;
  ECliente.Font.Style := [];
  if ECliente.Text <> '' then
    ECliente.Text := Modulo.RetZero(ECliente.Text, 4);
end;

procedure TFPecas.EClienteKeyPress(Sender: TObject; var Key: Char);
begin
  Key := Modulo.Number(Key);
end;

procedure TFPecas.EFantasiaEnter(Sender: TObject);
begin
  EFantasia.Color      := $00E2F5FE;
  EFantasia.Font.Color := clNavy;
  EFantasia.Font.Style := [fsBold];
end;

procedure TFPecas.EFantasiaExit(Sender: TObject);
begin
  EFantasia.Color      := clWhite;
  EFantasia.Font.Color := clBlack;
  EFantasia.Font.Style := [];
end;

procedure TFPecas.ECodigoEnter(Sender: TObject);
begin
  ECodigo.Color      := $00E2F5FE;
  ECodigo.Font.Color := clNavy;
  ECodigo.Font.Style := [fsBold];
end;

procedure TFPecas.ECodigoExit(Sender: TObject);
begin
  ECodigo.Color      := clWhite;
  ECodigo.Font.Color := clBlack;
  ECodigo.Font.Style := [];
  if ECodigo.Text <> '' then
    ECodigo.Text := Modulo.RetZero(ECodigo.Text, 3);
end;

procedure TFPecas.ECodigoKeyPress(Sender: TObject; var Key: Char);
begin
  Key := Modulo.Number(Key);
end;

procedure TFPecas.EDescEnter(Sender: TObject);
begin
  EDesc.Color      := $00E2F5FE;
  EDesc.Font.Color := clNavy;
  EDesc.Font.Style := [fsBold];
end;

procedure TFPecas.EDescExit(Sender: TObject);
begin
  EDesc.Color      := clWhite;
  EDesc.Font.Color := clBlack;
  EDesc.Font.Style := [];
end;

procedure TFPecas.EMatEnter(Sender: TObject);
begin
  EMat.Color      := $00E2F5FE;
  EMat.Font.Color := clNavy;
  EMat.Font.Style := [fsBold];
end;

procedure TFPecas.EMatExit(Sender: TObject);
begin
  EMat.Color      := clWhite;
  EMat.Font.Color := clBlack;
  EMat.Font.Style := [];
end;

procedure TFPecas.EFiguraEnter(Sender: TObject);
begin
  EFigura.Color      := $00E2F5FE;
  EFigura.Font.Color := clNavy;
  EFigura.Font.Style := [fsBold];
end;

procedure TFPecas.EFiguraExit(Sender: TObject);
begin
  EFigura.Color      := clWhite;
  EFigura.Font.Color := clBlack;
  EFigura.Font.Style := [];
end;

procedure TFPecas.EPrecoEnter(Sender: TObject);
begin
  EPreco.Color      := $00E2F5FE;
  EPreco.Font.Color := clNavy;
  EPreco.Font.Style := [fsBold];
end;

procedure TFPecas.EPrecoExit(Sender: TObject);
begin
  EPreco.Color      := clWhite;
  EPreco.Font.Color := clBlack;
  EPreco.Font.Style := [];
end;

procedure TFPecas.ECod_procEnter(Sender: TObject);
begin
  ECod_proc.Color      := $00E2F5FE;
  ECod_proc.Font.Color := clNavy;
  ECod_proc.Font.Style := [fsBold];
end;

procedure TFPecas.ECod_procExit(Sender: TObject);
begin
  ECod_proc.Color      := clWhite;
  ECod_proc.Font.Color := clBlack;
  ECod_proc.Font.Style := [];
  if ECod_proc.Text <> '' then
    ECod_proc.Text := Modulo.RetZero(ECod_proc.Text, 3);
end;

procedure TFPecas.ECod_procKeyPress(Sender: TObject; var Key: Char);
begin
  Key := Modulo.Number(Key);
end;

procedure TFPecas.EProcessoEnter(Sender: TObject);
begin
  EProcesso.Color      := $00E2F5FE;
  EProcesso.Font.Color := clNavy;
  EProcesso.Font.Style := [fsBold];
end;

procedure TFPecas.EProcessoExit(Sender: TObject);
begin
  EProcesso.Color      := clWhite;
  EProcesso.Font.Color := clBlack;
  EProcesso.Font.Style := [];
end;

procedure TFPecas.EDurezaEnter(Sender: TObject);
begin
  EDureza.Color      := $00E2F5FE;
  EDureza.Font.Color := clNavy;
  EDureza.Font.Style := [fsBold];
end;

procedure TFPecas.EDurezaExit(Sender: TObject);
begin
  EDureza.Color      := clWhite;
  EDureza.Font.Color := clBlack;
  EDureza.Font.Style := [];
end;

procedure TFPecas.EObsEnter(Sender: TObject);
begin
  EObs.Color      := $00E2F5FE;
  EObs.Font.Color := clNavy;
  EObs.Font.Style := [fsBold];
end;

procedure TFPecas.EObsExit(Sender: TObject);
begin
  EObs.Color      := clWhite;
  EObs.Font.Color := clBlack;
  EObs.Font.Style := [];
end;

procedure TFPecas.EMarchaEnter(Sender: TObject);
begin
  EMarcha.Color      := $00E2F5FE;
  EMarcha.Font.Color := clNavy;
  EMarcha.Font.Style := [fsBold];
end;

procedure TFPecas.EMarchaExit(Sender: TObject);
begin
  EMarcha.Color      := clWhite;
  EMarcha.Font.Color := clBlack;
  EMarcha.Font.Style := [];
end;

{ ---------------------------------------------------------------------------
  Eventos visuais dos botões
  --------------------------------------------------------------------------- }

procedure TFPecas.BTGravarEnter(Sender: TObject);
begin
  BTGravar.ButtonColor  := $00E2F5FE;
  BTGravar.ButtonColor1 := clGray;
end;

procedure TFPecas.BTGravarExit(Sender: TObject);
begin
  BTGravar.ButtonColor  := $00CACACA;
  BTGravar.ButtonColor1 := $00CACACA;
end;

procedure TFPecas.BTDeletarEnter(Sender: TObject);
begin
  BTDeletar.ButtonColor  := $00E2F5FE;
  BTDeletar.ButtonColor1 := clGray;
end;

procedure TFPecas.BTDeletarExit(Sender: TObject);
begin
  BTDeletar.ButtonColor  := $00CACACA;
  BTDeletar.ButtonColor1 := $00CACACA;
end;

procedure TFPecas.BTLimparEnter(Sender: TObject);
begin
  BTLimpar.ButtonColor  := $00E2F5FE;
  BTLimpar.ButtonColor1 := clGray;
end;

procedure TFPecas.BTLimparExit(Sender: TObject);
begin
  BTLimpar.ButtonColor  := $00CACACA;
  BTLimpar.ButtonColor1 := $00CACACA;
end;

procedure TFPecas.BTLocalizarEnter(Sender: TObject);
begin
  BTLocalizar.ButtonColor  := $00E2F5FE;
  BTLocalizar.ButtonColor1 := clGray;
end;

procedure TFPecas.BTLocalizarExit(Sender: TObject);
begin
  BTLocalizar.ButtonColor  := $00CACACA;
  BTLocalizar.ButtonColor1 := $00CACACA;
end;

procedure TFPecas.BTSairEnter(Sender: TObject);
begin
  BTSair.ButtonColor  := $00E2F5FE;
  BTSair.ButtonColor1 := clGray;
end;

procedure TFPecas.BTSairExit(Sender: TObject);
begin
  BTSair.ButtonColor  := $00CACACA;
  BTSair.ButtonColor1 := $00CACACA;
end;

end.
