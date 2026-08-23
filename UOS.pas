unit UOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, IAeverButton, Mask,
  VrControls, VrBorder, DB, XBaloon,
  mdTabEnter, Grids, rxCurrEdit, rxToolEdit, AdvPicture, DateUtils,
  ComCtrls, AdvDateTimePicker, ZDataset;

type
  TFOs = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    BTOK: TIAeverButton;
    Label8: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label23: TLabel;
    GroupBox2: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    BTSair: TIAeverButton;
    BTLimpar: TIAeverButton;
    BTFinalizar: TIAeverButton;
    BTGravar: TIAeverButton;
    QProc: TZQuery;
    DataSource1: TDataSource;
    TabEnter1: TTabEnter;
    QPecas: TZQuery;
    DataSource2: TDataSource;
    QDesfinalizar: TZQuery;
    { Datasets dedicados ao FRelatOS — substituem Modulo.DSOs/DSClientes/DSFornec,
      que continuam BDE para os forms ainda não migrados. }
    QOsRel: TZQuery;
    DSOsRel: TDataSource;
    QCliRel: TZQuery;
    DSCliRel: TDataSource;
    QFornRel: TZQuery;
    DSFornRel: TDataSource;
    PFinalizar: TPanel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Lvalor: TLabel;
    LPeso: TLabel;
    Label27: TLabel;
    BTFechar: TIAeverButton;
    EValor: TCurrencyEdit;
    BTDeletar: TIAeverButton;
    BTpecas: TIAeverButton;
    BTCancelar: TIAeverButton;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    EProcesso: TEdit;
    Label5: TLabel;
    Elinha1: TEdit;
    Elinha2: TEdit;
    Elinha3: TEdit;
    Elinha4: TEdit;
    Elinha5: TEdit;
    Elinha6: TEdit;
    Label13: TLabel;
    Image1: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    OpRet: TCheckBox;
    OpDev: TCheckBox;
    EObs2: TMemo;
    Label12: TLabel;
    LLoteMinimo: TLabel;
    Label15: TLabel;
    BTRetrabalho: TIAeverButton;
    BTDevolucao: TIAeverButton;
    Label14: TLabel;
    EFantasia: TComboBox;
    ECliente: TEdit;
    ECodigo: TMaskEdit;
    EData: TDateEdit;
    ENota: TEdit;
    ECodPeca: TEdit;
    EMaterial: TEdit;
    EObsPeca: TEdit;
    Eqtd: TEdit;
    EEmb: TEdit;
    EPEso: TCurrencyEdit;
    ELote: TEdit;
    EObs: TEdit;
    EDureza: TEdit;
    BTDesfinalizar: TIAeverButton;
    PTerceirizar: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    Label31: TLabel;
    BTAtualizar: TIAeverButton;
    BTCancelar2: TIAeverButton;
    BTImprimir: TIAeverButton;
    EObsF: TMemo;
    EFornecedor: TEdit;
    EFantasiaF: TComboBox;
    Label19: TLabel;
    EValorF: TCurrencyEdit;
    EdataEnvio: TDateEdit;
    ECod_proc: TEdit;
    EProcF: TComboBox;
    BTTerceirizar: TIAeverButton;
    EPicture: TAdvPicture;
    Label20: TLabel;
    Label22: TLabel;
    EDataRetorno: TDateEdit;
    OptRetorno: TCheckBox;
    OPUrgente: TCheckBox;
    EPeca: TComboBox;
    PApontamento: TPanel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    BTGravarAp: TIAeverButton;
    BTCancelar3: TIAeverButton;
    Edit1: TEdit;
    RxLookupEdit1: TComboBox;
    Edit2: TEdit;
    RxLookupEdit2: TComboBox;
    RxLookupEdit3: TComboBox;
    Edit3: TEdit;
    Label37: TLabel;
    AdvDateTimePicker1: TAdvDateTimePicker;
    AdvDateTimePicker2: TAdvDateTimePicker;
    procedure BTSairClick(Sender: TObject);
    procedure ECodigoEnter(Sender: TObject);
    procedure EClienteEnter(Sender: TObject);
    procedure EFantasiaEnter(Sender: TObject);
    procedure ENotaEnter(Sender: TObject);
    procedure EPecaEnter(Sender: TObject);
    procedure EqtdEnter(Sender: TObject);
    procedure EEmbEnter(Sender: TObject);
    procedure EPesoEnter(Sender: TObject);
    procedure EObsEnter(Sender: TObject);
    procedure ECodigoExit(Sender: TObject);
    procedure EClienteExit(Sender: TObject);
    procedure EFantasiaExit(Sender: TObject);
    procedure EPecaExit(Sender: TObject);
    procedure EqtdExit(Sender: TObject);
    procedure EEmbExit(Sender: TObject);
    procedure EPesoExit(Sender: TObject);
    procedure EObsExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BTOKClick(Sender: TObject);
    procedure ECodPecaEnter(Sender: TObject);
    procedure ECodPecaExit(Sender: TObject);
    procedure EClienteChange(Sender: TObject);
    procedure ECodPecaChange(Sender: TObject);
    procedure BTGravarClick(Sender: TObject);
    procedure BTLimparClick(Sender: TObject);
    procedure BTDeletarClick(Sender: TObject);
    procedure BTFinalizarClick(Sender: TObject);
    procedure ENotaExit(Sender: TObject);
    procedure EValorExit(Sender: TObject);
    procedure EValorEnter(Sender: TObject);
    procedure BTFecharClick(Sender: TObject);
    procedure BTGravarEnter(Sender: TObject);
    procedure BTGravarExit(Sender: TObject);
    procedure BTFinalizarEnter(Sender: TObject);
    procedure BTFinalizarExit(Sender: TObject);
    procedure BTLimparEnter(Sender: TObject);
    procedure BTLimparExit(Sender: TObject);
    procedure BTSairEnter(Sender: TObject);
    procedure BTSairExit(Sender: TObject);
    procedure BTFecharExit(Sender: TObject);
    procedure BTFecharEnter(Sender: TObject);
    procedure BTDeletarEnter(Sender: TObject);
    procedure BTDeletarExit(Sender: TObject);
    procedure BTpecasClick(Sender: TObject);
    procedure BTCancelarEnter(Sender: TObject);
    procedure BTCancelarExit(Sender: TObject);
    procedure BTCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OpRetClick(Sender: TObject);
    procedure OpDevClick(Sender: TObject);
    procedure FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure FormDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure EObsPecaEnter(Sender: TObject);
    procedure EObsPecaExit(Sender: TObject);
    procedure BTRetrabalhoEnter(Sender: TObject);
    procedure BTRetrabalhoExit(Sender: TObject);
    procedure BTRetrabalhoClick(Sender: TObject);
    procedure BTDevolucaoClick(Sender: TObject);
    procedure BTDevolucaoEnter(Sender: TObject);
    procedure BTDevolucaoExit(Sender: TObject);
    procedure ELoteEnter(Sender: TObject);
    procedure ELoteExit(Sender: TObject);
    procedure EFantasiaChange(Sender: TObject);
    procedure EFantasiaFChange(Sender: TObject);
    procedure EProcFChange(Sender: TObject);
    procedure EPecaChange(Sender: TObject);
    procedure BTDesfinalizarEnter(Sender: TObject);
    procedure BTDesfinalizarExit(Sender: TObject);
    procedure BTDesfinalizarClick(Sender: TObject);
    procedure BTTerceirizarEnter(Sender: TObject);
    procedure BTTerceirizarExit(Sender: TObject);
    procedure EFornecedorChange(Sender: TObject);
    procedure EFornecedorEnter(Sender: TObject);
    procedure EFornecedorExit(Sender: TObject);
    procedure BTTerceirizarClick(Sender: TObject);
    procedure BTCancelar2Click(Sender: TObject);
    procedure BTCancelar2Enter(Sender: TObject);
    procedure BTCancelar2Exit(Sender: TObject);
    procedure EFantasiaFEnter(Sender: TObject);
    procedure EFantasiaFExit(Sender: TObject);
    procedure EDataEnter(Sender: TObject);
    procedure EDataExit(Sender: TObject);
    procedure ECod_procEnter(Sender: TObject);
    procedure ECod_procExit(Sender: TObject);
    procedure EdataEnvioExit(Sender: TObject);
    procedure EDataRetornoExit(Sender: TObject);
    procedure EValorFEnter(Sender: TObject);
    procedure EValorFExit(Sender: TObject);
    procedure EObsFEnter(Sender: TObject);
    procedure EObsFExit(Sender: TObject);
    procedure BTAtualizarEnter(Sender: TObject);
    procedure BTImprimirEnter(Sender: TObject);
    procedure BTImprimirExit(Sender: TObject);
    procedure EProcFEnter(Sender: TObject);
    procedure EProcFExit(Sender: TObject);
    procedure EdataEnvioEnter(Sender: TObject);
    procedure EDataRetornoEnter(Sender: TObject);
    procedure ECod_procChange(Sender: TObject);
    procedure BTAtualizarClick(Sender: TObject);
    procedure BTImprimirClick(Sender: TObject);
  private
    { Private declarations }
    { --- infraestrutura MySQL ---
      Campos vem ANTES dos metodos: em Delphi, declarar campo depois de
      procedure/property na mesma secao da E2169. }
    FEmEdicao:      Boolean;
    FClientesCod:   TStringList;  // ItemIndex -> CODIGO (EFantasia, EFantasiaF, RxLookupEdit1)
    FProcCod:       TStringList;  // ItemIndex -> CODIGO (EProcF, RxLookupEdit2/3)
    FPecasCod:      TStringList;  // ItemIndex -> CODIGO da peca (EPeca)
    FUpdatingCli:   Boolean;      // guard ECliente  <-> EFantasia
    FUpdatingProc:  Boolean;      // guard ECod_proc <-> EProcF
    FUpdatingPeca:  Boolean;      // guard ECodPeca  <-> EPeca
    FUpdatingForn:  Boolean;      // guard EFornecedor <-> EFantasiaF
    procedure Desabilitar;
    procedure Limpar;
    procedure Habilitar;
    function RetAno(dData : TDateTime): string;
    function RetZero(ZEROS:string;QUANT:integer):String;
    function  GarantirConexao: Boolean;
    function  ObterProximoCodigo: string;
    function  ReservarCodigo: Boolean;
    procedure LiberarCodigoReservado;
    procedure PosicionarNovaOS;
    procedure PopularCombos;
    procedure CarregarListaPecas(const codCliente: string);
    procedure SelecionarPeca(const codPeca: string);
    procedure PrepararDatasetsRelatorio;
    function  ClienteInativo(const codCliente: string): Boolean;
    function  LoteMinimoCliente(const codCliente: string): Double;

  public
    varNF:boolean;
    { Public declarations }
  end;

var
  FOs: TFOs;
  tipo : string;
  cliente:string;


