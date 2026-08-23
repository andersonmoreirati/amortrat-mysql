unit UGerrelat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ZDataset, StdCtrls, IAeverButton, Mask, RXCtrls, DB, mdTabEnter, XBaloon, Grids, DBGrids, RXDBCtrl,
  rxToolEdit, DBCtrls;

type
  TFGerRelat = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Lista: TRxCheckListBox;
    Label2: TLabel;
    Campos: TComboBox;
    GroupBox3: TGroupBox;
    OpC: TRadioButton;
    OpD: TRadioButton;
    GPadrao: TGroupBox;
    ETexto: TEdit;
    OpTermina: TRadioButton;
    opComeca: TRadioButton;
    OpContem: TRadioButton;
    Label3: TLabel;
    GroupBox5: TGroupBox;
    BTSair: TIAeverButton;
    BTImprimir: TIAeverButton;
    Campos2: TComboBox;
    Label6: TLabel;
    QClientes: TZQuery;
    DSClientes: TDataSource;
    QProc: TZQuery;
    DSProc: TDataSource;
    DSpecas: TDataSource;
    QPecas: TZQuery;
    DSVendasG: TDataSource;
    QVendasG: TZQuery;
    QVendasF: TZQuery;
    DSVendasF: TDataSource;
    QOs: TZQuery;
    DSOs: TDataSource;
    Label5: TLabel;
    EInicio: TDateEdit;
    Label4: TLabel;
    EFim: TDateEdit;
    Label7: TLabel;
    ECliente: TEdit;
    EFantasia: TComboBox;   { era TRxLookupEdit }
    TabEnter1: TTabEnter;
    DsRank: TDataSource;
    QRank: TZQuery;
    QRANKF: TZQuery;
    DSRANKF: TDataSource;
    QProd: TZQuery;
    DSProd: TDataSource;
    QOSTerceiro: TZQuery;
    DSOSTerceiros: TDataSource;
    Label8: TLabel;
    procedure BTSairClick(Sender: TObject);
    procedure BTImprimirClick(Sender: TObject);
    procedure ListaClick(Sender: TObject);
    procedure EClienteChange(Sender: TObject);
    procedure EFantasiaChange(Sender: TObject);
    procedure ETextoEnter(Sender: TObject);
    procedure Campos2Enter(Sender: TObject);
    procedure EInicioEnter(Sender: TObject);
    procedure EFantasiaEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Campos2Exit(Sender: TObject);
    procedure ETextoExit(Sender: TObject);
    procedure EFantasiaExit(Sender: TObject);
    procedure EInicioExit(Sender: TObject);
    procedure QRankingCODIGOGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure QRankingFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    FClientesCod: TStringList;  // ItemIndex -> CODIGO do cliente
    FUpdatingCli: Boolean;      // guard ECliente <-> EFantasia
    function  GarantirConexao: Boolean;
    procedure PopularCombo;
    function  CodCliente: string;
    procedure PrepararNovaConsulta;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FGerRelat: TFGerRelat;

implementation

uses URelatorios, UModulo;

{$R *.dfm}

function TFGerRelat.GarantirConexao: Boolean;
// As 10 queries vem do DFM, mas Modulo.ZConexao e criado em RUNTIME
// (DataModuleCreate) e nao existe em design time: a ligacao e feita aqui.
var i: Integer;
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

  for i := 0 to ComponentCount - 1 do
    if Components[i] is TZQuery then
      TZQuery(Components[i]).Connection := Modulo.ZConexao;
  Result := True;
end;

procedure TFGerRelat.PopularCombo;
var Q: TZQuery;
begin
  if not GarantirConexao then Exit;
  if FClientesCod = nil then FClientesCod := TStringList.Create;
  if FClientesCod.Count > 0 then Exit;

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

function TFGerRelat.CodCliente: string;
// Substitui Modulo.CodCliente, que dependia do cursor BDE estar
// posicionado. O codigo ja esta no proprio form (ECliente).
begin
  if ECliente.Text <> '' then
    Result := Modulo.RetZero(ECliente.Text, 4)
  else
    Result := '';
end;

procedure TFGerRelat.EFantasiaChange(Sender: TObject);
// Usuario escolhe o cliente no combo -> preenche ECliente com o CODIGO.
// Substitui o par OnCloseUp/OnKeyUp do antigo TRxLookupEdit.
var idx: Integer;
begin
  if FUpdatingCli then Exit;
  idx := EFantasia.ItemIndex;
  FUpdatingCli := True;
  try
    if (FClientesCod <> nil) and (idx >= 0) and (idx < FClientesCod.Count) then
      ECliente.Text := FClientesCod[idx]
    else if EFantasia.Text = '' then
      ECliente.Text := '';
  finally
    FUpdatingCli := False;
  end;