implementation
uses UNF, URelatOS, UPecas, URelatCQ,  principal, UModulo;
{$R *.dfm}

function TFOs.RetAno(dData : TDateTime): string;
var Dia, Mes, Ano: word;
begin
DecodeDate(dData, Ano, Mes, Dia);
RetAno := copy(inttostr(Ano),3,2);
end;

{ ---------------------------------------------------------------------------
  Infraestrutura MySQL

  Os TZQuery vivem no DFM, mas Modulo.ZConexao e criado em RUNTIME
  (DataModuleCreate) e portanto nao existe em design time - nao ha como
  atribuir Connection pelo Object Inspector. A ligacao e feita aqui.
  --------------------------------------------------------------------------- }

function TFOs.GarantirConexao: Boolean;
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

  QProc.Connection         := Modulo.ZConexao;
  QPecas.Connection        := Modulo.ZConexao;
  QDesfinalizar.Connection := Modulo.ZConexao;
  QOsRel.Connection        := Modulo.ZConexao;
  QCliRel.Connection       := Modulo.ZConexao;
  QFornRel.Connection      := Modulo.ZConexao;
  Result := True;
end;

function TFOs.ObterProximoCodigo: string;
// O CODIGO da OS e varchar(9) no formato NNNNNN/AA (sequencial + ano).
// Nao serve MAX(CAST(CODIGO AS UNSIGNED)): o CAST para no '/' e misturaria
// exercicios de anos diferentes. Filtra pelo ano corrente.
var
  Q:    TZQuery;
  ano:  string;
  prox: Integer;
begin
  ano    := RetAno(now);
  Result := Modulo.RetZero('1', 6) + '/' + ano;
  if not GarantirConexao then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text :=
      'SELECT MAX(CAST(SUBSTRING(CODIGO,1,6) AS UNSIGNED)) FROM tb_os ' +
      'WHERE SUBSTRING(CODIGO,8,2) = :pAno';
    Q.ParamByName('pAno').AsString := ano;
    try
      Q.Open;
      if Q.Fields[0].IsNull then prox := 1 else prox := Q.Fields[0].AsInteger + 1;
      Result := Modulo.RetZero(IntToStr(prox), 6) + '/' + ano;
    except
      // mantem o default
    end;
  finally
    Q.Free;
  end;
end;

function TFOs.ReservarCodigo: Boolean;
// Grava um registro-stub so com a chave, RESERVANDO o numero da OS no instante
// do clique em OK. Reproduz o Append/Post do BDE, cuja funcao era justamente
// impedir que dois operadores emitissem OS com o mesmo codigo.
//
// Se outro usuario reservou o mesmo numero no meio do caminho, o MySQL recusa
// com erro 1062 (Duplicate entry). Nesse caso pegamos o proximo numero livre e
// tentamos de novo - avisando o operador, que pode ja ter anotado o anterior.
var
  Q:   TZQuery;
  i:   Integer;
  ini: string;