end;

procedure TFGerRelat.BTSairClick(Sender: TObject);
begin
close;
end;

procedure TFGerRelat.PrepararNovaConsulta;
// Todo relatorio deve reexecutar do ZERO e enxergar os dados atuais.
//
// Dois motivos para nao bastar o Close/Open que ja existia:
//  1) o InnoDB roda em REPEATABLE READ; enquanto a transacao de leitura nao
//     for encerrada, o snapshot fica congelado e um cliente cadastrado depois
//     NAO aparece (era o bug relatado);
//  2) as queries usam Prepare; trocar o SQL sem Unprepare mantem o statement
//     preparado anterior.
var i: Integer;
begin
  if not GarantirConexao then Exit;

  for i := 0 to ComponentCount - 1 do
    if Components[i] is TZQuery then
      with TZQuery(Components[i]) do
      begin
        if Active then Close;
        try if Prepared then Unprepare; except end;
      end;

  Modulo.NovaLeitura;   // encerra a transacao -> proxima leitura pega dados novos
end;

procedure TFGerRelat.BTImprimirClick(Sender: TObject);
var condicao: string;
    peso_tot: double;
    nf_tot, geral_tot: currency;
begin

//FRelatorios.Free;

PrepararNovaConsulta;

Application.CreateForm(TFRelatorios, FRelatorios);

FRelatorios.RelatCLi.clear;
FRelatorios.RelatVendasG.clear;

FRelatorios.RelatRankG.clear;
FRelatorios.RelatOS.Clear;
FRelatorios.RelatProc.Clear;
FRelatorios.RelatVendasF.Clear;
FRelatorios.RelatVendasG.Clear;
FRelatorios.RelatVendasG.Refresh;
FRelatorios.RelatPecas.Clear;
FRelatorios.RelatProducao.Clear;
FRelatorios.RelatRanKF.Clear;
FRelatorios.RelatOSTerceiros.Clear;

  If Lista.ItemIndex = 0 then
  begin
    if opContem.Checked = true then
       condicao := ' where RAZAO like ' + QuotedStr('%' + Etexto.Text + '%');
    if opComeca.Checked = true then
       condicao := ' where RAZAO like ' + QuotedStr(Etexto.Text + '%');
    if opTermina.Checked = true then
       condicao := ' where RAZAO like ' + QuotedStr('%' + Etexto.Text);
    if campos2.ItemIndex = 1 then
    begin
       condicao := ' where INATIVO = 0 ';
       FRelatorios.LBTitRelatCliente.Caption := 'Cadastro de Clientes Ativos';
    end;
    if campos2.ItemIndex = 2 then
    begin
       condicao := ' where INATIVO = 1 ';
       FRelatorios.LBTitRelatCliente.Caption := 'Cadastro de Clientes Inativos';
    end;
    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by CODIGO';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by RAZAO';
    if opD.Checked = true then
       condicao := condicao + ' DESC';
    QClientes.Close;
    QClientes.SQL.Clear;
    QClientes.SQL.Text := 'select * from tb_clientes' + condicao;
    QClientes.Open;
    QClientes.Refresh;
    FRelatorios.RelatCLi.clear;
    FRelatorios.RelatCLi.preview;
end;
If Lista.ItemIndex = 1 then
  begin
    if opContem.Checked = true then
       condicao := ' where PROCESSO like ' + QuotedStr('%' + Etexto.Text + '%');
    if opComeca.Checked = true then
       condicao := ' where PROCESSO like ' + QuotedStr(Etexto.Text + '%');
    if opTermina.Checked = true then
       condicao := ' where PROCESSO like ' + QuotedStr('%' + Etexto.Text);
    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by CODIGO';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by processo';
    if opD.Checked = true then
       condicao := condicao + ' DESC';
    QProc.Close;
    Qproc.SQL.Clear;
    QProc.SQL.Text := 'select * from tb_proc' + condicao;
    Qproc.Open;
    Qproc.Refresh;
    FRelatorios.RelatProc.clear;
    FRelatorios.RelatProc.preview;
  end;
If Lista.ItemIndex = 2 then
  begin
     condicao := ' where A.COD_CLI = ' + QuotedStr(CodCliente) + ' AND A.COD_PROC = C.CODIGO AND B.CODIGO = A.COD_CLI';


    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by CODIGO';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by DESCRICAO';
    if opD.Checked = true then
       condicao := condicao + ' DESC';

    QPecas.Close;
    QPecas.SQL.Clear;
    QPecas.SQL.Text := 'select A.CODIGO, A.COD_CLI, A.COD_PROC, A.DESCRICAO, A.MATERIAL, A.PRECO, ' +
                      'A.DUREZA, A.FIGURA, B.RAZAO, C.PROCESSO ' +
                      'from tb_pecas A, tb_clientes B, tb_proc C' + condicao;

    QPecas.Open;
    QPecas.Refresh;
    FRelatorios.RelatPecas.clear;
    FRelatorios.RelatPecas.preview;
    QPecas.Close;
  end;
If Lista.ItemIndex = 3 then
  begin


    if Efantasia.Text <> '' then
      condicao := ' where A.CODIGO = B.CODIGO and B.CLIENTE = ' + QuotedStr(CodCliente) + ' and A.DATA_FIM >=:pInicial and A.DATA_FIM <=:pFinal and C.CODIGO = B.PECA and C.COD_CLI = B.CLIENTE and D.CODIGO = B.CLIENTE'
    else
      condicao := ' where A.CODIGO = B.CODIGO and A.DATA_FIM >=:pInicial and A.DATA_FIM <=:pFinal and C.CODIGO = B.PECA and C.COD_CLI = B.CLIENTE and D.CODIGO = B.CLIENTE';

    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by B.DATA';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by A.DATA_FIM';
    if campos.ItemIndex = 2 then
       condicao := condicao + ' order by A.CODIGO';
    if campos.ItemIndex = 3 then
       condicao := condicao + ' order by D.FANTASIA';
    if campos.ItemIndex = 4 then
       condicao := condicao + ' order by C.DESCRICAO';
    if campos.ItemIndex = 5 then
       condicao := condicao + ' order by A.VALOR';
    if opD.Checked = true then
       condicao := condicao + ' DESC';

    QVendasG.Close;
    QVendasG.SQL.Clear;
    QVendasG.SQL.Text := 'select A.CODIGO, A.DATA_FIM, A.VALOR, B.CLIENTE, B.PECA, B.DATA, B.PESO, ' +
                         'C.DESCRICAO, D.FANTASIA ' +
                         'from tb_os_finalizados A, tb_os B, tb_pecas C, tb_clientes D' + condicao;
    QVendasG.ParamByName('pInicial').AsDateTime := EInicio.date;
    QVendasG.ParamByName('pFinal').AsDateTime := EFim.date;
    QvendasG.Prepare;
    QvendasG.Open;

    FRelatorios.LData.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    FRelatorios.LTitulo.caption := ' Vendas Gerais ';
    FRelatorios.RelatVendasG.preview;
  end;
If Lista.ItemIndex = 4 then
  begin
    if Efantasia.Text <> '' then
      condicao := ' where A.COD_CLI = B.CODIGO and B.CODIGO = ' + QuotedStr(CodCliente) + ' and A.DATAE >=:pInicial and A.DATAE <=:pFinal'
    else
      condicao := ' where A.COD_CLI = B.CODIGO and A.DATAE >=:pInicial and A.DATAE <=:pFinal';

    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by A.DATAE';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by A.CODIGO';
    if campos.ItemIndex = 2 then
       condicao := condicao + ' order by B.CODIGO';
    if campos.ItemIndex = 3 then
       condicao := condicao + ' order by A.VALOR';
    if opD.Checked = true then
       condicao := condicao + ' DESC';

    QVendasF.Close;
    QVendasF.SQL.Clear;
    QVendasF.SQL.Text := 'select A.CODIGO, A.DATAE, A.VALOR, A.TIPO, A.TIPO_EMISSAO, A.COD_CLI, ' +
                         'B.FANTASIA from tb_nf A, tb_clientes B' + condicao;
    QVendasF.ParamByName('pInicial').AsDateTime := EInicio.date;
    QVendasF.ParamByName('pFinal').AsDateTime := EFim.date;
    QvendasF.Prepare;
    QvendasF.Open;
    QvendasF.Refresh;
    FRelatorios.RelatVendasF.clear;
    FRelatorios.LDataF.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    FRelatorios.RelatVendasF.preview;
  end;