begin
  Result := False;
  if not GarantirConexao then Exit;

  ini := ECodigo.Text;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'INSERT INTO tb_os (CODIGO, FINALIZADA) VALUES (:pCodigo, 0)';
    for i := 1 to 10 do
    begin
      Q.ParamByName('pCodigo').AsString := ECodigo.Text;
      try
        Q.ExecSQL;
        Result := True;
        if ECodigo.Text <> ini then
          Application.MessageBox(
            pchar('O numero ' + ini + ' acabou de ser usado por outro usuario.' + #13#10 +
                  'Esta OS recebeu o numero ' + ECodigo.Text + '.'),
            pchar('Numero de OS alterado'), MB_OK + MB_IconInformation);
        Exit;
      except
        on E: Exception do
        begin
          // 1062 = Duplicate entry -> colisao; qualquer outro erro e real
          if (Pos('duplicate', LowerCase(E.Message)) = 0) and
             (Pos('1062', E.Message) = 0) then
          begin
            Application.MessageBox(pchar('Erro ao reservar o numero da OS: ' + E.Message),
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

  Application.MessageBox(
    pchar('Nao foi possivel reservar um numero de OS. Tente novamente.'),
    pchar('AVISO'), MB_OK + MB_IconInformation);
end;

procedure TFOs.PosicionarNovaOS;
// Devolve o form ao estado inicial, pronto para emitir a proxima OS.
//
// No BDE isso acontecia por EFEITO COLATERAL: ao fechar a janela de Preview do
// relatorio, o form voltava a ganhar foco, o OnActivate disparava e
// reinicializava tudo. Com a inicializacao agora no OnShow (para o form nao se
// limpar ao voltar do FPecas), esse reset tem de ser explicito.
begin
  Limpar;
  FEmEdicao := False;
  tipo := '';
  ECodigo.Text := ObterProximoCodigo;
  ECodigo.SetFocus;
  Desabilitar;
  PFinalizar.Visible   := False;
  PTerceirizar.Visible := False;
  PApontamento.Visible := False;
end;

procedure TFOs.LiberarCodigoReservado;
// Remove o registro-stub reservado no OK que nunca chegou a ser gravado.
// Equivale ao TBOs.Delete que o BDE fazia no FormClose.
var Q: TZQuery;
begin
  if not GarantirConexao then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    // So apaga se continuar sendo um stub: sem cliente e sem peca. Assim uma OS
    // que chegou a ser gravada nunca e removida por engano.
    Q.SQL.Text :=
      'DELETE FROM tb_os WHERE CODIGO = :pCodigo ' +
      'AND FINALIZADA = 0 AND CLIENTE IS NULL AND PECA IS NULL';
    Q.ParamByName('pCodigo').AsString := ECodigo.Text;
    try Q.ExecSQL; except end;
  finally
    Q.Free;
  end;
end;

procedure TFOs.PopularCombos;
// Clientes alimentam EFantasia, EFantasiaF e RxLookupEdit1 (no Paradox o
// fornecedor tambem e um cliente); processos alimentam EProcF, RxLookupEdit2
// e RxLookupEdit3.
// UMA lista por FONTE de dados - nao uma por controle - para preservar o
// acoplamento que existia via Modulo.DSClientes / Modulo.DSProc compartilhados.
var Q: TZQuery;
begin
  if not GarantirConexao then Exit;

  if FClientesCod = nil then FClientesCod := TStringList.Create;
  if FProcCod     = nil then FProcCod     := TStringList.Create;
  if FPecasCod    = nil then FPecasCod    := TStringList.Create;

  if FClientesCod.Count = 0 then
  begin
    Q := TZQuery.Create(nil);
    try
      Q.Connection := Modulo.ZConexao;
      Q.SQL.Text := 'SELECT CODIGO, FANTASIA FROM tb_clientes ORDER BY FANTASIA';
      try
        Q.Open;
        EFantasia.Items.BeginUpdate;
        EFantasiaF.Items.BeginUpdate;
        RxLookupEdit1.Items.BeginUpdate;
        try
          EFantasia.Items.Clear;
          EFantasiaF.Items.Clear;
          RxLookupEdit1.Items.Clear;
          while not Q.Eof do
          begin
            EFantasia.Items.Add(Q.FieldByName('FANTASIA').AsString);
            EFantasiaF.Items.Add(Q.FieldByName('FANTASIA').AsString);
            RxLookupEdit1.Items.Add(Q.FieldByName('FANTASIA').AsString);
            FClientesCod.Add(Q.FieldByName('CODIGO').AsString);
            Q.Next;
          end;
        finally
          EFantasia.Items.EndUpdate;
          EFantasiaF.Items.EndUpdate;
          RxLookupEdit1.Items.EndUpdate;
        end;
      except end;
    finally
      Q.Free;
    end;
  end;

  if FProcCod.Count = 0 then
  begin
    Q := TZQuery.Create(nil);
    try
      Q.Connection := Modulo.ZConexao;
      Q.SQL.Text := 'SELECT CODIGO, PROCESSO FROM tb_proc ORDER BY PROCESSO';
      try
        Q.Open;
        EProcF.Items.Clear;
        RxLookupEdit2.Items.Clear;
        RxLookupEdit3.Items.Clear;
        while not Q.Eof do
        begin
          EProcF.Items.Add(Q.FieldByName('PROCESSO').AsString);
          RxLookupEdit2.Items.Add(Q.FieldByName('PROCESSO').AsString);
          RxLookupEdit3.Items.Add(Q.FieldByName('PROCESSO').AsString);
          FProcCod.Add(Q.FieldByName('CODIGO').AsString);
          Q.Next;
        end;
      except end;
    finally
      Q.Free;
    end;
  end;
end;

procedure TFOs.CarregarListaPecas(const codCliente: string);
// Lista de pecas do cliente para o combo EPeca. Antes isso vinha do proprio
// QPecas, que era ao mesmo tempo a lista do lookup E o registro lido pelo
// relatorio; agora a lista fica no combo e o QPecas guarda so a peca escolhida.
var Q: TZQuery;
begin
  if FPecasCod = nil then FPecasCod := TStringList.Create;
  FPecasCod.Clear;
  EPeca.Items.Clear;
  if (codCliente = '') or not GarantirConexao then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text :=
      'SELECT CODIGO, DESCRICAO FROM tb_pecas ' +
      'WHERE COD_CLI = :pCli AND DESCRICAO IS NOT NULL AND DESCRICAO <> ' + QuotedStr('') + ' ' +
      'ORDER BY DESCRICAO';
    Q.ParamByName('pCli').AsString := Modulo.RetZero(codCliente, 4);
    try
      Q.Open;
      EPeca.Items.BeginUpdate;
      try
        while not Q.Eof do
        begin
          EPeca.Items.Add(Q.FieldByName('DESCRICAO').AsString);
          FPecasCod.Add(Q.FieldByName('CODIGO').AsString);
          Q.Next;
        end;
      finally
        EPeca.Items.EndUpdate;
      end;
    except end;
  finally
    Q.Free;
  end;
end;

procedure TFOs.SelecionarPeca(const codPeca: string);
// Posiciona QPecas na peca (1 registro) e QProc no processo dela.
// No BDE era Locate + SQL dinamico; aqui o WHERE devolve o registro unico, o
// que dispensa posicionamento e alimenta o FRelatOS via DataSource1/DataSource2.
begin
  if not GarantirConexao then Exit;

  QPecas.Close;
  QPecas.SQL.Text :=
    'SELECT COD_CLI, CODIGO, COD_PROC, DESCRICAO, MATERIAL, PRECO, DUREZA, OBS, ' +
    'COD_PECA_CLI, ITEM_SEG, REVISAO, DATA_REVISAO, MARCHA, ANALISE_DET, FIGURA ' +
    'FROM tb_pecas WHERE COD_CLI = :pCli AND CODIGO = :pCodigo';
  QPecas.ParamByName('pCli').AsString    := Modulo.RetZero(ECliente.Text, 4);
  QPecas.ParamByName('pCodigo').AsString := Modulo.RetZero(codPeca, 3);
  try
    QPecas.Open;
  except
    on E: Exception do
    begin
      try
        Modulo.ZConexao.Disconnect;
        Modulo.ZConexao.Connect;
        QPecas.Open;
      except
        Exit;
      end;
    end;
  end;

  if QPecas.IsEmpty then
  begin
    EPeca.Text := '';
    EPicture.Picture := nil;
    Exit;
  end;

  EMaterial.Text := QPecas.FieldByName('MATERIAL').AsString;
  EDureza.Text   := QPecas.FieldByName('DUREZA').AsString;
  if QPecas.FieldByName('FIGURA').AsString <> '' then
  begin
    try
      EPicture.Picture.LoadFromFile(QPecas.FieldByName('FIGURA').AsString);
    except
      EPicture.Picture := nil;
    end;
  end
  else
    EPicture.Picture := nil;

  // Processo da peca -> alimenta DataSource1 (8 bindings do FRelatOS)
  QProc.Close;
  QProc.SQL.Text :=
    'SELECT CODIGO, PROCESSO, LINHA1, LINHA2, LINHA3, LINHA4, LINHA5, LINHA6, ' +
    'LINHA7, OBS FROM tb_proc WHERE CODIGO = :pCodigo';
  QProc.ParamByName('pCodigo').AsString := QPecas.FieldByName('COD_PROC').AsString;
  try
    QProc.Open;
    if not QProc.IsEmpty then
    begin
      EProcesso.Text := QProc.FieldByName('PROCESSO').AsString;
      ELinha1.Text   := QProc.FieldByName('LINHA1').AsString;
      ELinha2.Text   := QProc.FieldByName('LINHA2').AsString;
      ELinha3.Text   := QProc.FieldByName('LINHA3').AsString;
      ELinha4.Text   := QProc.FieldByName('LINHA4').AsString;
      ELinha5.Text   := QProc.FieldByName('LINHA5').AsString;
      ELinha6.Text   := QProc.FieldByName('LINHA6').AsString;
      EObs2.Text     := QProc.FieldByName('OBS').AsString;
    end;
  except end;

  EObsPeca.Text := QPecas.FieldByName('OBS').AsString;
end;

procedure TFOs.PrepararDatasetsRelatorio;
// Abre os tres datasets que o FRelatOS consome no lugar de
// Modulo.DSOs / DSClientes / DSFornec (que seguem BDE para os forms nao migrados).
begin
  if not GarantirConexao then Exit;

  QOsRel.Close;
  QOsRel.ParamByName('pCodigo').AsString := ECodigo.Text;
  try QOsRel.Open; except end;

  QCliRel.Close;
  QCliRel.ParamByName('pCodigo').AsString := Modulo.RetZero(ECliente.Text, 4);
  try QCliRel.Open; except end;

  QFornRel.Close;
  if EFornecedor.Text <> '' then
    QFornRel.ParamByName('pCodigo').AsString := Modulo.RetZero(EFornecedor.Text, 4)
  else
    QFornRel.ParamByName('pCodigo').AsString := '';
  try QFornRel.Open; except end;
end;

function TFOs.ClienteInativo(const codCliente: string): Boolean;
var Q: TZQuery;
begin
  Result := False;
  if not GarantirConexao then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'SELECT INATIVO FROM tb_clientes WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(codCliente, 4);
    try
      Q.Open;
      // INATIVO e tinyint(1): sempre AsInteger, nunca AsBoolean
      if not Q.IsEmpty then Result := Q.FieldByName('INATIVO').AsInteger <> 0;
    except end;
  finally
    Q.Free;
  end;
end;

function TFOs.LoteMinimoCliente(const codCliente: string): Double;
var Q: TZQuery;
begin
  Result := 0;
  if not GarantirConexao then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'SELECT LT_MINIMO FROM tb_clientes WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(codCliente, 4);
    try
      Q.Open;
      if not Q.IsEmpty then Result := Q.FieldByName('LT_MINIMO').AsFloat;
    except end;
  finally
    Q.Free;
  end;
end;

procedure TFOs.Limpar;
var
i : Integer;
begin
for i := 0 to FOs.ComponentCount - 1 do
if (FOs.Components[i] is TCustomEdit) and (FOs.Components[i].Name <> 'ECodigo') then
(FOs.Components[i] as TCustomEdit).Clear;
// TComboBox NAO descende de TCustomEdit, logo fica fora do laco acima.
// Antes eram TRxLookupEdit (que E TCustomEdit) e o laco os alcancava.
EFantasia.Text     := '';
EFantasiaF.Text    := '';
EProcF.Text        := '';
EPeca.Text         := '';
RxLookupEdit1.Text := '';
RxLookupEdit2.Text := '';
RxLookupEdit3.Text := '';
EPicture.Picture := nil;

end;


procedure TFOs.Desabilitar;
var
i : Integer;
begin

for i := 0 to FOs.ComponentCount - 1 do
begin
if (FOs.Components[i] is TCustomEdit) and (FOs.Components[i].Name <> 'ECodigo') and (FOs.Components[i].Name <> 'EValor') and (FOs.Components[i].Name <> 'EForno') then
begin
 (FOs.Components[i] as TCustomEdit).enabled := false;
 (FOs.Components[i] as TCustomEdit).Brush.Color := $00EAEAEA;
end;

if (FOs.Components[i] is TIAeverButton) and (FOs.Components[i].Name <> 'BTOK') and (FOs.Components[i].Name <> 'BTLocalizar') and (FOs.Components[i].Name <> 'BTSair') and (FOs.Components[i].Name <> 'BTFechar') and (FOs.Components[i].Name <> 'BTCancelar') then
 (FOs.Components[i] as TIAeverButton).enabled := false;

// os 7 combos, que o laco de TCustomEdit nao alcanca
if FOs.Components[i] is TComboBox then
begin
 (FOs.Components[i] as TComboBox).Enabled := false;
 (FOs.Components[i] as TComboBox).Color   := $00EAEAEA;
end;
end;
EPicture.Picture := nil;

OPUrgente.Enabled := false;

end;


procedure TFOs.Habilitar;
var
i : Integer;
begin

for i := 0 to FOs.ComponentCount - 1 do
begin
if (FOs.Components[i] is TCustomEdit) and (FOs.Components[i].Name <> 'ECodigo') then
begin
 (FOs.Components[i] as TCustomEdit).enabled := true;
 (FOs.Components[i] as TCustomEdit).Brush.Color := clWhite;
end;

if (FOs.Components[i] is TIAeverButton) and (FOs.Components[i].Name <> 'BTOK') and (FOs.Components[i].Name <> 'BTLocalizar') and (FOs.Components[i].Name <> 'BTSair') then
 (FOs.Components[i] as TIAeverButton).enabled := true;

if FOs.Components[i] is TComboBox then
begin
 (FOs.Components[i] as TComboBox).Enabled := true;
 (FOs.Components[i] as TComboBox).Color   := clWhite;
end;

if tipo = 'gravar' then begin
BTFinalizar.Enabled := false;
BTRetrabalho.Enabled := false;
BTDevolucao.Enabled := false;

OPUrgente.Enabled := true;

end;
end;
end;


procedure TFOs.BTSairClick(Sender: TObject);
begin
close;
end;

procedure TFOs.ECodigoEnter(Sender: TObject);
begin
ECodigo.color := $00E2F5FE;
ECodigo.Font.Color := clNavy;
ECodigo.Font.style := [fsBold];

end;

procedure TFOs.EClienteEnter(Sender: TObject);
begin
ECliente.color := $00E2F5FE;
ECliente.Font.Color := clNavy;
ECliente.Font.style := [fsBold];
end;

procedure TFOs.EFantasiaEnter(Sender: TObject);
begin
EFantasia.color := $00E2F5FE;
EFantasia.Font.Color := clNavy;
EFantasia.Font.style := [fsBold];
end;

procedure TFOs.ENotaEnter(Sender: TObject);
begin
ENota.color := $00E2F5FE;
ENota.Font.Color := clNavy;
ENota.Font.style := [fsBold];
end;

procedure TFOs.EPecaEnter(Sender: TObject);
begin
EPeca.color := $00E2F5FE;
EPeca.Font.Color := clNavy;
EPeca.Font.style := [fsBold];
end;

procedure TFOs.EqtdEnter(Sender: TObject);
begin
EQtd.color := $00E2F5FE;
EQtd.Font.Color := clNavy;
EQtd.Font.style := [fsBold];
end;

procedure TFOs.EEmbEnter(Sender: TObject);
begin
EEmb.color := $00E2F5FE;
EEmb.Font.Color := clNavy;
EEmb.Font.style := [fsBold];
end;

procedure TFOs.EPesoEnter(Sender: TObject);
begin
EPeso.color := $00E2F5FE;
EPeso.Font.Color := clNavy;
EPeso.Font.style := [fsBold];
end;

procedure TFOs.EObsEnter(Sender: TObject);
begin
EObs.color := $00E2F5FE;
EObs.Font.Color := clNavy;
EObs.Font.style := [fsBold];
end;

procedure TFOs.ECodigoExit(Sender: TObject);
begin
ECodigo.color := clWhite;
ECodigo.Font.Color := clBlack;
ECodigo.Font.style := [];
ECodigo.Text := RetZero(inttostr(strtoint(copy(ECodigo.Text, 1, 6))), 6) + '/' + copy(ECodigo.Text, 8, 2);

end;

procedure TFOs.EClienteExit(Sender: TObject);
begin
ECliente.color := clWhite;
ECliente.Font.Color := clBlack;
ECliente.Font.style := [];
If ECliente.text <> '' then  ECliente.text := Modulo.RetZero(ECliente.text,4);

end;

procedure TFOs.EFantasiaExit(Sender: TObject);
begin
EFantasia.color := clWhite;
Efantasia.Font.Color := clBlack;
EFantasia.Font.style := [];

end;

procedure TFOs.EFantasiaFChange(Sender: TObject);
// Compartilhado por EFantasiaF (painel PTerceirizar) e RxLookupEdit1 (painel
// PApontamento) - no BDE os dois eram duas visoes do MESMO cursor
// Modulo.DSFornec, por isso ambos usam a mesma lista FClientesCod e escrevem
// no mesmo EFornecedor.
var
  idx: Integer;
  Cb:  TComboBox;
begin
  if FUpdatingForn then Exit;
  if not (Sender is TComboBox) then Exit;
  Cb := TComboBox(Sender);

  idx := Cb.ItemIndex;
  if (FClientesCod <> nil) and (idx >= 0) and (idx < FClientesCod.Count) then
  begin
    FUpdatingForn := True;
    try
      EFornecedor.Text := FClientesCod[idx];
      // mantem os dois combos da mesma fonte em sincronia
      if (EFantasiaF <> Cb) and (idx < EFantasiaF.Items.Count) then
        EFantasiaF.ItemIndex := idx;
      if (RxLookupEdit1 <> Cb) and (idx < RxLookupEdit1.Items.Count) then
        RxLookupEdit1.ItemIndex := idx;
    finally
      FUpdatingForn := False;
    end;
  end
  else if Cb.Text = '' then
  begin
    FUpdatingForn := True;
    try EFornecedor.Text := ''; finally FUpdatingForn := False; end;
  end;
end;


procedure TFOs.EFantasiaFEnter(Sender: TObject);
begin
EFantasiaF.color := $00E2F5FE;
EFantasiaF.Font.Color := clNavy;
EFantasiaF.Font.style := [fsBold];
end;

procedure TFOs.EFantasiaFExit(Sender: TObject);
begin
EFantasiaF.color := clWhite;
EfantasiaF.Font.Color := clBlack;
EFantasiaF.Font.style := [];
end;


procedure TFOs.EPecaExit(Sender: TObject);
begin
EPEca.color := clWhite;
EPeca.Font.Color := clBlack;
EPeca.Font.style := [];

end;

procedure TFOs.EqtdExit(Sender: TObject);
begin
EQtd.color := clWhite;
EQtd.Font.Color := clBlack;
EQtd.Font.style := [];

end;

procedure TFOs.EEmbExit(Sender: TObject);
begin
EEmb.color := clWhite;
EEmb.Font.Color := clBlack;
EEmb.Font.style := [];

end;

procedure TFOs.EPesoExit(Sender: TObject);
begin
EPeso.color := clWhite;
EPeso.Font.Color := clBlack;
EPeso.Font.style := [];

end;

procedure TFOs.EProcFChange(Sender: TObject);
// Compartilhado por EProcF, RxLookupEdit2 e RxLookupEdit3 - os tres eram
// visoes do mesmo cursor Modulo.DSProc, por isso usam a mesma lista FProcCod
// e escrevem no mesmo ECod_proc.
var
  idx: Integer;
  Cb:  TComboBox;
begin
  if FUpdatingProc then Exit;
  if not (Sender is TComboBox) then Exit;
  Cb := TComboBox(Sender);

  idx := Cb.ItemIndex;
  if (FProcCod <> nil) and (idx >= 0) and (idx < FProcCod.Count) then
  begin
    FUpdatingProc := True;
    try
      ECod_proc.Text := FProcCod[idx];
      if (EProcF <> Cb) and (idx < EProcF.Items.Count) then
        EProcF.ItemIndex := idx;
      if (RxLookupEdit2 <> Cb) and (idx < RxLookupEdit2.Items.Count) then
        RxLookupEdit2.ItemIndex := idx;
      if (RxLookupEdit3 <> Cb) and (idx < RxLookupEdit3.Items.Count) then
        RxLookupEdit3.ItemIndex := idx;
    finally
      FUpdatingProc := False;
    end;
  end;
end;


procedure TFOs.EProcFEnter(Sender: TObject);
begin
EProcF.color := $00E2F5FE;
EProcF.Font.Color := clNavy;
EProcF.Font.style := [fsBold];

end;

procedure TFOs.EProcFExit(Sender: TObject);
begin
EProcF.color := clWhite;
EProcF.Font.Color := clBlack;
EProcF.Font.style := [];

end;


procedure TFOs.EObsExit(Sender: TObject);
begin
EObs.color := clWhite;
EObs.Font.Color := clBlack;
EObs.Font.style := [];

end;

procedure TFOs.EObsFEnter(Sender: TObject);
begin
EObsF.color := $00E2F5FE;
EObsF.Font.Color := clNavy;
EObsF.Font.style := [fsBold];

end;

procedure TFOs.EObsFExit(Sender: TObject);
begin
EObsF.color := clWhite;
EObsF.Font.Color := clBlack;
EObsF.Font.style := [];

end;

procedure TFOs.FormShow(Sender: TObject);
// A inicializacao vive no OnShow, nao no OnActivate.
//
// O form e sempre aberto por ShowModal (menu principal e UNf), logo o OnShow
// dispara a cada ENTRADA no formulario - e o form nunca reabre sujo, nem
// depois de uma OS apenas consultada.
//
// Por que nao no OnActivate: o OnActivate dispara tambem quando o form volta a
// ganhar foco, por exemplo ao fechar o FPecas aberto pelo botao "Pecas". Ali a
// reinicializacao apagaria a OS que esta sendo digitada - no BDE isso nao doia
// porque os dados viviam no cursor do TBOs, mas agora vivem apenas nos edits.
begin
FEmEdicao := False;
tipo := '';

if not GarantirConexao then Exit;
Modulo.NovaLeitura;   // combos/consultas sempre sobre dados atuais
PopularCombos;

habilitar;
limpar;

If varNf <> true then
begin
  ECodigo.Text := ObterProximoCodigo;
  ECodigo.SetFocus;
end else
begin
 ECodigo.Text := FNF.EOs.Text;
 BTOk.Click;
 BTFinalizar.Click;
 varNf := false;
end;

OPUrgente.Checked := false;

desabilitar;
end;


procedure TFOs.BTOKClick(Sender: TObject);
// No BDE este metodo fazia Append/Post/FindKey/Edit, gravando um registro-stub
// e deixando TBOs em dsEdit pela vida do form. Aqui faz apenas SELECT: nada e
// gravado antes do BTGravar.
begin
ECodigo.EditMask := '999999/99;0;_';
If length(ECodigo.Text) < 7 then
begin
 Application.MessageBox('O campo OS deve ser no formato numero OS/ano!!! Exemplo: 000001/05', 'Erro de campo', MB_Ok);
 ECodigo.Setfocus;
 exit;
end;
ECodigo.EditMask := '999999/99;1;_';

If ECodigo.Text = '' then
begin
ECodigo.SetFocus;
exit;
end;

if not GarantirConexao then Exit;
Modulo.NovaLeitura;   // consulta sempre sobre dados atuais

tipo := 'gravar';

QOsRel.Close;
QOsRel.ParamByName('pCodigo').AsString := ECodigo.Text;

habilitar;
Limpar;
EFantasia.color := $00E2F5FE;
Edata.Date := now;
EFantasia.Text := '';
ECliente.Text := '';

EFantasiaF.color := $00E2F5FE;
EdataEnvio.Text := '';
EdataRetorno.Text := '';
EFantasiaF.Text := '';
EFornecedor.Text := '';

ECod_proc.Text := '';
EProcF.Text := '';

OptRetorno.Checked := false;
OPUrgente.Enabled := true;
OPUrgente.Checked := false;

ECliente.SetFocus;

// Existe a OS?
QDesfinalizar.Close;
QDesfinalizar.SQL.Text :=
  'SELECT CODIGO, CLIENTE, DATA, NOTA, PECA, QUANTIDADE, PESO, EMBALAGEM, OBS, ' +
  'PROCESSO, LOTE, URGENCIA, FINALIZADA, FORNECEDOR, PROCESSO_FORNECEDOR, ' +
  'DATA_ENVIO, DATA_RETORNO, VALOR_RETORNO, OBS_FORNECEDOR, FLG_RETORNO ' +
  'FROM tb_os WHERE CODIGO = :pCodigo';
QDesfinalizar.ParamByName('pCodigo').AsString := ECodigo.Text;
try
  QDesfinalizar.Open;
except
  on E: Exception do
  begin
    try
      Modulo.ZConexao.Disconnect;
      Modulo.ZConexao.Connect;
      QDesfinalizar.Open;
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

If QDesfinalizar.IsEmpty then
begin
  QDesfinalizar.Close;
  // RESERVA o numero da OS agora, como o Append/Post do BDE fazia: sem isso
  // dois usuarios simultaneos emitiriam OS com o mesmo codigo.
  if not ReservarCodigo then Exit;
  tipo := 'gravar';
  BTIMPRIMIR.Enabled := FALSE;
  BTTerceirizar.Enabled := false;
end
else
begin
  tipo := 'alterar';
  BTTerceirizar.Enabled := true;

  ECliente.text := QDesfinalizar.FieldByName('CLIENTE').AsString;
  if not QDesfinalizar.FieldByName('DATA').IsNull then
    EData.Date := QDesfinalizar.FieldByName('DATA').AsDateTime;
  ENota.text    := QDesfinalizar.FieldByName('NOTA').AsString;
  ECodPeca.text := QDesfinalizar.FieldByName('PECA').AsString;
  EQtd.text     := QDesfinalizar.FieldByName('QUANTIDADE').AsString;
  EPeso.text    := QDesfinalizar.FieldByName('PESO').AsString;
  EEmb.text     := QDesfinalizar.FieldByName('EMBALAGEM').AsString;
  EObs.text     := QDesfinalizar.FieldByName('OBS').AsString;
  ELote.Text    := QDesfinalizar.FieldByName('LOTE').AsString;

  EFornecedor.Text := QDesfinalizar.FieldByName('FORNECEDOR').AsString;
  Ecod_proc.Text   := QDesfinalizar.FieldByName('PROCESSO_FORNECEDOR').AsString;
  if not QDesfinalizar.FieldByName('DATA_ENVIO').IsNull then
    EDataEnvio.Date := QDesfinalizar.FieldByName('DATA_ENVIO').AsDateTime;
  if not QDesfinalizar.FieldByName('DATA_RETORNO').IsNull then
    EDataRetorno.Date := QDesfinalizar.FieldByName('DATA_RETORNO').AsDateTime;
  EValorF.Value := QDesfinalizar.FieldByName('VALOR_RETORNO').AsFloat;
  EObsF.Text    := QDesfinalizar.FieldByName('OBS_FORNECEDOR').AsString;

  if QDesfinalizar.FieldByName('FLG_RETORNO').AsString = 'X' then OptRetorno.Checked := true else OptRetorno.Checked := false;
  if QDesfinalizar.FieldByName('URGENCIA').AsString = 'X' then OPUrgente.Checked := true else OPUrgente.Checked := false;

  if efornecedor.Text <> '' then BTIMPRIMIR.Enabled := TRUE else BTIMPRIMIR.Enabled := false;
end;
QDesfinalizar.Close;

FEmEdicao := True;
end;


procedure TFOs.ECodPecaEnter(Sender: TObject);
begin
ECodPeca.color := $00E2F5FE;
ECodPeca.Font.Color := clNavy;
ECodPeca.Font.style := [fsBold];

end;

procedure TFOs.ECodPecaExit(Sender: TObject);
begin
ECodPEca.color := clWhite;
ECodPeca.Font.Color := clBlack;
ECodPeca.Font.style := [];
If ECodPeca.text <> '' then  ECodPeca.text := Modulo.RetZero(ECodPeca.text,3);
end;

procedure TFOs.ECod_procChange(Sender: TObject);
// Usuario digita o codigo do processo de terceirizacao -> resolve o nome.
var Q: TZQuery;
begin
  if FUpdatingProc then Exit;
  if not GarantirConexao then Exit;

  FUpdatingProc := True;
  try
    if ECod_proc.Text = '' then
    begin
      EProcF.Text := '';
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
          EProcF.Text := Q.FieldByName('PROCESSO').AsString
        else
          EProcF.Text := '';
      except end;
    finally
      Q.Free;
    end;
  finally
    FUpdatingProc := False;
  end;
end;


procedure TFOs.ECod_procEnter(Sender: TObject);
begin
ECod_proc.color := $00E2F5FE;
ECod_proc.Font.Color := clNavy;
ECod_proc.Font.style := [fsBold];

end;

procedure TFOs.ECod_procExit(Sender: TObject);
begin
ECod_proc.color := clWhite;
ECod_proc.Font.Color := clBlack;
ECod_proc.Font.style := [];

end;

procedure TFOs.EDataEnter(Sender: TObject);
begin
EData.color := $00E2F5FE;
EData.Font.Color := clNavy;
EData.Font.style := [fsBold];
end;

procedure TFOs.EdataEnvioEnter(Sender: TObject);
begin
EdataEnvio.color := $00E2F5FE;
EdataEnvio.Font.Color := clNavy;
EdataEnvio.Font.style := [fsBold];

end;

procedure TFOs.EdataEnvioExit(Sender: TObject);
begin
EdataEnvio.color := clWhite;
EdataEnvio.Font.Color := clBlack;
EdataEnvio.Font.style := [];

end;

procedure TFOs.EDataExit(Sender: TObject);
begin
    EData.color := clWhite;
EData.Font.Color := clBlack;
EData.Font.style := [];

end;

procedure TFOs.EDataRetornoEnter(Sender: TObject);
begin
EDataRetorno.color := $00E2F5FE;
EDataRetorno.Font.Color := clNavy;
EDataRetorno.Font.style := [fsBold];

end;

procedure TFOs.EDataRetornoExit(Sender: TObject);
begin
EDataRetorno.color := clWhite;
EDataRetorno.Font.Color := clBlack;
EDataRetorno.Font.style := [];

end;

procedure TFOs.EClienteChange(Sender: TObject);
// Usuario digita o codigo do cliente -> resolve FANTASIA e recarrega a lista
// de pecas. Guard FUpdatingCli evita o ping-pong com EFantasiaChange.
var Q: TZQuery;
begin
  if FUpdatingCli then Exit;
  if not GarantirConexao then Exit;

  if ECliente.Text = '' then
  begin
    FUpdatingCli := True;
    try
      EFantasia.Text := '';
      EPeca.Items.Clear;
      if FPecasCod <> nil then FPecasCod.Clear;
    finally
      FUpdatingCli := False;
    end;
    Exit;
  end;

  cliente := Modulo.RetZero(ECliente.Text, 4);

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'SELECT FANTASIA FROM tb_clientes WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := cliente;
    try
      Q.Open;
      FUpdatingCli := True;
      try
        if not Q.IsEmpty then
        begin
          EFantasia.Text := Q.FieldByName('FANTASIA').AsString;
          CarregarListaPecas(cliente);
        end
        else
        begin
          EFantasia.Text := '';
          EPeca.Text := '';
          EPeca.Items.Clear;
          if FPecasCod <> nil then FPecasCod.Clear;
        end;
      finally
        FUpdatingCli := False;
      end;
    except end;
  finally
    Q.Free;
  end;
end;


procedure TFOs.ECodPecaChange(Sender: TObject);
// Usuario digita o codigo da peca -> carrega a peca e o processo dela.
var idx: Integer;
begin
  if FUpdatingPeca then Exit;
  if ECodPeca.Text = '' then Exit;

  SelecionarPeca(ECodPeca.Text);

  if (QPecas.Active) and (not QPecas.IsEmpty) then
  begin
    FUpdatingPeca := True;
    try
      EPeca.Text := QPecas.FieldByName('DESCRICAO').AsString;
      // mantem o ItemIndex coerente com a lista do combo
      if FPecasCod <> nil then
      begin
        idx := FPecasCod.IndexOf(Modulo.RetZero(ECodPeca.Text, 3));
        if (idx >= 0) and (idx < EPeca.Items.Count) then EPeca.ItemIndex := idx;
      end;
    finally
      FUpdatingPeca := False;
    end;
  end;
end;


procedure TFOs.EFantasiaChange(Sender: TObject);
// Usuario escolhe o cliente no combo -> preenche ECliente com o CODIGO.
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
      cliente := FClientesCod[idx];
      CarregarListaPecas(cliente);
    finally
      FUpdatingCli := False;
    end;
  end
  else if EFantasia.Text = '' then
  begin
    FUpdatingCli := True;
    try
      ECliente.Text := '';
      ECodigo.Text  := '';
    finally
      FUpdatingCli := False;
    end;
  end;
end;




procedure TFOs.EFornecedorChange(Sender: TObject);
// Fornecedor tambem e um cliente (era TBFornec sobre o mesmo CLIENTES.DB).
// Le de tb_clientes; a FK FK_OS_FORNEC foi repontada para tb_clientes.
var Q: TZQuery;
begin
  if FUpdatingForn then Exit;
  if not GarantirConexao then Exit;

  if EFornecedor.Text = '' then
  begin
    FUpdatingForn := True;
    try EFantasiaF.Text := ''; finally FUpdatingForn := False; end;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'SELECT FANTASIA FROM tb_clientes WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := Modulo.RetZero(EFornecedor.Text, 4);
    try
      Q.Open;
      FUpdatingForn := True;
      try
        if not Q.IsEmpty then
          EFantasiaF.Text := Q.FieldByName('FANTASIA').AsString
        else
          EFantasiaF.Text := '';
      finally
        FUpdatingForn := False;
      end;
    except end;
  finally
    Q.Free;
  end;
end;


procedure TFOs.EFornecedorEnter(Sender: TObject);
begin
EFornecedor.color := $00E2F5FE;
EFornecedor.Font.Color := clNavy;
EFornecedor.Font.style := [fsBold];

end;

procedure TFOs.EFornecedorExit(Sender: TObject);
begin
EFornecedor.color := clWhite;
EFornecedor.Font.Color := clBlack;
EFornecedor.Font.style := [];
If EFornecedor.text <> '' then  EFornecedor.text := Modulo.RetZero(EFornecedor.text,4);

end;

procedure TFOs.EPecaChange(Sender: TObject);
// Usuario escolhe a peca no combo -> preenche ECodPeca e carrega os dados.
// Substitui o par OnCloseUp/OnKeyUp do antigo TRxLookupEdit sobre QPecas.
var idx: Integer;
begin
  if FUpdatingPeca then Exit;

  idx := EPeca.ItemIndex;
  if (FPecasCod <> nil) and (idx >= 0) and (idx < FPecasCod.Count) then
  begin
    FUpdatingPeca := True;
    try
      ECodPeca.Text := FPecasCod[idx];
    finally
      FUpdatingPeca := False;
    end;
    SelecionarPeca(FPecasCod[idx]);
  end
  else if EPeca.Text = '' then
  begin
    FUpdatingPeca := True;
    try
      ECodPeca.Text := '';
    finally
      FUpdatingPeca := False;
    end;
    EPicture.Picture := nil;
  end;
end;




procedure TFOs.BTGravarClick(Sender: TObject);
var
  Q:   TZQuery;
  fin: Integer;
begin

If ECliente.Text = '' then
begin
  Application.MessageBox('O campo Cliente deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  EFantasia.SetFocus;
  exit;
end;

If EPeca.Text = '' then
begin
  Application.MessageBox('O campo Peca deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  EPeca.SetFocus;
  exit;
end;

If EPeso.Text = '' then
begin
  Application.MessageBox('O campo Peso deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  EPeso.SetFocus;
  exit;
end;

if not GarantirConexao then Exit;

If ClienteInativo(ECliente.Text) then
begin
  Application.MessageBox(pchar('O cliente ' + EFantasia.text + ' esta inativo e nao pode ser selecionado! Qualquer duvida entre em contato com o setor de vendas. '), 'AVISO', MB_oK+MB_IconInformation);
  ECliente.Clear;
  EFantasia.SetFocus;
  exit;
end;

// FINALIZADA e tinyint(1): AsInteger, nunca AsBoolean
fin := 0;
Q := TZQuery.Create(nil);
try
  Q.Connection := Modulo.ZConexao;
  Q.SQL.Text := 'SELECT FINALIZADA FROM tb_os WHERE CODIGO = :pCodigo';
  Q.ParamByName('pCodigo').AsString := ECodigo.Text;
  try
    Q.Open;
    if not Q.IsEmpty then fin := Q.FieldByName('FINALIZADA').AsInteger;
  except end;
finally
  Q.Free;
end;

If fin <> 0 then
begin
  Application.MessageBox('OS ja finalizada!', 'AVISO', MB_oK+MB_IconInformation);
  Exit;
end;

If Application.MessageBox(pchar('Deseja realmente ' + tipo + ' essa ordem de servico?'), pchar('Confirmacao para ' + tipo), MB_YESNO+MB_IconQuestion+MB_DEFBUTTON2) <> IDYes then
begin
  EFantasia.SetFocus;
  Exit;
end;

Q := TZQuery.Create(nil);
try
  Q.Connection := Modulo.ZConexao;

  // Sempre UPDATE: no caminho 'gravar' o registro ja existe, reservado pelo
  // BTOK (ReservarCodigo). Isso espelha o BDE, onde o Post do Append acontecia
  // no OK e o Gravar apenas preenchia os campos do registro ja criado.
  Q.SQL.Text :=
    'UPDATE tb_os SET CLIENTE=:pCliente, DATA=:pData, NOTA=:pNota, PECA=:pPeca, ' +
    'QUANTIDADE=:pQtd, PESO=:pPeso, EMBALAGEM=:pEmb, OBS=:pObs, PROCESSO=:pProc, ' +
    'LOTE=:pLote, URGENCIA=:pUrg WHERE CODIGO=:pCodigo';

  Q.ParamByName('pCodigo').AsString  := ECodigo.Text;
  Q.ParamByName('pCliente').AsString := Modulo.RetZero(ECliente.Text, 4);
  Q.ParamByName('pData').AsDate      := EData.Date;
  Q.ParamByName('pNota').AsString    := ENota.Text;
  Q.ParamByName('pPeca').AsString    := Modulo.RetZero(ECodPeca.Text, 3);
  Q.ParamByName('pEmb').AsString     := EEmb.Text;
  Q.ParamByName('pObs').AsString     := EObs.Text;
  Q.ParamByName('pLote').AsString    := ELote.Text;
  if OPUrgente.Checked then Q.ParamByName('pUrg').AsString := 'X'
                       else Q.ParamByName('pUrg').AsString := '';
  try Q.ParamByName('pQtd').AsFloat := StrToFloat(EQtd.Text); except Q.ParamByName('pQtd').AsFloat := 0; end;
  Q.ParamByName('pPeso').AsFloat := EPeso.Value;
  // PROCESSO da OS vem do processo da peca (antes era QProcCODIGO.text)
  if QProc.Active and not QProc.IsEmpty then
    Q.ParamByName('pProc').AsString := QProc.FieldByName('CODIGO').AsString
  else
    Q.ParamByName('pProc').Clear;

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
          Application.MessageBox(pchar('Erro ao salvar a OS: ' + E2.Message),
            pchar('ERRO'), MB_OK + MB_IconError);
          Exit;
        end;
      end;
    end;
  end;
finally
  Q.Free;
end;

FEmEdicao := False;

// Gravou. Imprimindo ou nao, o form termina posicionado para a proxima OS —
// o BTLimpar (que imprime) ja chama PosicionarNovaOS no fim, por isso aqui o
// reset so acontece no caminho do "nao imprimir".
If Application.MessageBox('Deseja imprimir essa Ordem de Servico?', 'Aviso de impressao!', MB_YESNO+MB_IconQuestion) = IDYes then
  BTLimpar.Click    // apesar do nome, IMPRIME a OS (comportamento do BDE)
else
  PosicionarNovaOS;
end;


procedure TFOs.BTLimparClick(Sender: TObject);
// ATENCAO: apesar do nome, este metodo IMPRIME a Ordem de Servico.
// Comportamento preservado da versao BDE.
begin
PrepararDatasetsRelatorio;

with FRelatOS do
begin
RelatOS.Clear;
LNumero.Caption := ECodigo.Text;
LNumero2.Caption := 'OS: ' + ECodigo.Text;
LNumero3.Caption := 'OS: ' + ECodigo.Text;
RNF.Caption := ENota.Text;
RNF2.Caption := ENota.Text;
RNF3.Caption := ENota.Text;
RLote.Caption := ELote.Text;
RLote2.Caption := ELote.Text;
RLote3.Caption := ELote.Text;
if (QPecas.Active) and (not QPecas.IsEmpty) and (QPecas.FieldByName('FIGURA').AsString <> '') then
begin
  try RLPicture.Picture.LoadFromFile(QPecas.FieldByName('FIGURA').AsString); except end;
end;

RLinha3.Caption := Elinha3.Text;
RQtd.Caption := EQtd.Text;
RQtd2.Caption := EQtd.Text;
RQtd3.Caption := EQtd.Text;
RPeso.Caption := formatfloat('######0.000', EPeso.Value) + ' Kg';
RPeso2.Caption := formatfloat('######0.000', EPeso.Value) + ' Kg';
RPeso3.Caption := formatfloat('######0.000', EPeso.Value) + ' Kg';
LData.Caption := Edata.Text;
//LData2.Caption := Edata.Text;
LData3.Caption := Edata.Text;
lhORA.Caption := TimetoStr(time);
Remb.Caption := EEmb.Text;
Remb2.Caption := EEmb.Text;
Remb3.Caption := EEmb.Text;
RObs.Caption := EObs.Text;
RObsPeca.Caption := EobsPeca.Text;
RObs2.Caption := EObs.Text;
RObs3.Caption := EObs2.Text;

// ITEM_SEG / ANALISE_DET sao tinyint(1) -> AsInteger, nunca AsBoolean
if (QPecas.Active) and (not QPecas.IsEmpty) and (QPecas.FieldByName('ITEM_SEG').AsInteger <> 0) then
begin
   RLItemSeg.Visible := true;
   RLItemSeg2.Visible := true;
   RLItemSeg3.Visible := true;
end else begin
   RLItemSeg.Visible := false;
   RLItemSeg2.Visible := false;
   RLItemSeg3.Visible := false;
end;

if (QPecas.Active) and (not QPecas.IsEmpty) and (QPecas.FieldByName('ANALISE_DET').AsInteger <> 0) then
   RLAnaliseDet.Visible := true
else
   RLAnaliseDet.Visible := false;

if OPUrgente.Checked = true then
   RLItemUrgente.Visible := true
else
   RLItemUrgente.Visible := false;

RelatOS.Preview;   // modal: so retorna quando o usuario fecha o preview

end;

// Impresso -> posiciona para a proxima OS (era o efeito colateral do
// OnActivate no BDE, ao fechar o Preview).
PosicionarNovaOS;
end;


procedure TFOs.BTDeletarClick(Sender: TObject);
var
  Q:   TZQuery;
  fin: Integer;
begin
if not GarantirConexao then Exit;

fin := 0;
Q := TZQuery.Create(nil);
try
  Q.Connection := Modulo.ZConexao;
  Q.SQL.Text := 'SELECT FINALIZADA FROM tb_os WHERE CODIGO = :pCodigo';
  Q.ParamByName('pCodigo').AsString := ECodigo.Text;
  try
    Q.Open;
    if not Q.IsEmpty then fin := Q.FieldByName('FINALIZADA').AsInteger;
  except end;
finally
  Q.Free;
end;

If fin <> 0 then
begin
  Application.MessageBox('Esta OS nao pode ser deletada porque ja foi finalizada!', 'AVISO', MB_oK+MB_IconInformation);
  Exit;
end;

If Application.MessageBox('Deseja realmente deletar esse cadastro?', 'Confirmacao de Exclusao', MB_YESNO+MB_IconQuestion) <> IDYes then
begin
  EFantasia.SetFocus;
  Exit;
end;

Q := TZQuery.Create(nil);
try
  Q.Connection := Modulo.ZConexao;
  // Nao apagar tb_os_finalizados aqui: FK_OSFIN_OS tem ON DELETE CASCADE,
  // o MySQL remove a finalizacao junto. FK_NFITENS_OS e ON DELETE SET NULL.
  Q.SQL.Text := 'DELETE FROM tb_os WHERE CODIGO = :pCodigo';
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
FEmEdicao := False;
ECodigo.Text := ObterProximoCodigo;
ECodigo.SetFocus;
Desabilitar;
end;


procedure TFOs.BTFinalizarClick(Sender: TObject);
var
  Q:      TZQuery;
  fin:    Integer;
  preco:  Double;
  ltmin:  Double;
begin
If Application.MessageBox(pchar('Deseja realmente finalizar essa ordem de servico?'), pchar('Confirmacao para ' + tipo), MB_YESNO+MB_IconQuestion+MB_DEFBUTTON2) <> IDYes then
begin
  EFantasia.SetFocus;
  Exit;
end;

if not GarantirConexao then Exit;

fin := 0;
Q := TZQuery.Create(nil);
try
  Q.Connection := Modulo.ZConexao;
  Q.SQL.Text := 'SELECT FINALIZADA FROM tb_os WHERE CODIGO = :pCodigo';
  Q.ParamByName('pCodigo').AsString := ECodigo.Text;
  try
    Q.Open;
    if not Q.IsEmpty then fin := Q.FieldByName('FINALIZADA').AsInteger;
  except end;
finally
  Q.Free;
end;

If fin <> 0 then
begin
  Application.MessageBox('OS ja finalizada!', 'AVISO', MB_oK+MB_IconInformation);
  Exit;
end;

preco := 0;
if (QPecas.Active) and (not QPecas.IsEmpty) then
  preco := QPecas.FieldByName('PRECO').AsFloat;
ltmin := LoteMinimoCliente(ECliente.Text);

PFinalizar.Visible := true;
OpRet.Checked := false;
OpDev.Checked := false;
EValor.SetFocus;
LValor.Caption := 'R$ ' + formatfloat('######0.0000', preco);
LPeso.Caption := EPeso.Text;
LLoteMinimo.Caption := 'R$ ' + CurrToStr(ltmin);

if ((preco * strtofloat(EPeso.Text)) > ltmin) then
   EValor.Value := preco * strtofloat(EPeso.Text)
else
   EValor.Value := ltmin;

desabilitar;
BTSair.Enabled := false;
ECodigo.Enabled := false;
BTOk.Enabled := false;
end;


procedure TFOs.ENotaExit(Sender: TObject);
begin
EnOTA.color := clWhite;
ENota.Font.Color := clBlack;
ENota.Font.style := [];

end;

procedure TFOs.EValorExit(Sender: TObject);
begin
EValor.color := clWhite;
EValor.Font.Color := clBlack;
EValor.Font.style := [];

end;

procedure TFOs.EValorFEnter(Sender: TObject);
begin
EValorF.color := $00E2F5FE;
EValorF.Font.Color := clNavy;
EValorF.Font.style := [fsBold];

end;

procedure TFOs.EValorFExit(Sender: TObject);
begin
EValorF.color := clWhite;
EValorF.Font.Color := clBlack;
EValorF.Font.style := [];

end;

procedure TFOs.EValorEnter(Sender: TObject);
begin
EValor.color := $00E2F5FE;
EValor.Font.Color := clNavy;
EValor.Font.style := [fsBold];
end;

procedure TFOs.BTFecharClick(Sender: TObject);
// Duas tabelas numa unica unidade de trabalho. No BDE eram dois Post
// independentes, sem transacao: falha no meio deixava a OS finalizada sem o
// registro de finalizacao. Aqui vai tudo ou nada.
var
  Q:      TZQuery;
  emTran: Boolean;
begin
if not GarantirConexao then Exit;

emTran := False;
Q := TZQuery.Create(nil);
try
  Q.Connection := Modulo.ZConexao;
  try
    // AutoCommit=False abre a transacao implicita no ZeosLib; nada e efetivado
    // ate o Commit. Nao usar StartTransaction junto (criaria savepoint aninhado).
    Modulo.ZConexao.AutoCommit := False;
    emTran := True;

    Q.SQL.Text := 'UPDATE tb_os SET FINALIZADA = 1 WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := ECodigo.Text;
    Q.ExecSQL;

    Q.SQL.Text :=
      'INSERT INTO tb_os_finalizados (CODIGO, NOTA, DATA_FIM, VALOR, RETRABALHO, DEVOLUCAO) ' +
      'VALUES (:pCodigo, :pNota, :pData, :pValor, :pRetr, :pDev)';
    Q.ParamByName('pCodigo').AsString := ECodigo.Text;
    Q.ParamByName('pNota').AsString   := ENota.Text;
    Q.ParamByName('pData').AsDate     := now;
    Q.ParamByName('pValor').AsFloat   := EValor.Value;
    // RETRABALHO / DEVOLUCAO sao tinyint(1)
    if OpRet.Checked then Q.ParamByName('pRetr').AsInteger := 1 else Q.ParamByName('pRetr').AsInteger := 0;
    if OpDev.Checked then Q.ParamByName('pDev').AsInteger := 1  else Q.ParamByName('pDev').AsInteger := 0;
    Q.ExecSQL;

    Modulo.ZConexao.Commit;
    emTran := False;
  except
    on E: Exception do
    begin
      if emTran then
        try Modulo.ZConexao.Rollback; except end;
      Application.MessageBox(pchar('Erro ao finalizar a OS. Nenhuma alteracao foi gravada.' + #13#10 + E.Message),
        pchar('ERRO'), MB_OK + MB_IconError);
      Exit;
    end;
  end;
finally
  Modulo.ZConexao.AutoCommit := True;
  Q.Free;
end;

  If Application.MessageBox('Deseja imprimir o Certificado de Qualidade?', 'CERTIFICADO DE QUALIDADE', MB_YesNo+MB_IConQuestion) = IdYes then
  begin
    FRelatCQ.ECodigo.Text := ECodigo.Text;
    FRelatCQ.ShowModal;
  end;
Limpar;
FEmEdicao := False;
ECodigo.Enabled := true;
BTOK.Enabled := true;
BTSair.Enabled := true;
ECodigo.Text := ObterProximoCodigo;
ECodigo.SetFocus;
Desabilitar;
PFinalizar.Visible := false;
PTerceirizar.Visible := false;
PApontamento.Visible := false;
end;


procedure TFOs.BTGravarEnter(Sender: TObject);
begin
BTGravar.ButtonColor := $00E2F5FE;
BTGravar.ButtonColor1 := clGray;
end;

procedure TFOs.BTGravarExit(Sender: TObject);
begin
BTGravar.ButtonColor := $00CACACA;
BTGravar.ButtonColor1 := $00CACACA;
end;

procedure TFOs.BTImprimirClick(Sender: TObject);
begin
PrepararDatasetsRelatorio;

with FRelatOS do
begin
RelatFornec.Clear;
LNumeroF.Caption := ECodigo.Text;

if (QPecas.Active) and (not QPecas.IsEmpty) and (QPecas.FieldByName('FIGURA').AsString <> '') then
begin
  try RLPictureF.Picture.LoadFromFile(QPecas.FieldByName('FIGURA').AsString); except end;
end;

RLPesoF.Caption := formatfloat('######0.000', EPeso.Value) + ' Kg';
RLEmbF.Caption := EEmb.Text;

RLDataF.Caption := Edata.Text;
RlhORAF.Caption := TimetoStr(time);
RLDataD.Caption := EdataRetorno.Text;

RLTratamento.Caption := EProcF.Text;

PFinalizar.Visible := false;
PTerceirizar.Visible := false;
PApontamento.Visible := false;

ECodigo.SetFocus;

RelatFornec.Preview;   // modal: so retorna quando o usuario fecha o preview

end;

// Impresso -> posiciona para a proxima OS (era o efeito colateral do
// OnActivate no BDE, ao fechar o Preview).
PosicionarNovaOS;
end;


procedure TFOs.BTImprimirEnter(Sender: TObject);
begin
BTIMprimir.ButtonColor := $00E2F5FE;
BTIMprimir.ButtonColor1 := clGray;

end;

procedure TFOs.BTImprimirExit(Sender: TObject);
begin
BTImprimir.ButtonColor := $00CACACA;
BTImprimir.ButtonColor1 := $00CACACA;

end;

procedure TFOs.BTFinalizarEnter(Sender: TObject);
begin
BTFinalizar.ButtonColor := $00E2F5FE;
BTFinalizar.ButtonColor1 := clGray;
end;

procedure TFOs.BTFinalizarExit(Sender: TObject);
begin
BTfinalizar.ButtonColor := $00CACACA;
BTFinalizar.ButtonColor1 := $00CACACA;
end;

procedure TFOs.BTLimparEnter(Sender: TObject);
begin
BTLimpar.ButtonColor := $00E2F5FE;
BTLimpar.ButtonColor1 := clGray;
end;

procedure TFOs.BTLimparExit(Sender: TObject);
begin
BTLimpar.ButtonColor := $00CACACA;
BTLimpar.ButtonColor1 := $00CACACA;
end;

procedure TFOs.BTSairEnter(Sender: TObject);
begin
BTSAir.ButtonColor := $00E2F5FE;
BTSair.ButtonColor1 := clGray;
end;

procedure TFOs.BTSairExit(Sender: TObject);
begin
BTSAir.ButtonColor := $00CACACA;
BTSair.ButtonColor1 := $00CACACA;
end;

procedure TFOs.BTTerceirizarClick(Sender: TObject);
begin
PTerceirizar.Visible := true;
end;

procedure TFOs.BTTerceirizarEnter(Sender: TObject);
begin
BTTerceirizar.ButtonColor := $00E2F5FE;
BTTerceirizar.ButtonColor1 := clGray;

end;

procedure TFOs.BTTerceirizarExit(Sender: TObject);
begin
BTTerceirizar.ButtonColor := $00CACACA;
BTTerceirizar.ButtonColor1 := $00CACACA;

end;

procedure TFOs.BTFecharExit(Sender: TObject);
begin
BTFechar.ButtonColor := $00CACACA;
BTFechar.ButtonColor1 := $00CACACA;
end;

procedure TFOs.BTFecharEnter(Sender: TObject);
begin
BTFechar.ButtonColor := $00E2F5FE;
BTFechar.ButtonColor1 := clGray;
end;

procedure TFOs.BTDeletarEnter(Sender: TObject);
begin
BTDeletar.ButtonColor := $00E2F5FE;
BTDeletar.ButtonColor1 := clGray;

end;

procedure TFOs.BTDeletarExit(Sender: TObject);
begin
BTdeletar.ButtonColor := $00CACACA;
BTdeletar.ButtonColor1 := $00CACACA;

end;

procedure TFOs.BTDesfinalizarClick(Sender: TObject);
var
  fin:      Integer;
  dtFim:    TDateTime;
  temNF:    Boolean;
  temReg:   Boolean;
  emTran:   Boolean;
begin
if not GarantirConexao then Exit;

// FINALIZADA e tinyint(1)
fin := 0;
QDesfinalizar.Close;
QDesfinalizar.SQL.Text := 'SELECT FINALIZADA FROM tb_os WHERE CODIGO = :pCodigo';
QDesfinalizar.ParamByName('pCodigo').AsString := ECodigo.Text;
try
  QDesfinalizar.Open;
  if not QDesfinalizar.IsEmpty then fin := QDesfinalizar.FieldByName('FINALIZADA').AsInteger;
except end;
QDesfinalizar.Close;

If fin = 0 then
begin
  Application.MessageBox('OS ainda nao finalizada!', 'AVISO', MB_oK+MB_IconInformation);
  Exit;
end;

If Application.MessageBox('Deseja realmente desfazer a finalizacao desta OS?', 'Confirmacao de Exclusao', MB_YESNO+MB_IconQuestion) <> IDYes then
  Exit;

// 1) Ja existe NF emitida?  (era ExecSQL sobre um SELECT - no Zeos precisa Open)
temNF := False;
QDesfinalizar.Close;
QDesfinalizar.SQL.Text :=
  'SELECT i.COD_OS FROM tb_nf_itens i, tb_nf nf ' +
  'WHERE nf.CODIGO = i.COD_NF AND nf.FLG_ENVIADA = :pFlag AND i.COD_OS = :pCodigo';
QDesfinalizar.ParamByName('pFlag').AsString   := 'S';
QDesfinalizar.ParamByName('pCodigo').AsString := ECodigo.Text;
try
  QDesfinalizar.Open;
  temNF := not QDesfinalizar.IsEmpty;
except
  on E: Exception do
  begin
    Application.MessageBox(pchar('Erro ao verificar NF: ' + E.Message), pchar('ERRO'), MB_OK+MB_IconError);
    Exit;
  end;
end;
QDesfinalizar.Close;

if temNF then
begin
  Application.MessageBox('A finalizacao desta OS nao pode ser desfeita pois ja existe uma NF emitida!', 'AVISO', MB_oK+MB_IconInformation);
  Exit;
end;

// 2) Prazo
temReg := False;
dtFim  := 0;
QDesfinalizar.Close;
QDesfinalizar.SQL.Text := 'SELECT DATA_FIM FROM tb_os_finalizados WHERE CODIGO = :pCodigo';
QDesfinalizar.ParamByName('pCodigo').AsString := ECodigo.Text;
try
  QDesfinalizar.Open;
  if not QDesfinalizar.IsEmpty then
  begin
    temReg := True;
    dtFim  := QDesfinalizar.FieldByName('DATA_FIM').AsDateTime;
  end;
except end;
QDesfinalizar.Close;

if temReg and (MonthsBetween(dtFim, now) > 0) and (dtFim < IncDay(now, -3)) then
begin
  Application.MessageBox('Ja passou o prazo para desfinalizar essa OS!', 'AVISO', MB_oK+MB_IconInformation);
  Exit;
end;

// 3) DELETE + UPDATE numa unica transacao (no BDE eram dois ExecSQL soltos)
emTran := False;
try
  // AutoCommit=False abre a transacao implicita no ZeosLib; nada e efetivado
  // ate o Commit. Nao usar StartTransaction junto (criaria savepoint aninhado).
  Modulo.ZConexao.AutoCommit := False;
  emTran := True;

  QDesfinalizar.Close;
  QDesfinalizar.SQL.Text := 'DELETE FROM tb_os_finalizados WHERE CODIGO = :pCodigo';
  QDesfinalizar.ParamByName('pCodigo').AsString := ECodigo.Text;
  QDesfinalizar.ExecSQL;

  QDesfinalizar.Close;
  QDesfinalizar.SQL.Text := 'UPDATE tb_os SET FINALIZADA = 0 WHERE CODIGO = :pCodigo';
  QDesfinalizar.ParamByName('pCodigo').AsString := ECodigo.Text;
  QDesfinalizar.ExecSQL;

  Modulo.ZConexao.Commit;
  emTran := False;
  Application.MessageBox('OS desfinalizada com sucesso!', 'AVISO', MB_oK+MB_IconInformation);
except
  on E: Exception do
  begin
    if emTran then
      try Modulo.ZConexao.Rollback; except end;
    Application.MessageBox(pchar('Erro ao desfinalizar. Nenhuma alteracao foi gravada.' + #13#10 + E.Message),
      pchar('ERRO'), MB_OK+MB_IconError);
    Modulo.ZConexao.AutoCommit := True;
    Exit;
  end;
end;
Modulo.ZConexao.AutoCommit := True;
QDesfinalizar.Close;

Limpar;
FEmEdicao := False;
ECodigo.Text := ObterProximoCodigo;
ECodigo.SetFocus;
Desabilitar;
end;


procedure TFOs.BTDesfinalizarEnter(Sender: TObject);
begin
BTDesfinalizar.ButtonColor := $00E2F5FE;
BTDesfinalizar.ButtonColor1 := clGray;

end;

procedure TFOs.BTDesfinalizarExit(Sender: TObject);
begin
BTDesfinalizar.ButtonColor := $00CACACA;
BTDesfinalizar.ButtonColor1 := $00CACACA;

end;

procedure TFOs.BTpecasClick(Sender: TObject);
begin

If principal.FPrincipal.Menu.Items[0].Items[3].Enabled = false then
begin
  FPecas.EPreco.Visible := false;
  FPecas.BTGravar.Enabled := false;
  FPecas.BTDeletar.Enabled := false;
  FPecas.BTDeletar.Enabled := false;
  FPecas.BTLimpar.Enabled := false;
  FPecas.BTLocalizar.Enabled := false;
end;

FPecas.showmodal;

// O FPecas ja esta migrado; recarrega a lista de pecas do cliente corrente
// (antes isso era TBClientes.FindKey + QPecas.Refresh sobre o BDE).
CarregarListaPecas(cliente);
if ECodPeca.Text <> '' then SelecionarPeca(ECodPeca.Text);

EPEca.SetFocus;
end;


procedure TFOs.BTCancelarEnter(Sender: TObject);
begin
BTCancelar.ButtonColor := $00E2F5FE;
BTCancelar.ButtonColor1 := clGray;
end;

procedure TFOs.BTCancelarExit(Sender: TObject);
begin
BTCancelar.ButtonColor := $00CACACA;
BTCancelar.ButtonColor1 := $00CACACA;
end;

procedure TFOs.BTAtualizarClick(Sender: TObject);
// Grava os dados de terceirizacao. FK_OS_FORNEC foi repontada para
// tb_clientes, senao este UPDATE falharia (errno 1452) nas OS cujo
// FORNECEDOR e um codigo de cliente.
var Q: TZQuery;
begin
if not GarantirConexao then Exit;

Q := TZQuery.Create(nil);
try
  Q.Connection := Modulo.ZConexao;
  Q.SQL.Text :=
    'UPDATE tb_os SET FORNECEDOR=:pForn, PROCESSO_FORNECEDOR=:pProc, ' +
    'DATA_ENVIO=:pEnvio, DATA_RETORNO=:pRetorno, VALOR_RETORNO=:pValor, ' +
    'OBS_FORNECEDOR=:pObs, FLG_RETORNO=:pFlg WHERE CODIGO=:pCodigo';
  Q.ParamByName('pCodigo').AsString := ECodigo.Text;
  // FORNECEDOR vazio grava NULL (a FK aceita NULL, mas nao string vazia)
  if EFornecedor.Text <> '' then
    Q.ParamByName('pForn').AsString := Modulo.RetZero(EFornecedor.Text, 4)
  else
    Q.ParamByName('pForn').Clear;
  if ECod_proc.Text <> '' then
    Q.ParamByName('pProc').AsString := Modulo.RetZero(ECod_proc.Text, 3)
  else
    Q.ParamByName('pProc').Clear;
  try Q.ParamByName('pEnvio').AsDate := EdataEnvio.Date; except Q.ParamByName('pEnvio').Clear; end;
  try Q.ParamByName('pRetorno').AsDate := EDataRetorno.Date; except Q.ParamByName('pRetorno').Clear; end;
  Q.ParamByName('pValor').AsFloat := EValorF.Value;
  Q.ParamByName('pObs').AsString  := EObsF.Text;
  if OptRetorno.Checked then Q.ParamByName('pFlg').AsString := 'X'
                        else Q.ParamByName('pFlg').AsString := '';

  try
    Q.ExecSQL;
  except
    on E: Exception do
    begin
      Application.MessageBox(pchar('Erro ao atualizar a terceirizacao: ' + E.Message),
        pchar('ERRO'), MB_OK + MB_IconError);
      Exit;
    end;
  end;
finally
  Q.Free;
end;

PFinalizar.Visible := false;
BTIMPRIMIR.Enabled := TRUE;

btok.Click;
end;


procedure TFOs.BTAtualizarEnter(Sender: TObject);
begin
BTatualizar.ButtonColor := $00E2F5FE;
BTAtualizar.ButtonColor1 := clGray;

end;

procedure TFOs.BTCancelar2Click(Sender: TObject);
begin

  PFinalizar.Visible := false;
  PTerceirizar.Visible := false;
  PApontamento.Visible := false;
  ECodigo.SetFocus;
end;

procedure TFOs.BTCancelar2Enter(Sender: TObject);
begin
BTCancelar2.ButtonColor := $00E2F5FE;
BTCancelar2.ButtonColor1 := clGray;

end;

procedure TFOs.BTCancelar2Exit(Sender: TObject);
begin
BTCancelar2.ButtonColor := $00CACACA;
BTCancelar2.ButtonColor1 := $00CACACA;

end;

procedure TFOs.BTCancelarClick(Sender: TObject);
// Nao chama Cancel (o BDE tambem nao chamava) - so devolve o form ao estado
// inicial. Comportamento preservado.
begin
  Application.MessageBox('Voce optou por nao finalizar essa OS. Lembre-se que ela constara ainda como OS Aberta!', 'AVISO', MB_Ok+MB_IconInformation);
  Limpar;
  FEmEdicao := False;   // volta ao estado inicial (nada pendente de gravacao)
  ECodigo.Enabled := true;
  BTOK.Enabled := true;
  BTSair.Enabled := true;
  ECodigo.Text := ObterProximoCodigo;
  ECodigo.SetFocus;
  Desabilitar;
  PFinalizar.Visible := false;
  PTerceirizar.Visible := false;
  PApontamento.Visible := false;
end;


procedure TFOs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Saindo com uma OS cujo numero foi reservado no OK mas nunca gravada:
  // apaga o registro-stub, liberando o numero. Mesmo comportamento do BDE,
  // que aqui fazia TBOs.Delete.
  If FEmEdicao and (tipo = 'gravar') then
  begin
    If Application.MessageBox(pchar('VOCE ESTA SAINDO COM UMA OS EM ABERTO! ELA SERA DELETADA! Deseja prosseguir?'),
         pchar('saindo do formulario ' + tipo),
         MB_YESNO+MB_IconQuestion+MB_DEFBUTTON2) <> IDYes then
    begin
      Action := caNone;
      Exit;              // o usuario desistiu de sair: form continua como esta
    end;
    LiberarCodigoReservado;
  end;

  FEmEdicao := False;
  tipo := '';
end;


procedure TFOs.OpRetClick(Sender: TObject);
var preco: Double;
begin
OpDev.Checked := false;
preco := 0;
if (QPecas.Active) and (not QPecas.IsEmpty) then
  preco := QPecas.FieldByName('PRECO').AsFloat;
try
  EValor.Value := preco * strtofloat(EPeso.Text);
except
  EValor.Value := 0;
end;
end;


procedure TFOs.OpDevClick(Sender: TObject);
begin
OpRet.Checked := false;
EValor.Value := 0;
end;

procedure TFOs.FormDockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin
// stub de debug removido (era um showmessage de teste)
end;


procedure TFOs.FormDockOver(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
// stub de debug removido
end;


procedure TFOs.EObsPecaEnter(Sender: TObject);
begin
EObsPeca.color := $00E2F5FE;
EObsPeca.Font.Color := clNavy;
EObsPeca.Font.style := [fsBold];

end;

procedure TFOs.EObsPecaExit(Sender: TObject);
begin
EObsPeca.color := clWhite;
EObsPeca.Font.Color := clBlack;
EObsPeca.Font.style := [];
end;

procedure TFOs.BTRetrabalhoEnter(Sender: TObject);
begin
BTRetrabalho.ButtonColor := $00E2F5FE;
BTRetrabalho.ButtonColor1 := clGray;
end;

procedure TFOs.BTRetrabalhoExit(Sender: TObject);
begin
BTRetrabalho.ButtonColor := $00CACACA;
BTRetrabalho.ButtonColor1 := $00CACACA;
end;

procedure TFOs.BTRetrabalhoClick(Sender: TObject);
var Q: TZQuery;
begin
If Application.MessageBox(pchar('Deseja realmente marcar essa OS como retrabalho?'), pchar('Confirmacao para ' + tipo), MB_YESNO+MB_IconQuestion+MB_DEFBUTTON2) <> IDYes then Exit;
if not GarantirConexao then Exit;

Q := TZQuery.Create(nil);
try
  Q.Connection := Modulo.ZConexao;
  // RETRABALHO e tinyint(1)
  Q.SQL.Text := 'UPDATE tb_os_finalizados SET RETRABALHO = 1 WHERE CODIGO = :pCodigo';
  Q.ParamByName('pCodigo').AsString := ECodigo.Text;
  try
    Q.ExecSQL;
    Application.MessageBox('Retrabalho marcado com sucesso!', 'AVISO', MB_oK+MB_IconInformation);
  except
    on E: Exception do
      Application.MessageBox(pchar('Erro ao marcar retrabalho: ' + E.Message), pchar('ERRO'), MB_OK+MB_IconError);
  end;
finally
  Q.Free;
end;
EFantasia.SetFocus;
end;


procedure TFOs.BTDevolucaoClick(Sender: TObject);
var Q: TZQuery;
begin
If Application.MessageBox(pchar('Deseja realmente marcar essa OS como devolucao?'), pchar('Confirmacao para ' + tipo), MB_YESNO+MB_IconQuestion+MB_DEFBUTTON2) <> IDYes then Exit;
if not GarantirConexao then Exit;

Q := TZQuery.Create(nil);
try
  Q.Connection := Modulo.ZConexao;
  Q.SQL.Text := 'UPDATE tb_os_finalizados SET DEVOLUCAO = 1 WHERE CODIGO = :pCodigo';
  Q.ParamByName('pCodigo').AsString := ECodigo.Text;
  try
    Q.ExecSQL;
    Application.MessageBox('Devolucao marcada com sucesso!', 'AVISO', MB_oK+MB_IconInformation);
  except
    on E: Exception do
      Application.MessageBox(pchar('Erro ao marcar devolucao: ' + E.Message), pchar('ERRO'), MB_OK+MB_IconError);
  end;
finally
  Q.Free;
end;
EFantasia.SetFocus;
end;


procedure TFOs.BTDevolucaoEnter(Sender: TObject);
begin
BTDevolucao.ButtonColor := $00E2F5FE;
BTDevolucao.ButtonColor1 := clGray;
end;

procedure TFOs.BTDevolucaoExit(Sender: TObject);
begin
BTDevolucao.ButtonColor := $00CACACA;
BTDevolucao.ButtonColor1 := $00CACACA;
end;

procedure TFOs.ELoteEnter(Sender: TObject);
begin
ELote.color := $00E2F5FE;
ELote.Font.Color := clNavy;
ELote.Font.style := [fsBold];

end;

procedure TFOs.ELoteExit(Sender: TObject);
begin
ELote.color := clWhite;
ELote.Font.Color := clBlack;
ELote.Font.style := [];

end;

function TFOS.RetZero(ZEROS:string;QUANT:integer):String;
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

end.