If Lista.ItemIndex = 5 then
  begin
    if Efantasia.Text <> '' then
      condicao := ' where B.CODIGO = A.PECA and B.COD_CLI = A.CLIENTE and C.CODIGO = A.CLIENTE and A.CLIENTE = ' + QuotedStr(CodCliente) + ' and A.DATA >=:pInicial and A.DATA <=:pFinal AND B.COD_PROC = P.CODIGO'
    else
      condicao := ' where B.CODIGO = A.PECA and B.COD_CLI = A.CLIENTE and C.CODIGO = A.CLIENTE and A.DATA >=:pInicial and A.DATA <=:pFinal   AND B.COD_PROC = P.CODIGO';

    if opContem.Checked = true then
       condicao := condicao + ' and B.DESCRICAO like ' + QuotedStr('%' + Etexto.Text + '%') + ' ';
    if opComeca.Checked = true then
       condicao := condicao + ' and B.DESCRICAO like ' + QuotedStr(Etexto.Text + '%') + ' ';
    if opTermina.Checked = true then
       condicao := condicao + ' and B.DESCRICAO like ' + QuotedStr('%' + Etexto.Text) + ' ';

    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by A.CODIGO';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by C.FANTASIA';
    if campos.ItemIndex = 2 then
       condicao := condicao + ' order by A.PESO';
    if opD.Checked = true then
       condicao := condicao + ' DESC';

    FRelatorios.RelatOs.clear;
    FRelatorios.LDataOs.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    QOs.Close;
    QOs.SQL.Clear;
    QOs.SQL.Text := 'select A.CODIGO, A.CLIENTE, A.PECA, A.DATA, A.PESO, B.DESCRICAO, ' +
                    'C.FANTASIA, A.URGENCIA, 1 LEADTIME, P.PROCESSO ' +
                    'from tb_os A, tb_pecas B, tb_clientes C, tb_proc P' + condicao;
    QOs.ParamByName('pInicial').AsDateTime := EInicio.date;
    QOs.ParamByName('pFinal').AsDateTime := EFim.date;
    QOs.Prepare;
    QOs.Open;
    QOs.Refresh;
    FRelatorios.LBTitulo.Caption := 'OS EMITIDAS';
    FRelatorios.RelatOs.preview;
  end;

  If Lista.ItemIndex = 6 then
  begin
    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by PESO DESC';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by VALOR_G DESC';

    FRelatorios.RelatRankG.clear;
    FRelatorios.LDataRG.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    QRank.Close;
    QRank.SQL.Clear;
    Qrank.SQL.Text := 'select SUM(A.PESO) PESO, MAX(B.FANTASIA) FANTASIA, SUM(C.VALOR) VALOR_G from tb_os A, tb_clientes B, tb_os_finalizados C where B.CODIGO = A.CLIENTE and C.CODIGO = A.CODIGO and C.DATA_FIM >= :pInicial and C.DATA_FIM <= :pFinal group by A.CLIENTE, B.CODIGO ' + condicao;
    Qrank.ParamByName('pInicial').AsDateTime := EInicio.date;
    QRank.ParamByName('pFinal').AsDateTime := EFim.date;
    QRank.Prepare;
    QRank.Open;
    QRank.Refresh;
    FRelatorios.RelatRankG.preview;
  end;

If Lista.ItemIndex = 7 then
  begin
    FRelatorios.RelatRankF.clear;
    FRelatorios.LDataRF.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    QRankF.Close;
    QRankF.SQL.Clear;
    QrankF.SQL.Text := 'select sum(A.VALOR) VALOR_F, MAX(B.FANTASIA) FANTASIA from tb_nf A, tb_clientes B where A.COD_CLI = B.CODIGO and A.DATAE >= :pInicial and A.DATAE <= :pFinal GROUP BY A.COD_CLI order by VALOR_F DESC';
    QrankF.ParamByName('pInicial').AsDateTime := EInicio.date;
    QRankF.ParamByName('pFinal').AsDateTime := EFim.date;
    QRankF.Prepare;
    QRankF.Open;
    QRankF.Refresh;
    FRelatorios.RelatRankF.preview;
  end;

If Lista.ItemIndex = 8 then
  begin
    if Efantasia.Text <> '' then
      condicao := ' where B.CODIGO = A.PECA and B.COD_CLI = A.CLIENTE and C.CODIGO = A.CLIENTE and (A.FINALIZADA is null or A.FINALIZADA = 0) and A.CLIENTE = ' + QuotedStr(CodCliente) + ' and A.DATA >=:pInicial and A.DATA <=:pFinal  AND B.COD_PROC = P.CODIGO'
    else
      condicao := ' where B.CODIGO = A.PECA and B.COD_CLI = A.CLIENTE and C.CODIGO = A.CLIENTE and (A.FINALIZADA is null or A.FINALIZADA = 0) and A.DATA >=:pInicial and A.DATA <=:pFinal   AND B.COD_PROC = P.CODIGO';

    if opContem.Checked = true then
       condicao := condicao + ' and B.DESCRICAO like ' + QuotedStr('%' + Etexto.Text + '%') + ' ';
    if opComeca.Checked = true then
       condicao := condicao + ' and B.DESCRICAO like ' + QuotedStr(Etexto.Text + '%') + ' ';
    if opTermina.Checked = true then
       condicao := condicao + ' and B.DESCRICAO like ' + QuotedStr('%' + Etexto.Text) + ' ';

    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by LEADTIME DESC';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by A.CODIGO';
    if campos.ItemIndex = 2 then
       condicao := condicao + ' order by C.FANTASIA';
    if campos.ItemIndex = 3 then
       condicao := condicao + ' order by A.PESO';
    if opD.Checked = true then
       condicao := condicao + ' DESC';

    FRelatorios.RelatOs.clear;
    FRelatorios.LDataOs.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    QOs.Close;
    QOs.SQL.Clear;
    QOs.SQL.Text := 'select A.CODIGO, A.CLIENTE, A.PECA, A.DATA, A.PESO, B.DESCRICAO, ' +
                    'C.FANTASIA, A.URGENCIA, DATEDIFF(:pNow, A.DATA) LEADTIME, P.PROCESSO ' +
                    'from tb_os A, tb_pecas B, tb_clientes C, tb_proc P' + condicao;
    QOs.ParamByName('pNow').AsDateTime := Now;
    QOs.ParamByName('pInicial').AsDateTime := EInicio.date;
    QOs.ParamByName('pFinal').AsDateTime := EFim.date;
    QOs.Prepare;
    QOs.Open;
    QOs.Refresh;
    FRelatorios.LBTitulo.Caption := 'OS EMITIDAS NÃO FINALIZADAS';
    FRelatorios.RelatOs.preview;
  end;

If Lista.ItemIndex = 9 then
  begin
    if Efantasia.Text <> '' then
      condicao := ' where A.CODIGO = B.CODIGO and B.CLIENTE = ' + QuotedStr(CodCliente) + ' and B.DATA >=:pInicial and B.DATA <=:pFinal and C.CODIGO = B.PECA and C.COD_CLI = B.CLIENTE and D.CODIGO = B.CLIENTE'
    else
      condicao := ' where A.RETRABALHO = 1 and A.CODIGO = B.CODIGO and A.DATA_FIM >=:pInicial and A.DATA_FIM <=:pFinal and C.CODIGO = B.PECA and C.COD_CLI = B.CLIENTE and D.CODIGO = B.CLIENTE';

    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by B.DATA';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by A.DATA_FIM';
    if campos.ItemIndex = 2 then
       condicao := condicao + ' order by A.CODIGO';
    if campos.ItemIndex = 3 then
       condicao := condicao + ' order by D.FANTASIA';
    if campos.ItemIndex = 4 then
       condicao := condicao + ' order by C.DESCRICAO';
    if campos.ItemIndex = 5 then
       condicao := condicao + ' order by A.VALOR';
    if opD.Checked = true then
       condicao := condicao + ' DESC';

    QVendasG.Close;
    QVendasG.SQL.Clear;
    QVendasG.SQL.Text := 'select A.CODIGO, A.DATA_FIM, A.VALOR, B.CLIENTE, B.PECA, B.DATA, B.PESO, ' +
                         'C.DESCRICAO, D.FANTASIA ' +
                         'from tb_os_finalizados A, tb_os B, tb_pecas C, tb_clientes D' + condicao;
    QVendasG.ParamByName('pInicial').AsDateTime := EInicio.date;
    QVendasG.ParamByName('pFinal').AsDateTime := EFim.date;
    QvendasG.Prepare;
    QvendasG.Open;

    FRelatorios.LTitulo.caption := ' Itens Retrabalhados ';
    FRelatorios.LData.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    FRelatorios.RelatVendasG.preview;
  end;

If Lista.ItemIndex = 10 then
  begin
    if Efantasia.Text <> '' then
      condicao := ' where A.CODIGO = B.CODIGO and B.CLIENTE = ' + QuotedStr(CodCliente) + ' and A.DATA_FIM >=:pInicial and A.DATA_FIM <=:pFinal and C.CODIGO = B.PECA and C.COD_CLI = B.CLIENTE and D.CODIGO = B.CLIENTE'
    else
      condicao := ' where A.DEVOLUCAO = 1 and A.CODIGO = B.CODIGO and A.DATA_FIM >=:pInicial and A.DATA_FIM <=:pFinal and C.CODIGO = B.PECA and C.COD_CLI = B.CLIENTE and D.CODIGO = B.CLIENTE';

    if campos.ItemIndex = 0 then
       condicao := condicao + ' order by B.DATA';
    if campos.ItemIndex = 1 then
       condicao := condicao + ' order by A.DATA_FIM';
    if campos.ItemIndex = 2 then
       condicao := condicao + ' order by A.CODIGO';
    if campos.ItemIndex = 3 then
       condicao := condicao + ' order by D.FANTASIA';
    if campos.ItemIndex = 4 then
       condicao := condicao + ' order by C.DESCRICAO';
    if campos.ItemIndex = 5 then
       condicao := condicao + ' order by A.VALOR';
    if opD.Checked = true then
       condicao := condicao + ' DESC';

    QVendasG.Close;
    QVendasG.SQL.Clear;
    QVendasG.SQL.Text := 'select A.CODIGO, A.DATA_FIM, A.VALOR, B.CLIENTE, B.PECA, B.DATA, B.PESO, ' +
                         'C.DESCRICAO, D.FANTASIA ' +
                         'from tb_os_finalizados A, tb_os B, tb_pecas C, tb_clientes D' + condicao;
    QVendasG.ParamByName('pInicial').AsDateTime := EInicio.date;
    QVendasG.ParamByName('pFinal').AsDateTime := EFim.date;
    QvendasG.Prepare;
    QvendasG.Open;
    QvendasG.Refresh;

    FRelatorios.RelatVendasG.clear;
    FRelatorios.LTitulo.caption := ' Devoluções ';
    FRelatorios.LData.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    FRelatorios.RelatVendasG.preview;
  end;

  If Lista.ItemIndex = 11 then
  begin
    FRelatorios.RelatProducao.clear;
    FRelatorios.LDataRG.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    QProd.Close;
    QProd.SQL.Clear;
    QProd.SQL.Text := 'select C.FORNO, SUM(A.PESO) PESO, SUM(C.VALOR) VALOR_G from tb_os A, tb_os_finalizados C where C.CODIGO = A.CODIGO and C.DATA_FIM >= :pInicial and C.DATA_FIM <= :pFinal group by C.FORNO';
    QProd.ParamByName('pInicial').AsDateTime := EInicio.date;
    QProd.ParamByName('pFinal').AsDateTime := EFim.date;
    QProd.Prepare;
    QProd.Open;
    FRelatorios.LDataP.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    FRelatorios.RelatProducao.preview;
  end;

  If Lista.ItemIndex = 14 then
  begin
    FRelatorios.RelatOSTerceiros.clear;
    FRelatorios.LDataT.caption := ' De ' + datetostr(EInicio.Date) + ' até ' + datetostr(EFim.Date);
    if ETexto.Text <> '' then FRelatorios.LTituloT.caption := 'SERVIÇOS TERCEIRIZADOS RETORNADOS' else FRelatorios.LTituloT.caption := 'SERVIÇOS TERCEIRIZADOS EM ABERTO';
    QOsTerceiro.Close;
    QOsTerceiro.SQL.Clear;
    QOsTerceiro.SQL.Text := 'select B.CODIGO, D.FANTASIA, C.DESCRICAO, B.DATA_ENVIO, B.DATA_RETORNO, B.FLG_RETORNO, B.PESO from tb_os B, tb_pecas C, tb_clientes D where ';
    QOsTerceiro.SQL.Text :=  QOsTerceiro.SQL.Text + 'C.CODIGO = B.PECA and C.COD_CLI = B.CLIENTE and D.CODIGO = B.FORNECEDOR and B.DATA_ENVIO >= :pInicial and B.DATA_ENVIO <= :pFinal ';
    QOsTerceiro.ParamByName('pInicial').AsDateTime := EInicio.date;
    QOsTerceiro.ParamByName('pFinal').AsDateTime := EFim.date;
  //  if ETexto.Text <> '' then QOsTerceiro.SQL.Text := QOsTerceiro.SQL.Text + ' and B.FLG_RETORNO = ''X'''
  //  else QOsTerceiro.SQL.Text := QOsTerceiro.SQL.Text + ' and (B.FLG_RETORNO is null or B.FLG_RETORNO <> ''X'')';

    QOsTerceiro.SQL.Text := QOsTerceiro.SQL.Text + ' ORDER BY B.CODIGO';
    QOsTerceiro.Prepare;
    QOsTerceiro.Open;

    FRelatorios.RelatOSTerceiros.preview;
    ETexto.Text := '';
  end;

//lista.SetFocus;
Lista.Refresh;
Lista.Update;
Lista.ItemIndex := 0;
Lista.Checked[0] := True;
Campos.Items.Clear;
Campos.Items.Add('CÓDIGO');
Campos.Items.Add('RAZÃO SOCIAL');
campos.ItemIndex := 0;
Campos2.Items.Clear;
Campos2.Items.Add('RAZÃO SOCIAL');
campos2.ItemIndex := 0;
end;

procedure TFGerRelat.ListaClick(Sender: TObject);
begin
Lista.Checked[Lista.ItemIndex] := true;
 If Lista.ItemIndex = 0 then
  begin
    Campos.Items.Clear;
    Campos.Items.Add('CÓDIGO');
    Campos.Items.Add('RAZÃO SOCIAL');
    campos.ItemIndex := 0;
    Campos2.Items.Clear;
    Campos2.Items.Add('RAZÃO SOCIAL');
    Campos2.Items.Add('CLIENTES ATIVOS');
    Campos2.Items.Add('CLIENTES INATIVOS');
    campos2.ItemIndex := 0;
  end;
 If Lista.ItemIndex = 1 then
  begin
    Campos.Items.Clear;
    Campos.Items.Add('CÓDIGO');
    Campos.Items.Add('PROCESSO');
    campos.ItemIndex := 0;
    Campos2.Items.Clear;
    Campos2.Items.Add('PROCESSO');
    campos2.ItemIndex := 0;
  end;
 If Lista.ItemIndex = 2 then
  begin
    Campos.Items.Clear;
    Campos.Items.Add('CÓDIGO');
    Campos.Items.Add('DESCRIÇÃO');
    campos.ItemIndex := 0;
    campos2.Clear;
 end;
  If (Lista.ItemIndex = 3) or (Lista.ItemIndex = 9) or (Lista.ItemIndex = 10) then
  begin
    Campos.Items.Clear;
    Campos.Items.Add('DATA INICIO');
    Campos.Items.Add('DATA FIM');
    Campos.Items.Add('ORDEM DE SERVIÇO');
    Campos.Items.Add('CLIENTE');
    Campos.Items.Add('PEÇA');
    Campos.Items.Add('VALOR');
    campos.ItemIndex := 0;
    campos2.Clear;
 end;
 If Lista.ItemIndex = 4 then
  begin
    Campos.Items.Clear;
    Campos.Items.Add('DATA DE EMISSÃO');
    Campos.Items.Add('NOTA FISCAL');
    Campos.Items.Add('CLIENTE');
    Campos.Items.Add('VALOR');
    campos.ItemIndex := 0;
    campos2.clear;
 end;
      If (Lista.ItemIndex = 5)then
  begin
    Campos.Items.Clear;
    Campos.Items.Add('ORDEM DE SERVIÇO');
    Campos.Items.Add('CLIENTE');
    Campos.Items.Add('PESO');
    Campos2.Items.Clear;
    Campos2.Items.Add('PECA');
    campos2.ItemIndex := 0;
    campos.ItemIndex := 0;
 end;
If  (Lista.ItemIndex = 8) then
  begin
    Campos.Items.Clear;
    Campos.Items.Add('LEAD TIME');
    Campos.Items.Add('ORDEM DE SERVIÇO');
    Campos.Items.Add('CLIENTE');
    Campos.Items.Add('PESO');
    campos.ItemIndex := 0;
    Campos2.Items.Clear;
    Campos2.Items.Add('PECA');
    campos2.ItemIndex := 0;
 end;
  If Lista.ItemIndex = 6 then
  begin
    Campos.Items.Clear;
    Campos.Items.Add('PESO');
    Campos.Items.Add('VALOR');
    campos.ItemIndex := 0;
 end;
  If (Lista.ItemIndex = 7) or (Lista.ItemIndex = 11) then
  begin
    Campos.Items.Clear;
    campos.ItemIndex := 0;
 end;

   If Lista.ItemIndex = 14 then
  begin
    Campos2.Items.Clear;
    Campos2.Items.Add('FLAG_RETORNO');
    ETexto.Text := '';
    Campos2.ItemIndex := 0;
 end;

end;
procedure TFGerRelat.EClienteChange(Sender: TObject);
// Usuario digita o codigo -> resolve a FANTASIA.
// Antes usava TBClientes.FindKey/GotoKey sobre o cursor BDE compartilhado.
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


procedure TFGerRelat.ETextoEnter(Sender: TObject);
begin
TEdit(sender).color := $00E2F5FE;
TEdit(sender).Font.Color := clNavy;
TEdit(sender).Font.style := [fsBold];
end;

procedure TFGerRelat.Campos2Enter(Sender: TObject);
begin
TComboBox(sender).color := $00E2F5FE;
TComboBox(sender).Font.Color := clNavy;
TComboBox(sender).Font.style := [fsBold];

end;

procedure TFGerRelat.EInicioEnter(Sender: TObject);
begin
TDateEdit(sender).color := $00E2F5FE;
TDateEdit(sender).Font.Color := clNavy;
TDateEdit(sender).Font.style := [fsBold];

end;

procedure TFGerRelat.EFantasiaEnter(Sender: TObject);
begin
TComboBox(sender).color := $00E2F5FE;
TComboBox(sender).Font.Color := clNavy;
TComboBox(sender).Font.style := [fsBold];

end;


procedure TFGerRelat.FormShow(Sender: TObject);
// Inicializacao no OnShow, nao no OnActivate: o form abre por ShowModal, entao
// o OnShow dispara a cada entrada e NAO dispara ao voltar do preview do
// relatorio, o que limparia os filtros que o usuario acabou de montar.
begin
if not GarantirConexao then Exit;
PopularCombo;

Campos.Clear;
Campos2.Clear;
ETexto.Clear;
EInicio.Clear;
EFim.Clear;
ECliente.Clear;
EFantasia.Clear;
lista.SetFocus;
Lista.ItemIndex := 0;
Campos.Items.Clear;
Campos.Items.Add('CÓDIGO');
Campos.Items.Add('RAZÃO SOCIAL');
campos.ItemIndex := 0;
Campos2.Items.Clear;
Campos2.Items.Add('RAZÃO SOCIAL');
Campos2.Items.Add('CLIENTES ATIVOS');
Campos2.Items.Add('CLIENTES INATIVOS');
campos2.ItemIndex := 0;

// Restricao de relatorios para o usuario PRODUCAO.
// Antes lia Modulo.TBUsuarioLOGIN.Value (cursor BDE de tb_usuario); agora usa o
// login que o ULogin guarda no momento da autenticacao.
if Modulo.UsuarioLogado = 'PRODUCAO' then
begin
  Lista.EnabledItem[3] := false;
  Lista.EnabledItem[4] := false;
  Lista.EnabledItem[6] := false;
  Lista.EnabledItem[7] := false;
end
else
begin
  Lista.EnabledItem[3] := true;
  Lista.EnabledItem[4] := true;
  Lista.EnabledItem[6] := true;
  Lista.EnabledItem[7] := true;
end;


end;

procedure TFGerRelat.Campos2Exit(Sender: TObject);
begin
TComboBox(sender).color := clWhite;
TComboBox(sender).Font.Color := clBlack;
TComboBox(sender).Font.style := [];

end;

procedure TFGerRelat.ETextoExit(Sender: TObject);
begin
TEdit(sender).color := clWhite;
TEdit(sender).Font.Color := clBlack;
TEdit(sender).Font.style := [];

end;

procedure TFGerRelat.EFantasiaExit(Sender: TObject);
begin
TComboBox(sender).color := clWhite;
TComboBox(sender).Font.Color := clBlack;
TComboBox(sender).Font.style := [];
end;

procedure TFGerRelat.EInicioExit(Sender: TObject);
begin
TDateEdit(sender).color := clWhite;
TDateEdit(sender).Font.Color := clBlack;
TDateEdit(sender).Font.style := [];
end;

procedure TFGerRelat.QRankingCODIGOGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
// Stub de debug do BDE; nao esta ligado a nenhum evento no DFM.
end;

procedure TFGerRelat.QRankingFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
// Stub de debug do BDE; nao esta ligado a nenhum evento no DFM.
end;


end.
