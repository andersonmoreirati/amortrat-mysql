{$OPTIMIZATION ON}
unit UNf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IAeverButton, ExtCtrls, Mask,
  DBCtrls, Grids, BaseGrid, AdvGrid, DB, ZDataset,
  XBaloon, mdTabEnter, jpeg, Math,
 // ACBrNFeDANFEClass,
  ACBrNFe, pcnConversao, ACBrUtil, ComCtrls, OleCtrls, SHDocVw, RXCtrls,
  VrControls, VrHyperCtrls, UrlMon, AdvObj, Clipbrd, rxCurrEdit, rxToolEdit,
  ACBrNFeDANFeRLClass, ACBrBase, ACBrDFe, ACBrMail,
  //ACBrDANFCeFortesFr,
  DateUtils, ACBrNFeDANFEClass, ACBrDFeReport, ACBrDFeDANFeReport, ACBrDFeUtil, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdSSLOpenSSL;

type
  TFNf = class(TForm)
    G2: TGroupBox;
    BTSair: TIAeverButton;
    BTImprimir: TIAeverButton;
    QOs: TZQuery;
    QOS_Fin: TZQuery;
    QPecas: TZQuery;
    G1: TGroupBox;
    Label1: TLabel;
    Label9: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    EDataE: TDateEdit;
    ENatureza: TEdit;
    ECFOP: TEdit;
    EDataS: TDateEdit;
    // Grid: TAdvSpreadGrid;
    BTOK: TIAeverButton;
    Panel2: TPanel;
    Label5: TLabel;
    Panel3: TPanel;
    Label7: TLabel;
    ENome: TEdit;
    Label8: TLabel;
    GroupBox3: TGroupBox;
    OpE: TRadioButton;
    OpD: TRadioButton;
    EOs: TMaskEdit;
    BTLimpar: TIAeverButton;
    ETotal: TCurrencyEdit;
    TabEnter1: TTabEnter;
    GroupBox1: TGroupBox;
    OpEnt: TRadioButton;
    OpS: TRadioButton;
    GroupBox4: TGroupBox;
    OpTot: TRadioButton;
    OpPar: TRadioButton;
    Label13: TLabel;
    ECliente: TEdit;
    EFantasia: TComboBox;
    Panel5: TPanel;
    Panel6: TPanel;
    ECodigo: TEdit;
    BTOK2: TIAeverButton;
    Label14: TLabel;
    BTGravar: TIAeverButton;
    EQtd: TEdit;
    Label15: TLabel;
    EEsp: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    EPesoB: TCurrencyEdit;
    EPesoL: TCurrencyEdit;
    Modelo: TGroupBox;
    opPrazo: TRadioButton;
    opVista: TRadioButton;
    BTadd: TIAeverButton;
    ACBrNFe1: TACBrNFe;
    BTDeleteRow: TIAeverButton;
    QNF_Ref: TZQuery;
    QNF_Itens: TZQuery;
    Clink: TLabel;
    Label21: TLabel;
    EChNfe: TEdit;
    CChNfe: TLabel;
    QNF_Config: TZQuery;
    BTCancelar: TIAeverButton;
    lbNaoEnviada: TLabel;
    BTEnviar: TIAeverButton;
    PNFCliente: TPanel;
    Label28: TLabel;
    BTFechar: TIAeverButton;
    // GridNF: TAdvSpreadGrid;
    BTMenos: TIAeverButton;
    BTMais: TIAeverButton;
    EValorNF: TCurrencyEdit;
    Label12: TLabel;
    EDataNF: TDateEdit;
    Label10: TLabel;
    ENF: TEdit;
    Label11: TLabel;
    Lvalor: TLabel;
    BTNFCliente: TIAeverButton;
    QEMail: TZQuery;
    ECFOPRetorno: TEdit;
    Label20: TLabel;
    ECST: TEdit;
    Label22: TLabel;
    ECSTRetorno: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    ETotalBenef: TCurrencyEdit;
    EDuplicata: TDateEdit;
    Label25: TLabel;
    Image1: TImage;
    BTEmail: TIAeverButton;
    GridNF: TAdvStringGrid;
    Grid: TAdvStringGrid;
    BTRecuperar: TIAeverButton;
    MemoResp: TMemo;
    EInfAdic: TMemo;
    Label4: TLabel;
    Label16: TLabel;
    ECred: TCurrencyEdit;
    EAliqICMS: TCurrencyEdit;
    EPlaca: TEdit;
    Label26: TLabel;
    Eestado: TComboBox;
    Label27: TLabel;
    GroupBox2: TGroupBox;
    OpNormal: TRadioButton;
    OpDevolucao: TRadioButton;
    Eicms: TCurrencyEdit;
    ACBrNFeDANFeRL1: TACBrNFeDANFeRL;
    ACBrMail1: TACBrMail;
    BTCartaCorrecao: TIAeverButton;
    GroupBox5: TGroupBox;
    Opt30: TCheckBox;
    Opt45: TCheckBox;
    Opt60: TCheckBox;
    QNCM: TZQuery;
    { Datasets locais que substituem os TTable BDE do UModulo. O UModulo segue
      BDE enquanto houver form nao migrado, entao o UNf nao pode depender dele
      (mesmo criterio adotado no UOS e no principal).
        QNf         -> le a NF corrente            (era Modulo.TBNf)
        QNfCmd      -> INSERT/UPDATE/DELETE tb_nf
        QNfItensCmd -> comandos em tb_nf_itens     (era Modulo.TBNf_Itens)
        QNfRefCmd   -> comandos em tb_nf_ref       (era Modulo.TBNf_Ref)
        QCli        -> le cliente / emitente       (era Modulo.TBClientes)
        QCfg        -> le e grava tb_config        (era Modulo.TBConfig) }
    QNf: TZQuery;
    QNfCmd: TZQuery;
    QNfItensCmd: TZQuery;
    QNfRefCmd: TZQuery;
    QCli: TZQuery;
    QCfg: TZQuery;

    procedure BTSairClick(Sender: TObject);
    procedure FormRefresh(Sender: TObject);

    procedure BTOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BTLimparClick(Sender: TObject);
    procedure ENaturezaEnter(Sender: TObject);
    procedure ECFOPEnter(Sender: TObject);
    procedure EDataEEnter(Sender: TObject);
    procedure EDuplicataEnter(Sender: TObject);
    procedure ENFEnter(Sender: TObject);
    procedure EDataNFEnter(Sender: TObject);
    procedure EValorNFEnter(Sender: TObject);
    procedure EOsEnter(Sender: TObject);
    procedure ENomeEnter(Sender: TObject);
    procedure ENaturezaExit(Sender: TObject);
    procedure ECFOPExit(Sender: TObject);
    procedure EDataEExit(Sender: TObject);
    procedure EDuplicataS(Sender: TObject);
    procedure ENFExit(Sender: TObject);
    procedure EDataNFExit(Sender: TObject);
    procedure EValorNFExit(Sender: TObject);
    procedure EOsExit(Sender: TObject);
    procedure ENomeExit(Sender: TObject);
    procedure BTImprimirClick(Sender: TObject);
    procedure BTImprimirEnter(Sender: TObject);
    procedure BTImprimirExit(Sender: TObject);
    procedure BTLimparEnter(Sender: TObject);
    procedure BTLimparExit(Sender: TObject);
    procedure BTSairEnter(Sender: TObject);
    procedure BTSairExit(Sender: TObject);
    procedure BTGravarEnter(Sender: TObject);
    procedure BTGravarExit(Sender: TObject);
    procedure EClienteChange(Sender: TObject);
    procedure EClienteEnter(Sender: TObject);
    procedure EClienteExit(Sender: TObject);
    procedure EClienteKeyPress(Sender: TObject; var Key: Char);
    procedure EFantasiaChange(Sender: TObject);
    procedure EFantasiaEnter(Sender: TObject);
    procedure EFantasiaExit(Sender: TObject);
    procedure ECodigoKeyPress(Sender: TObject; var Key: Char);
    procedure ECodigoEnter(Sender: TObject);
    procedure ECodigoExit(Sender: TObject);
    procedure BTOK2Click(Sender: TObject);
    procedure BTGravarClick(Sender: TObject);
    procedure EQtdEnter(Sender: TObject);
    procedure EEspEnter(Sender: TObject);
    procedure EPesoBEnter(Sender: TObject);
    procedure EPesoLEnter(Sender: TObject);
    procedure EQtdExit(Sender: TObject);
    procedure EEspExit(Sender: TObject);
    procedure EPesoBExit(Sender: TObject);
    procedure EPesoLExit(Sender: TObject);
    procedure ENF2Exit(Sender: TObject);
    procedure ENF2Enter(Sender: TObject);
    procedure EDataNF2Enter(Sender: TObject);
    procedure EDataNF2Exit(Sender: TObject);
    procedure EvalorNF2Enter(Sender: TObject);
    procedure EvalorNF2Exit(Sender: TObject);
    procedure BTMaisEnter(Sender: TObject);
    procedure BTMaisExit(Sender: TObject);
    procedure BTMaisClick(Sender: TObject);
    procedure BTVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BTaddClick(Sender: TObject);
    procedure EicmsEnter(Sender: TObject);
    procedure EicmsExit(Sender: TObject);
    procedure BTNfeClick(Sender: TObject);
    procedure ACBrNFe1StatusChange(Sender: TObject);
    procedure BTDeleteRowClick(Sender: TObject);
    procedure BTMenosClick(Sender: TObject);
    procedure ClinkClick(Sender: TObject);
    procedure BTEnviarEnter(Sender: TObject);
    procedure BTEnviarExit(Sender: TObject);
    procedure BTNFClienteClick(Sender: TObject);
    procedure BTFecharClick(Sender: TObject);
    procedure BTCancelarClick(Sender: TObject);
    procedure BTEnviarClick(Sender: TObject);
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ECSTEnter(Sender: TObject);
    procedure ECSTExit(Sender: TObject);
    procedure ECFOPRetornoEnter(Sender: TObject);
    procedure ECFOPRetornoExit(Sender: TObject);
    procedure ECSTRetornoEnter(Sender: TObject);
    procedure ECSTRetornoExit(Sender: TObject);
    procedure BTEmailClick(Sender: TObject);
    procedure BTEmailEnter(Sender: TObject);
    procedure BTEmailExit(Sender: TObject);
    procedure BTRecuperarEnter(Sender: TObject);
    procedure BTRecuperarExit(Sender: TObject);
    procedure BTRecuperarClick(Sender: TObject);
    procedure ECredEnter(Sender: TObject);
    procedure ECredExit(Sender: TObject);
    procedure ETotalBenefChange(Sender: TObject);
    procedure EPlacaEnter(Sender: TObject);
    procedure EPlacaExit(Sender: TObject);
    procedure EestadoEnter(Sender: TObject);
    procedure EestadoExit(Sender: TObject);
    procedure opPrazoClick(Sender: TObject);
    procedure opVistaClick(Sender: TObject);
    procedure OpDevolucaoClick(Sender: TObject);
    procedure OpNormalClick(Sender: TObject);
    procedure BTCartaCorrecaoClick(Sender: TObject);


  private
    { campos ANTES dos metodos - armadilha #3 }
    FClientesCod: TStringList;   { ItemIndex do EFantasia -> CODIGO do cliente }
    FCodigoReservado: string;    { PK pre-reservada em tb_nf, para liberar no Close }
    function  GarantirConexao: Boolean;
    function  LerConfig(CodConfig: Integer): string;
    procedure GravarConfig(CodConfig: Integer; const Valor: string);
    function  ProximoCodigoNf: string;
    function  ReservarCodigoNf(var Codigo: string): Boolean;
    procedure LiberarCodigoReservado;
    procedure AtualizarFlagNf(const CodNf, Flag: string);
    procedure AtualizarNfEnviada(const CodNf, ChaveNfe, PathNfe: string);
    function  LerCampoNf(const CodNf, Campo: string): string;
    function  CarregarCliente(const CodCliente: string): Boolean;
    procedure CarregarNf(const CodNf: string);
    procedure CarregarClientesCombo;
    procedure Limpar;
    procedure Habilitar;
    procedure Desabilitar;
    procedure gravaOs;
    procedure enviaNfe;
    procedure notificaTelegram;
    function RemoveChar(Const Texto: String): String;
    function DigitoCidade(Codigo: String): String;
    Function ProximoDiaUtil(dData: TDateTime): TDateTime;
    Function SomaMes(dData: TDateTime; xMeses: Integer;
      lCorrido: Boolean): TDateTime;
    Function MenorDataValida(Ano, Mes, Dia: Word): TDateTime;

    Function ArredondaFinal5(valor: Double): Double;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNf: TFNf;
  item: Integer;
  Codigo: string;
  tipo: string;
  qtd, removerLinha: double;
  ativar: Boolean = true;
  ambiente: string;

implementation

uses UModulo, URelarNF, UOS, ufrmStatus,
  pcnProcNFe,
  pcnConversaoNFe,
  ACBrNFeNotasFiscais;
{$R *.dfm}

// ---------------------------------------------------------------------------
// Infraestrutura MySQL (substitui os TTable BDE do UModulo)
// ---------------------------------------------------------------------------

function TFNf.GarantirConexao: Boolean;
{ Os TZQuery vivem no DFM, mas Modulo.ZConexao e criado em runtime e nao existe
  em design time (secao 4.1 do HANDOFF). }
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

  QOs.Connection          := Modulo.ZConexao;
  QOS_Fin.Connection      := Modulo.ZConexao;
  QPecas.Connection       := Modulo.ZConexao;
  QNF_Ref.Connection      := Modulo.ZConexao;
  QNF_Itens.Connection    := Modulo.ZConexao;
  QNF_Config.Connection   := Modulo.ZConexao;
  QEMail.Connection       := Modulo.ZConexao;
  QNCM.Connection         := Modulo.ZConexao;
  QNf.Connection          := Modulo.ZConexao;
  QNfCmd.Connection       := Modulo.ZConexao;
  QNfItensCmd.Connection  := Modulo.ZConexao;
  QNfRefCmd.Connection    := Modulo.ZConexao;
  QCli.Connection         := Modulo.ZConexao;
  QCfg.Connection         := Modulo.ZConexao;
  Result := True;
end;

function TFNf.LerConfig(CodConfig: Integer): string;
{ Substitui Modulo.TBConfig.FindKey([...]) + GotoKey + TBConfigVLR_CONFIG. }
begin
  Result := '';
  if not GarantirConexao then Exit;
  QCfg.Close;
  QCfg.SQL.Text := 'SELECT VLR_CONFIG FROM tb_config WHERE COD_CONFIG = :pCod';
  QCfg.ParamByName('pCod').AsInteger := CodConfig;
  try
    QCfg.Open;
    if not QCfg.IsEmpty then
      Result := QCfg.FieldByName('VLR_CONFIG').AsString;
  finally
    QCfg.Close;
  end;
end;

procedure TFNf.GravarConfig(CodConfig: Integer; const Valor: string);
{ Substitui TBConfig.FindKey + Edit + Post. So atualiza registro existente,
  como fazia o FindKey/GotoKey (que nao inseria quando nao achava). }
begin
  if not GarantirConexao then Exit;
  QCfg.Close;
  QCfg.SQL.Text := 'UPDATE tb_config SET VLR_CONFIG = :pVal WHERE COD_CONFIG = :pCod';
  QCfg.ParamByName('pVal').AsString  := Valor;
  QCfg.ParamByName('pCod').AsInteger := CodConfig;
  QCfg.ExecSQL;
end;

function TFNf.ProximoCodigoNf: string;
{ Era TBNf.Last + TBNfCODIGO.AsInteger + 1 (o BDE navegava a tabela inteira).
  tb_nf.CODIGO e varchar(6) puramente numerico com zeros a esquerda
  ('000001'..'027660'), entao o CAST direto e seguro - diferente de tb_os,
  cuja chave e 'NNNNNN/AA' (secao 6.1 do HANDOFF).
  RetZero preserva os 6 digitos: inttostr sozinho devolveria '27661'. }
var Prox: Integer;
begin
  Result := '000001';
  if not GarantirConexao then Exit;
  QNf.Close;
  QNf.SQL.Text := 'SELECT COALESCE(MAX(CAST(CODIGO AS UNSIGNED)), 0) AS ULTIMO FROM tb_nf';
  QNf.Open;
  try
    Prox := QNf.FieldByName('ULTIMO').AsInteger + 1;
    Result := Modulo.RetZero(inttostr(Prox), 6);
  finally
    QNf.Close;
  end;
end;

function TFNf.ReservarCodigoNf(var Codigo: string): Boolean;
{ Pre-reserva de codigo (secao 4.4 do HANDOFF). O Append+Post imediato do BDE
  nao era sujeira: garantia que dois operadores nao emitissem a mesma NF.
  Aqui o INSERT grava so a PK; se outro posto tiver pego o numero no intervalo,
  o MySQL devolve 1062 (Duplicate entry), pegamos o proximo e AVISAMOS. }
var Tentativas: Integer;
    Original: string;
begin
  Result := False;
  if not GarantirConexao then Exit;
  Original   := Codigo;
  Tentativas := 0;

  while Tentativas < 20 do
  begin
    QNfCmd.Close;
    QNfCmd.SQL.Text := 'INSERT INTO tb_nf (CODIGO) VALUES (:pCod)';
    QNfCmd.ParamByName('pCod').AsString := Codigo;
    try
      QNfCmd.ExecSQL;
      FCodigoReservado := Codigo;
      Result := True;
      if Codigo <> Original then
        Application.MessageBox(PChar(
          'O numero ' + Original + ' foi usado por outro posto enquanto voce digitava.' + #13#10 +
          'Esta nota passou a ser a de numero ' + Codigo + '.'),
          'AVISO', MB_OK + MB_IconInformation);
      Exit;
    except
      on E: Exception do
      begin
        if Pos('1062', E.Message) + Pos('Duplicate', E.Message) = 0 then raise;
        Codigo := ProximoCodigoNf;   { colisao: tenta o proximo }
        Inc(Tentativas);
      end;
    end;
  end;

  Application.MessageBox('Nao foi possivel reservar um numero de NF.',
    'ERRO', MB_OK + MB_IconError);
end;

procedure TFNf.LiberarCodigoReservado;
{ Apaga o stub se a nota foi abandonada sem preencher. A guarda impede apagar
  nota real: so remove enquanto o registro estiver vazio.
  As FK de tb_nf_itens e tb_nf_ref sao ON DELETE CASCADE, entao nao ha o que
  limpar antes. }
begin
  if FCodigoReservado = '' then Exit;
  if not GarantirConexao then
  begin
    FCodigoReservado := '';
    Exit;
  end;
  try
    QNfCmd.Close;
    QNfCmd.SQL.Text :=
      'DELETE FROM tb_nf WHERE CODIGO = :pCod ' +
      'AND COD_CLI IS NULL AND NATUREZA IS NULL AND VALOR IS NULL';
    QNfCmd.ParamByName('pCod').AsString := FCodigoReservado;
    QNfCmd.ExecSQL;
  except
    { nota ja preenchida ou em uso: nao e erro, so nao apaga }
  end;
  FCodigoReservado := '';
end;

procedure TFNf.AtualizarFlagNf(const CodNf, Flag: string);
{ Substitui o par TBNf.FindKey + Edit + TBNFFLG_ENVIADA + Post, repetido em
  varios pontos do envio, do cancelamento e da recuperacao. }
begin
  if not GarantirConexao then Exit;
  QNfCmd.Close;
  QNfCmd.SQL.Text := 'UPDATE tb_nf SET FLG_ENVIADA = :pFlag WHERE CODIGO = :pCod';
  QNfCmd.ParamByName('pFlag').AsString := Flag;
  QNfCmd.ParamByName('pCod').AsString  := CodNf;
  QNfCmd.ExecSQL;
end;

procedure TFNf.AtualizarNfEnviada(const CodNf, ChaveNfe, PathNfe: string);
{ Grava o retorno da SEFAZ: chave de acesso, caminho do XML e FLG_ENVIADA='S'. }
begin
  if not GarantirConexao then Exit;
  QNfCmd.Close;
  QNfCmd.SQL.Text :=
    'UPDATE tb_nf SET COD_NFE = :pChave, PATH_NFE = :pPath, ' +
    'FLG_ENVIADA = ''S'' WHERE CODIGO = :pCod';
  QNfCmd.ParamByName('pChave').AsString := ChaveNfe;
  QNfCmd.ParamByName('pPath').AsString  := PathNfe;
  QNfCmd.ParamByName('pCod').AsString   := CodNf;
  QNfCmd.ExecSQL;
end;

function TFNf.LerCampoNf(const CodNf, Campo: string): string;
{ Le uma coluna da NF sem deixar dataset aberto. Substitui os pontos em que o
  codigo lia TBNfPATH_NFE / TBNfCOD_NFE do cursor BDE posicionado. }
begin
  Result := '';
  if not GarantirConexao then Exit;
  QNf.Close;
  QNf.SQL.Text := 'SELECT ' + Campo + ' AS V FROM tb_nf WHERE CODIGO = :pCod';
  QNf.ParamByName('pCod').AsString := CodNf;
  try
    QNf.Open;
    if not QNf.IsEmpty then Result := QNf.FieldByName('V').AsString;
  finally
    QNf.Close;
  end;
end;

function TFNf.CarregarCliente(const CodCliente: string): Boolean;
{ Substitui Modulo.TBClientes.FindKey([...]) + GotoKey. Deixa QCli aberto no
  registro para que os campos sejam lidos por FieldByName logo em seguida. }
begin
  Result := False;
  if not GarantirConexao then Exit;
  QCli.Close;
  QCli.SQL.Text :=
    'SELECT CODIGO, RAZAO, FANTASIA, CNPJ, ENDERECO, NUMERO, BAIRRO, CIDADE, ' +
    'ESTADO, CEP, INSC_EST, TEL1, TEL2, EMAIL, COD_MUNICIPIO, LT_MINIMO ' +
    'FROM tb_clientes WHERE CODIGO = :pCod';
  QCli.ParamByName('pCod').AsString := CodCliente;
  QCli.Open;
  Result := not QCli.IsEmpty;
end;

procedure TFNf.CarregarNf(const CodNf: string);
{ Substitui Modulo.TBNf.FindKey([...]) + GotoKey. Deixa QNf posicionado. }
begin
  if not GarantirConexao then Exit;
  QNf.Close;
  QNf.SQL.Text := 'SELECT * FROM tb_nf WHERE CODIGO = :pCod';
  QNf.ParamByName('pCod').AsString := CodNf;
  QNf.Open;
end;

procedure TFNf.CarregarClientesCombo;
{ EFantasia era TRxLookupEdit sobre Modulo.DSClientes (cursor BDE). O
  TRxLookupEdit faz cast interno para estruturas do BDE e da Access Violation
  com dataset ZeosLib, por isso virou TComboBox + TStringList paralela
  (secao 4.3 do HANDOFF). }
var Q: TZQuery;
begin
  if FClientesCod = nil then FClientesCod := TStringList.Create;
  FClientesCod.Clear;
  EFantasia.Items.Clear;
  if not GarantirConexao then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;
    Q.SQL.Text := 'SELECT CODIGO, FANTASIA FROM tb_clientes ' +
                  'WHERE FANTASIA IS NOT NULL ORDER BY FANTASIA';
    Q.Open;
    while not Q.Eof do
    begin
      EFantasia.Items.Add(Q.FieldByName('FANTASIA').AsString);
      FClientesCod.Add(Q.FieldByName('CODIGO').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

Function TFNf.MenorDataValida(Ano, Mes, Dia: Word): TDateTime;
Var
  Continua: Boolean;
  DataAux: TDateTime;
begin
  Continua := true;
  DataAux := date;
  while Continua do
    Try
      DataAux := EncodeDate(Ano, Mes, Dia);
      Continua := False;
    Except
      Dec(Dia);
    End;
  MenorDataValida := DataAux;
end;

Function TFNf.SomaMes(dData: TDateTime; xMeses: Integer;
  lCorrido: Boolean): TDateTime;
var
  Ano, Mes, Dia: Word;
  DataAux: TDateTime;
begin
  DecodeDate(dData, Ano, Mes, Dia);
  Mes := Mes + xMeses;
  if (Mes DIV 13) = 1 then
  begin
    Mes := 1;
    Ano := Ano + 1;
  end
  else
  begin
    Ano := Ano + (Mes DIV 13);
    Mes := Mes mod 13;
  end;
  DataAux := MenorDataValida(Ano, Mes, Dia);
  if not lCorrido Then
    DataAux := DataAux - 1;
  SomaMes := DataAux;
end;

Function TFNf.ProximoDiaUtil(dData: TDateTime): TDateTime;
begin
  if DayOfWeek(dData) = 7 then
    dData := dData + 2
  else if DayOfWeek(dData) = 1 then
    dData := dData + 1;
  ProximoDiaUtil := dData;
end;

procedure TFNf.FormRefresh(Sender: TObject);
{ Era TBNf.Refresh (recarregava o cursor BDE). No MySQL o equivalente e encerrar
  a transacao de leitura, para a proxima consulta enxergar dados novos: o InnoDB
  roda em REPEATABLE READ e o snapshot fica congelado (armadilha #1). }
begin
  if GarantirConexao then
    Modulo.NovaLeitura;
end;

procedure TFNf.FormDestroy(Sender: TObject);
{ FClientesCod acompanha o EFantasia (ex-TRxLookupEdit) e e criada no
  CarregarClientesCombo; liberada aqui para nao vazar. }
begin
  FreeAndNil(FClientesCod);
end;

procedure TFNf.Desabilitar;
var
  i: Integer;
begin

  for i := 0 to FNf.ComponentCount - 1 do
  begin
    if (FNf.Components[i] is TCustomEdit) and
      (FNf.Components[i].Name <> 'ECodigo') then
    begin (FNf.Components[i] as TCustomEdit)
      .enabled := False; (FNf.Components[i] as TCustomEdit)
      .Brush.Color := $00EAEAEA;
    end;

    if (FNf.Components[i] is TIAeverButton) and
      (FNf.Components[i].Name <> 'BTOK2') and
      (FNf.Components[i].Name <> 'BTSair') then
  (FNf.Components[i] as TIAeverButton)
      .enabled := False;
  end;

  Clink.Visible := False;
  CChNfe.Visible := False;
  EChNfe.Visible := False;
  opVista.Checked := true;

  OpS.Checked := true;
  OpNormal.Checked := true;
  OpTot.Checked := true;



end;

procedure TFNf.Habilitar;
var
  i: Integer;
begin

  for i := 0 to FNf.ComponentCount - 1 do
  begin
    if (FNf.Components[i] is TCustomEdit) and
      (FNf.Components[i].Name <> 'ECodigo') then
    begin (FNf.Components[i] as TCustomEdit)
      .enabled := true; (FNf.Components[i] as TCustomEdit)
      .Brush.Color := clWhite;
    end;

    if (FNf.Components[i] is TIAeverButton) and
      (FNf.Components[i].Name <> 'BTOK2') and
      (FNf.Components[i].Name <> 'BTSair') then
  (FNf.Components[i] as TIAeverButton)
      .enabled := true;
  end;


end;

procedure TFNf.Limpar;
var
  i: Integer;
begin

  ENatureza.Clear;
  ECFOP.Clear;
  EDataE.Clear;
  EDuplicata.Clear;
  EDataS.Clear;
  OpEnt.Checked := true;
  ENF.Clear;
  EDataNF.Clear;
  EValorNF.Clear;
  OpTot.Checked := true;
  EOs.Clear;
  ECliente.Clear;
  EFantasia.Clear;
  ENome.Clear;
  OpE.Checked := true;
  OpS.Checked := true;
  Opt30.enabled := False;
  Opt45.enabled := False;
  Opt60.enabled := False;
  OpTot.Checked := true;
  EQtd.Text := '';
  EEsp.Text := '';
  ECred.value := 0;
  EPesoL.Value := 0;
  EPesoB.Value := 0;
  ETotal.Value := 0;
  Eicms.Value := 0;
  lbNaoEnviada.Caption := '';
  ECFOP.Text := '5124';
  ECFOPRetorno.Text := '5902';
  ECST.Text := '101';
  ECSTRetorno.Text := '101';
  EPlaca.Text := '';
  Eestado.Text := 'SP';

  EInfAdic.Text :=
    'ICMS suspenso conforme Art. 402  §1°  inciso II do RICMS decreto 45490/2000,IPI suspenso conforme artigo 42 inciso VII do RIPI' + ' decreto 02637/1998. Empresa optante pelo Simples Nacional, Lei Complementar 2006. Este doc. não transfere crédito de impostos IPI/ISS.';

  for i := 1 to Grid.RowCount - 1 do
    Grid.Rows[i].Clear;

  Grid.RemoveRows(1, Grid.RowCount - 1);

  for i := 1 to GridNF.RowCount - 1 do
    GridNF.Rows[i].Clear;

  GridNF.RemoveRows(1, GridNF.RowCount - 1);

  item := 1;
  qtd := 0;

end;

procedure TFNf.BTSairClick(Sender: TObject);
begin
  close;
end;

procedure TFNf.gravaOs;
var
  Ano, Mes, Dia: Word;
begin

  begin
    if not GarantirConexao then Exit;
    Modulo.NovaLeitura;   { snapshot atual: a OS pode ter sido finalizada agora (#1) }

    { Literais entre aspas duplas (sintaxe Paradox) viraram parametros e as
      tabelas ganharam o prefixo tb_ (armadilha #14). }
    QOS_Fin.close;
    QOS_Fin.SQL.Clear;
    QOS_Fin.SQL.Text := 'SELECT * FROM tb_os_finalizados WHERE CODIGO = :pCod';
    QOS_Fin.ParamByName('pCod').AsString := EOs.Text;
    QOS_Fin.Open;
    If QOS_Fin.IsEmpty then
    begin
      Application.MessageBox('OS não encontrada ou não finalizada!',
        'Erro de pesquisa', MB_Ok + MB_IconError);
      { TBOs.FindKey/GotoKey -> existe a OS (ainda que nao finalizada)? }
      QOs.close;
      QOs.SQL.Clear;
      QOs.SQL.Text := 'SELECT CODIGO FROM tb_os WHERE CODIGO = :pCod';
      QOs.ParamByName('pCod').AsString := EOs.Text;
      QOs.Open;
      If not QOs.IsEmpty then
      begin
        if Application.MessageBox('Deseja finalizar esta OS ?', 'Finalizar OS',
          MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) = IdYes then
        begin
          FOS.varNF := true;
          FOS.ShowModal;
          ativar := False;
          EOs.SetFocus;
          BTOK.click;
          exit;
        end;
      end;
      EOs.SetFocus;
      exit;
    end;

    QOs.close;
    QOs.SQL.Clear;
    QOs.SQL.Text := 'SELECT * FROM tb_os WHERE CODIGO = :pCod';
    QOs.ParamByName('pCod').AsString := EOs.Text;
    QOs.Open;
    Codigo := QOs.FieldByName('CLIENTE').AsString;
    QPecas.close;
    QPecas.SQL.Clear;
    QPecas.SQL.Text :=
      'SELECT * FROM tb_pecas WHERE COD_CLI = :pCli AND CODIGO = :pPeca';
    QPecas.ParamByName('pCli').AsString  := QOs.FieldByName('CLIENTE').AsString;
    QPecas.ParamByName('pPeca').AsString := QOs.FieldByName('PECA').AsString;
    QPecas.Open;

    If QOs.FieldByName('CLIENTE').AsString <> ECliente.Text then
      If Application.MessageBox(
        'Atenção: A OS selecionada possui o cliente diferente da NFe! Deseja realmente adicionar a OS?', 'AVISO', MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) = IDNo then
      begin
        ECliente.SetFocus;
        exit;
      end;

        DecodeDate(Date, Ano, Mes, Dia);

    QNCM.close;
    QNCM.SQL.Clear;
    QNCM.SQL.Text :=  ' select i.codigo, i.ncm ncm, i.preco_unitario precoUni, o.data from tb_nf_itens i, tb_os o '+
                      ' where  i.cod_os = o.codigo                                                 '+
                      ' and o.peca = :pPeca                                                     '+
                      ' and o.cliente = :pCodigo                                                  '+
                      ' and extract(YEAR from o.data) >= :pAno order by o.data desc' ;

    QNCM.ParamByName('pPeca').AsString := QPecas.FieldByName('CODIGO').AsString;
    QNCM.ParamByName('pCodigo').AsString := QOs.FieldByName('CLIENTE').AsString;
    QNCM.ParamByName('pAno').AsInteger := Ano -1;

    QNCM.Prepare;
    QNCM.Open;


    Grid.AddRow;
    Grid.Cells[0, item] := QPecas.FieldByName('CODIGO').AsString;
    { LT_MINIMO e decimal(10,3) e VALOR e decimal(15,4): AsCurrency nos dois
      lados compara em Currency, como faziam os TCurrencyField do BDE. }
    if QOS_Fin.FieldByName('VALOR').AsCurrency <= QCli.FieldByName('LT_MINIMO').AsCurrency then
      Grid.Cells[1, item] := QPecas.FieldByName('DESCRICAO').AsString + ' OS:' +
        QOs.FieldByName('CODIGO').AsString + ' - LOTE:' + QOs.FieldByName('LOTE').AsString +
        ' - TX LT Min'
    else

    Grid.Cells[1, item] := QPecas.FieldByName('DESCRICAO').AsString + ' OS:' +
    QOs.FieldByName('CODIGO').AsString + ' - LOTE:' + QOs.FieldByName('LOTE').AsString;
    Grid.Cells[2, item] :=  QNCM.FieldByName('ncm').AsString;
    Grid.Cells[3, item] :=  '';
    Grid.Cells[4, item] := ECFOP.Text;
    Grid.Cells[5, item] := ECST.Text;
    Grid.Cells[6, item] := FormatFloat('#######0.000', QOs.FieldByName('PESO').AsFloat);
    Grid.Cells[7, item] := 'Kg';
    { preco unitario = valor / peso. VALOR era TCurrencyField e PESO TFloatField,
      entao a divisao era Currency/Double: AsCurrency e AsFloat preservam isso. }
    Grid.Cells[8, item] := FormatFloat('#######0.000000000',
    QOS_Fin.FieldByName('VALOR').AsCurrency / QOs.FieldByName('PESO').AsFloat);
    Grid.Cells[9, item] := FormatFloat('#######0.00', QOS_Fin.FieldByName('VALOR').AsCurrency);
    Grid.Cells[10, item] := EOs.Text;
    item := item + 1;

    Grid.AddRow;
    Grid.Cells[0, item] := QNCM.FieldByName('codigo').AsString;
    Grid.Cells[1, item] := QPecas.FieldByName('DESCRICAO').AsString + ' - Ref. NF:' +
    QOs.FieldByName('NOTA').AsString;

    Grid.Cells[2, item] :=  QNCM.FieldByName('ncm').AsString;
    Grid.Cells[3, item] :=  '';
    Grid.Cells[4, item] := ECFOPRetorno.Text;
    Grid.Cells[5, item] := ECSTRetorno.Text;
    Grid.Cells[6, item] := FormatFloat('#######0.000', QOs.FieldByName('PESO').AsFloat);

    if EFantasia.Text = 'FABRIL' then
      Grid.Cells[7, item] := 'Kg'
    else
      Grid.Cells[7, item] := 'Kg';

    { precoUni vem de i.preco_unitario (double) e PESO tambem e double:
      AsFloat nos dois, como eram os TFloatField do BDE. }
    Grid.Cells[8, item] := FormatFloat('#######0.00', QNCM.FieldByName('precoUni').AsFloat);
    Grid.Cells[9, item] := FormatFloat('#######0.00',
      QNCM.FieldByName('precoUni').AsFloat * QOs.FieldByName('PESO').AsFloat);
    Grid.Cells[10, item] := EOs.Text;


    item := item + 1;

    EPesoL.Value := EPesoL.Value + QOs.FieldByName('PESO').AsFloat;
    ETotal.Value := ETotal.Value + QOS_Fin.FieldByName('VALOR').AsCurrency +
      (QNCM.FieldByName('precoUni').AsFloat * QOs.FieldByName('PESO').AsFloat);
    ETotalBenef.Value := ETotalBenef.Value + QOS_Fin.FieldByName('VALOR').AsCurrency;

    end;


end;

procedure TFNf.BTOKClick(Sender: TObject);
begin
  gravaOs;
  If Application.MessageBox
    ('Adicionar mais itens à nota fiscal? <Máximo de 15>', 'AVISO', MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) = IdYes then
  begin
    EOs.Clear;
    EOs.SetFocus;
  end
  else
    ENome.SetFocus;
end;

procedure TFNf.FormActivate(Sender: TObject);
begin
  if ativar = true then
  begin
    Limpar;
    // Application.OnActivate := FormRefresh;
    { TBNf.Last + TBNfCODIGO.AsInteger + 1 -> ProximoCodigoNf (SELECT MAX).
      tb_nf tem 27 mil linhas: navegar a tabela como o BDE fazia nao e viavel
      (secao 6.2 do HANDOFF). NovaLeitura garante snapshot atual (#1). }
    if GarantirConexao then
    begin
      Modulo.NovaLeitura;
      ECodigo.Text := ProximoCodigoNf;
      ECodigo.SetFocus;
    end;
    Desabilitar;

  Opt30.checked := False;
  Opt45.checked := False;
  Opt60.checked := False;
  Opt30.Enabled := False;
  Opt45.Enabled := False;
  Opt60.Enabled := False;


  end;
  ativar := true;
end;

procedure TFNf.BTLimparClick(Sender: TObject);
begin
  Limpar;
end;

procedure TFNf.ENaturezaEnter(Sender: TObject);
begin
  ENatureza.Color := $00E2F5FE;
  ENatureza.Font.Color := clNavy;
  ENatureza.Font.style := [fsBold];

end;

procedure TFNf.ECFOPEnter(Sender: TObject);
begin
  ECFOP.Color := $00E2F5FE;
  ECFOP.Font.Color := clNavy;
  ECFOP.Font.style := [fsBold];

end;

procedure TFNf.EDataEEnter(Sender: TObject);
begin
  EDataE.Color := $00E2F5FE;
  EDataE.Font.Color := clNavy;
  EDataE.Font.style := [fsBold];

end;

procedure TFNf.EDuplicataEnter(Sender: TObject);
begin
  EDataS.Color := $00E2F5FE;
  EDataS.Font.Color := clNavy;
  EDataS.Font.style := [fsBold];
end;

procedure TFNf.ENFEnter(Sender: TObject);
begin
  ENF.Color := $00E2F5FE;
  ENF.Font.Color := clNavy;
  ENF.Font.style := [fsBold];
end;

procedure TFNf.EDataNFEnter(Sender: TObject);
begin
  EDataNF.Color := $00E2F5FE;
  EDataNF.Font.Color := clNavy;
  EDataNF.Font.style := [fsBold];
end;

procedure TFNf.EValorNFEnter(Sender: TObject);
begin
  EValorNF.Color := $00E2F5FE;
  EValorNF.Font.Color := clNavy;
  EValorNF.Font.style := [fsBold];
end;

procedure TFNf.EOsEnter(Sender: TObject);
begin
  EOs.Color := $00E2F5FE;
  EOs.Font.Color := clNavy;
  EOs.Font.style := [fsBold];
end;

procedure TFNf.ENomeEnter(Sender: TObject);
begin
  ENome.Color := $00E2F5FE;
  ENome.Font.Color := clNavy;
  ENome.Font.style := [fsBold];
end;

procedure TFNf.ENaturezaExit(Sender: TObject);
begin
  ENatureza.Color := clWhite;
  ENatureza.Font.Color := clBlack;
  ENatureza.Font.style := [];

end;

procedure TFNf.ECFOPExit(Sender: TObject);
begin
  ECFOP.Color := clWhite;
  ECFOP.Font.Color := clBlack;
  ECFOP.Font.style := [];

end;

procedure TFNf.EDataEExit(Sender: TObject);
begin
  EDataE.Color := clWhite;
  EDataE.Font.Color := clBlack;
  EDataE.Font.style := [];

  EDuplicata.date := ProximoDiaUtil(SomaMes(EDataE.date, 1, true));

end;

procedure TFNf.EDuplicataS(Sender: TObject);
begin
  EDataS.Color := clWhite;
  EDataS.Font.Color := clBlack;
  EDataS.Font.style := [];

end;

procedure TFNf.ENFExit(Sender: TObject);
begin
  ENF.Color := clWhite;
  ENF.Font.Color := clBlack;
  ENF.Font.style := [];
end;

procedure TFNf.EDataNFExit(Sender: TObject);
begin
  EDataNF.Color := clWhite;
  EDataNF.Font.Color := clBlack;
  EDataNF.Font.style := [];

end;

procedure TFNf.EValorNFExit(Sender: TObject);
begin
  EValorNF.Color := clWhite;
  EValorNF.Font.Color := clBlack;
  EValorNF.Font.style := [];

end;

procedure TFNf.EOsExit(Sender: TObject);
begin
  EOs.Color := clWhite;
  EOs.Font.Color := clBlack;
  EOs.Font.style := [];

end;

procedure TFNf.ENomeExit(Sender: TObject);
begin
  ENome.Color := clWhite;
  ENome.Font.Color := clBlack;
  ENome.Font.style := [];

end;

procedure TFNf.BTImprimirClick(Sender: TObject);
begin

  with Modulo do
  begin

    If (tipo = 'alterar') then
    begin
      ACBrNFe1.NotasFiscais.Clear;
      ACBrNFe1.NotasFiscais.LoadFromFile(LerCampoNf(ECodigo.Text, 'PATH_NFE'));
      ACBrNFe1.NotasFiscais.Imprimir;
    end;
  end;
end;

procedure TFNf.BTImprimirEnter(Sender: TObject);
begin
  BTImprimir.ButtonColor := $00E2F5FE;
  BTImprimir.ButtonColor1 := clGray;
end;

procedure TFNf.BTImprimirExit(Sender: TObject);
begin
  BTImprimir.ButtonColor := $00CACACA;
  BTImprimir.ButtonColor1 := $00CACACA;
end;

procedure TFNf.BTLimparEnter(Sender: TObject);
begin
  BTLimpar.ButtonColor := $00E2F5FE;
  BTLimpar.ButtonColor1 := clGray;
end;

procedure TFNf.BTLimparExit(Sender: TObject);
begin
  BTLimpar.ButtonColor := $00CACACA;
  BTLimpar.ButtonColor1 := $00CACACA;
end;

procedure TFNf.BTSairEnter(Sender: TObject);
begin
  BTSair.ButtonColor := $00E2F5FE;
  BTSair.ButtonColor1 := clGray;
end;

procedure TFNf.BTSairExit(Sender: TObject);
begin
  BTSair.ButtonColor := $00CACACA;
  BTSair.ButtonColor1 := $00CACACA;
end;

procedure TFNf.BTGravarEnter(Sender: TObject);
begin
  BTGravar.ButtonColor := $00E2F5FE;
  BTGravar.ButtonColor1 := clGray;
end;

procedure TFNf.BTGravarExit(Sender: TObject);
begin
  BTGravar.ButtonColor := $00CACACA;
  BTGravar.ButtonColor1 := $00CACACA;
end;

procedure TFNf.EClienteChange(Sender: TObject);
{ TBClientes.FindKey/GotoKey -> CarregarCliente (SELECT ... WHERE CODIGO).
  O TBPecas.Filter := '' era inerte (Filtered continuava False) e foi removido
  junto com o TTable BDE. }
begin
  if CarregarCliente(Modulo.RetZero(ECliente.Text, 4)) then
  begin
    EFantasia.Text := QCli.FieldByName('FANTASIA').AsString;

    if QCli.FieldByName('ESTADO').AsString <> 'SP' then
    begin
      ECFOP.Text := '6124';
      ECFOPRetorno.Text := '6902';
    end
    else
    begin
      ECFOP.Text := '5124';
      ECFOPRetorno.Text := '5902';
    end;
  end
  else
    EFantasia.Text := '';
end;

procedure TFNf.EClienteEnter(Sender: TObject);
begin
  ECliente.Color := $00E2F5FE;
  ECliente.Font.Color := clNavy;
  ECliente.Font.style := [fsBold];

end;

procedure TFNf.EClienteExit(Sender: TObject);
begin
  ECliente.Color := clWhite;
  ECliente.Font.Color := clBlack;
  ECliente.Font.style := [];
  If ECliente.Text <> '' then
    ECliente.Text := Modulo.RetZero(ECliente.Text, 4);

end;

procedure TFNf.EClienteKeyPress(Sender: TObject; var Key: Char);
begin
  with Modulo do
    Key := number(Key);
end;

procedure TFNf.EFantasiaChange(Sender: TObject);
{ Substitui OnCloseUp + OnKeyUp do antigo TRxLookupEdit: os dois liam o cursor
  BDE (Modulo.TBClientesCODIGO) apos o lookup mover o registro. Com TComboBox a
  posicao vem do ItemIndex e o codigo sai da lista paralela (secao 4.3). }
begin
  if (EFantasia.ItemIndex >= 0) and (FClientesCod <> nil) and
     (EFantasia.ItemIndex < FClientesCod.Count) then
    ECliente.Text := FClientesCod[EFantasia.ItemIndex];
end;

procedure TFNf.EFantasiaEnter(Sender: TObject);
begin
  EFantasia.Color := $00E2F5FE;
  EFantasia.Font.Color := clNavy;
  EFantasia.Font.style := [fsBold];

end;

procedure TFNf.EFantasiaExit(Sender: TObject);
begin
  EFantasia.Color := clWhite;
  EFantasia.Font.Color := clBlack;
  EFantasia.Font.style := [];

end;

{ EFantasiaKeyUp removido: era a outra metade do lookup BDE e foi absorvido
  pelo EFantasiaChange acima. }

procedure TFNf.ECodigoKeyPress(Sender: TObject; var Key: Char);
begin
  with Modulo do
    Key := number(Key);

end;

procedure TFNf.ECodigoEnter(Sender: TObject);
begin
  ECodigo.Color := $00E2F5FE;
  ECodigo.Font.Color := clNavy;
  ECodigo.Font.style := [fsBold];

end;

procedure TFNf.ECodigoExit(Sender: TObject);
begin
  ECodigo.Color := clWhite;
  ECodigo.Font.Color := clBlack;
  If ECodigo.Text <> '' then
    ECodigo.Text := Modulo.RetZero(ECodigo.Text, 6);

end;

procedure TFNf.BTOK2Click(Sender: TObject);
var
  idx: Integer;
  codNfAux: string;
begin
  codNfAux := ECodigo.Text;
  begin
    if not GarantirConexao then Exit;
    Modulo.NovaLeitura;   { snapshot atual antes de decidir gravar x alterar (#1) }

    If ECodigo.Text = '' then
    begin
      ECodigo.SetFocus;
      exit;
    end;

    Habilitar;
    Limpar;
    ENatureza.SetFocus;
    ENatureza.Color := $00E2F5FE;

    { TBNf.FindKey/GotoKey -> SELECT ... WHERE CODIGO }
    CarregarNf(ECodigo.Text);
    If QNf.IsEmpty then
      tipo := 'gravar'
    else
      tipo := 'alterar';

    If (tipo = 'gravar') then
    begin
      { Pre-reserva: era Append + CODIGO + Post (INSERT so com a PK), para dois
        operadores nao emitirem a mesma NF. ReservarCodigoNf faz o mesmo e
        ainda trata a colisao 1062 avisando o usuario (secao 4.4). }
      if not ReservarCodigoNf(codNfAux) then Exit;
      ECodigo.Text := codNfAux;      { pode ter mudado por colisao }
      ENatureza.Text := 'RETORNO DE INDUSTRIALIZAÇÃO';
      ECFOP.Text := '5124';
      EDataE.date := now;
      EDuplicata.date := ProximoDiaUtil(SomaMes(EDataE.date, 1, true));
      ENome.Text := 'O PRÓPRIO';
      OpD.Checked := true;
      OpS.Checked := true;
      OpTot.Checked := true;
      opPrazo.Checked := true;

      Opt30.Enabled := true;
      Opt45.Enabled := true;
      Opt60.Enabled := true;

      Clink.Visible := False;
      CChNfe.Visible := False;
      EChNfe.Visible := False;
      BTImprimir.enabled := False;
      BTEnviar.enabled := False;
      BTRecuperar.enabled := False;
      BTCancelar.enabled := False;

    end;

    If (tipo = 'alterar') then
    begin
      { QNf ja esta aberto e posicionado pelo CarregarNf acima.
        Campos char(1) (TIPO, TIPO_RETORNO, ...) sao lidos com AsString: no BDE
        usava-se .Text, que para TStringField devolve o mesmo conteudo.
        DATAE/DATAS sao 'date' no MySQL -> AsDateTime nao traz hora. }
      ECliente.Text := QNf.FieldByName('COD_CLI').AsString;
      EDataE.date := QNf.FieldByName('DATAE').AsDateTime;
      EDuplicata.date := ProximoDiaUtil(EDataE.date + 30);
      // ETotal.Value := QNf.FieldByName('VALOR').AsCurrency;
      ENatureza.Text := QNf.FieldByName('NATUREZA').AsString;
      ECFOP.Text := QNf.FieldByName('CFOP').AsString;
      EDataS.date := QNf.FieldByName('DATAS').AsDateTime;
      if QNf.FieldByName('TIPO').AsString = 'S' then
        OpS.Checked := true
      else
        OpEnt.Checked := true;
      if QNf.FieldByName('TIPO_RETORNO').AsString = 'T' then
        OpTot.Checked := true
      else
        OpPar.Checked := true;

      if QNf.FieldByName('TIPO_PAGAMENTO').AsString = 'V' then
        opVista.Checked := true
      else
        opPrazo.Checked := true;

      if QNf.FieldByName('TIPO_EMISSAO').AsString = 'N' then
        OpNormal.Checked := true
      else
       OpDevolucao.Checked := true;

      if QNf.FieldByName('TIPO_30').AsString = 'S' then Opt30.Checked := true else Opt30.Checked := false;
      if QNf.FieldByName('TIPO_45').AsString = 'S' then Opt45.Checked := true else Opt45.Checked := false;
      if QNf.FieldByName('TIPO_60').AsString = 'S' then Opt60.Checked := true else Opt60.Checked := false;

      Eicms.Value := QNf.FieldByName('ICMS_BASE').AsCurrency;
      ENome.Text := QNf.FieldByName('NOME_TRANSPORTADORA').AsString;
      EQtd.Text := QNf.FieldByName('QUANTIDADE').AsString;
      EEsp.Text := QNf.FieldByName('ESPECIE').AsString;
      EPesoL.Value := QNf.FieldByName('PESOL').AsFloat;
      EPesoB.Value := QNf.FieldByName('PESOB').AsFloat;
      Clink.Visible := true;
      CChNfe.Visible := true;
      EChNfe.Visible := true;
      EChNfe.Text := QNf.FieldByName('COD_NFE').AsString;
      Eestado.Text := QNf.FieldByName('UF_PLACA').AsString;
      EPlaca.Text := QNf.FieldByName('PLACA').AsString;

      if QNf.FieldByName('TIPO_FRETE').AsString = 'E' then
        OpE.Checked := true
      else
        OpD.Checked := true;

      if QNf.FieldByName('FLG_ENVIADA').AsString = 'S' then
      begin
        lbNaoEnviada.Caption := 'Status: NFe enviada com sucesso!';
        lbNaoEnviada.Font.Color := clNavy;
        lbNaoEnviada.Visible := true;
        BTImprimir.enabled := true;
        BTEnviar.enabled := False;
        BTRecuperar.enabled := False;
        BTCancelar.enabled := true;
        BTGravar.enabled := False;
        BTLimpar.enabled := False;
      end;

      if QNf.FieldByName('FLG_ENVIADA').AsString = 'N' then
      begin
        lbNaoEnviada.Caption := 'Status: NFe não enviada!';
        lbNaoEnviada.Font.Color := clRed;
        lbNaoEnviada.Visible := true;
        BTImprimir.enabled := False;
        BTEnviar.enabled := true;
        BTRecuperar.enabled := true;
        BTCancelar.enabled := False;
      end;

      if QNf.FieldByName('FLG_ENVIADA').AsString = 'C' then
      begin
        lbNaoEnviada.Caption := 'Status: NFe CANCELADA!';
        lbNaoEnviada.Font.Color := clRed;
        lbNaoEnviada.Visible := true;
        BTImprimir.enabled := False;
        BTEnviar.enabled := False;
        BTRecuperar.enabled := true;
        BTCancelar.enabled := False;
        BTGravar.enabled := False;
        BTLimpar.enabled := False;
      end;

      { 'NF_ref' -> tb_nf_ref; o literal entre aspas duplas (sintaxe Paradox)
        virou parametro (armadilha #14). ORDER BY ID mantem a ordem de insercao,
        que no Paradox vinha da ordem fisica do arquivo. }
      QNF_Ref.close;
      QNF_Ref.SQL.Clear;
      QNF_Ref.SQL.Text := 'SELECT * FROM tb_nf_ref WHERE COD_NF = :pCod ORDER BY ID';
      QNF_Ref.ParamByName('pCod').AsString := ECodigo.Text;
      QNF_Ref.Open;

      idx := 1;

      If not QNF_Ref.Eof then
        repeat
          GridNF.AddRow;
          if QNF_Ref.FieldByName('FLAG_NFE').AsString = 'S' then
            GridNF.Cells[0, idx] := 'Sim'
          else
            GridNF.Cells[0, idx] := 'Não';

          GridNF.Cells[1, idx] := QNF_Ref.FieldByName('COD_NF_CLIENTE').AsString;
          GridNF.Cells[2, idx] := QNF_Ref.FieldByName('DATA_NF_CLIENTE').AsString;
          { VALOR_NF_CLIENTE era TCurrencyField, cujo .AsString e FloatToStr do
            valor. Reproduzido literalmente para a celula manter o mesmo texto
            (o BTGravar le esta celula de volta com StrToCurr). }
          GridNF.Cells[3, idx] := FloatToStr(QNF_Ref.FieldByName('VALOR_NF_CLIENTE').AsFloat);
          idx := idx + 1;

          QNF_Ref.Next
        until QNF_Ref.Eof;

      QNF_Itens.close;
      QNF_Itens.SQL.Clear;
      QNF_Itens.SQL.Text := 'SELECT * FROM tb_nf_itens WHERE COD_NF = :pCod ORDER BY ID';
      QNF_Itens.ParamByName('pCod').AsString := ECodigo.Text;
      QNF_Itens.Open;

      item := 1;
      If not QNF_Itens.Eof then
        repeat
          Grid.AddRow;
          Grid.Cells[0, item] := QNF_Itens.FieldByName('CODIGO').AsString;
          Grid.Cells[1, item] := QNF_Itens.FieldByName('DESCRICAO').AsString;
          Grid.Cells[2, item] := QNF_Itens.FieldByName('NCM').AsString;
          Grid.Cells[3, item] := QNF_Itens.FieldByName('CEST').AsString;
          Grid.Cells[4, item] := QNF_Itens.FieldByName('CFOP').AsString;
          Grid.Cells[5, item] := QNF_Itens.FieldByName('CST').AsString;
          { StrToFloat(campo.AsString) fazia campo -> string -> float. Agora le
            o numero direto: as mascaras do FormatFloat sao as mesmas, entao a
            celula sai identica, e some o risco de a conversao por string
            falhar conforme o tipo que o ZeosLib inferir de double/decimal. }
          Grid.Cells[6, item] := FormatFloat('#######0.000',
            QNF_Itens.FieldByName('QUANTIDADE').AsFloat);
          Grid.Cells[7, item] := QNF_Itens.FieldByName('UNIDADE').AsString;
          Grid.Cells[8, item] := FormatFloat('#######0.000000000',
            QNF_Itens.FieldByName('PRECO_UNITARIO').AsFloat);
          { PRECO_TOTAL e decimal(15,4): AsCurrency preserva as 4 casas do
            Currency do Delphi, como o StrToCurr fazia. }
          Grid.Cells[9, item] := FormatFloat('#######0.00',
            QNF_Itens.FieldByName('PRECO_TOTAL').AsCurrency);
          Grid.Cells[10, item] := QNF_Itens.FieldByName('COD_OS').AsString;
          item := item + 1;

          QNF_Itens.Next

        until QNF_Itens.Eof;

      ETotal.Value := QNf.FieldByName('TOTAL_NOTA').AsCurrency;
      ETotalBenef.Value := QNf.FieldByName('VALOR').AsCurrency;

      BTGravar.enabled := False;

    end;

  end;
end;

procedure TFNf.BTGravarClick(Sender: TObject);
var
  idx: Integer;
begin

  If (ECliente.Text = '') or (strtoint(ECliente.Text) = 0) then
  begin
    Application.MessageBox('O campo Cliente deve ser preenchido!', 'AVISO',
      MB_Ok + MB_IconInformation);
    ECliente.SetFocus;
    exit;
  end;

  if not GarantirConexao then Exit;

  { TBClientesESTADO vinha do cursor BDE posicionado pelo EClienteChange.
    Recarrega explicitamente para nao depender de estado de outro dataset. }
  if not CarregarCliente(Modulo.RetZero(ECliente.Text, 4)) then
  begin
    Application.MessageBox('Cliente nao encontrado!', 'AVISO',
      MB_Ok + MB_IconInformation);
    ECliente.SetFocus;
    exit;
  end;

    If (QCli.FieldByName('ESTADO').AsString <> 'SP') and (ECFOP.Text <> '6124') then
    begin
      Application.MessageBox(
        'Atenção: este cliente é de fora do estado de São Paulo. Neste caso, o CFOP é diferente: Beneficiamento deve ser 6124 e o item de retorno deve estar com 6902.', 'AVISO', MB_Ok + MB_IconInformation);
      ECliente.SetFocus;
      exit;
    end;

  If (ETotalBenef.Value < 120) then
    if (Application.MessageBox(
        'O Total do beneficiamento é menor do que R$ 120,00. Deseja realmente prosseguir?'
          , 'Confirmação de Valor', MB_YESNO + MB_IconQuestion) = IDNo) then
    begin
      ECliente.SetFocus;
      exit;
    end;

  For idx := 1 to Grid.RowCount - 1 do
  begin
    if Grid.Cells[0, idx] = '' then
    begin
      Application.MessageBox(PChar(
          'A coluna Código não pode estar vazia na linha ' + inttostr(idx)),
        'AVISO', MB_Ok + MB_IconInformation);
      ECliente.SetFocus;
      exit;
    end;
    if Grid.Cells[4, idx] = '' then
    begin
      Application.MessageBox(PChar(
          'A coluna CFOP não pode estar vazia na linha ' + inttostr(idx)),
        'AVISO', MB_Ok + MB_IconInformation);
      ECliente.SetFocus;
      exit;
    end;
    if Grid.Cells[5, idx] = '' then
    begin
      Application.MessageBox
        (PChar
          ('A coluna CST não pode estar vazia na linha ' + inttostr(idx)),
        'AVISO', MB_Ok + MB_IconInformation);
      ECliente.SetFocus;
      exit;
    end;

    if (Length(Grid.Cells[2, idx]) <> 8) then
    begin
      Application.MessageBox(PChar(
          'O campo NCM/SH deve conter exatamente 8 dígitos. Linha: ' + inttostr
            (idx)), 'AVISO', MB_Ok + MB_IconInformation);
      ECliente.SetFocus;
      exit;
    end;

    if (Grid.Cells[2, idx] <> '') and (Length(Grid.Cells[2, idx]) <> 8) then
    begin
      Application.MessageBox(PChar(
          'O campo NCM/SH deve estar vazio ou conter exatamente 8 dígitos. Linha: '
            + inttostr(idx)), 'AVISO', MB_Ok + MB_IconInformation);
      ECliente.SetFocus;
      exit;
    end;

  end;

  begin
    If Application.MessageBox(PChar('Deseja realmente ' + tipo +
          ' essa Nota Fiscal?'), PChar('Confirmação para ' + tipo),
      MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) = IdYes then
    begin

      { TBConfig.FindKey(['18']) + Edit + Post -> UPDATE em tb_config }
      GravarConfig(18, EAliqICMS.Text);

      { A NF ja existe nos dois caminhos: no 'gravar' o stub foi criado pela
        pre-reserva no BTOK2; no 'alterar' o registro e o original. Entao aqui
        e SEMPRE UPDATE (secao 4.4 do HANDOFF).
        Os tipos seguem o schema: VALOR/TOTAL_NOTA/ICMS_BASE sao decimal(15,4)
        -> AsCurrency (Currency tem exatamente 4 casas, sem perda);
        QUANTIDADE/PESOL/PESOB sao double -> AsFloat;
        DATAE/DATAS sao date -> AsDate, sem componente de hora. }
      QNfCmd.Close;
      QNfCmd.SQL.Text :=
        'UPDATE tb_nf SET COD_CLI = :pCodCli, DATAE = :pDataE, VALOR = :pValor, ' +
        'TOTAL_NOTA = :pTotal, NATUREZA = :pNatureza, CFOP = :pCfop, ' +
        'CFOP_RETORNO = :pCfopRet, CST = :pCst, CST_RETORNO = :pCstRet, ' +
        'DATAS = :pDataS, TIPO = :pTipo, TIPO_RETORNO = :pTipoRet, ' +
        'TIPO_PAGAMENTO = :pTipoPag, TIPO_30 = :pT30, TIPO_45 = :pT45, ' +
        'TIPO_60 = :pT60, ICMS_BASE = :pIcms, NOME_TRANSPORTADORA = :pTransp, ' +
        'QUANTIDADE = :pQtd, ESPECIE = :pEsp, PESOL = :pPesoL, PESOB = :pPesoB, ' +
        'TIPO_FRETE = :pFrete, TIPO_EMISSAO = :pEmissao, PLACA = :pPlaca, ' +
        'UF_PLACA = :pUfPlaca ' +
        'WHERE CODIGO = :pCodigo';

      QNfCmd.ParamByName('pCodCli').AsString    := ECliente.Text;
      QNfCmd.ParamByName('pDataE').AsDate       := EDataE.date;
      QNfCmd.ParamByName('pValor').AsCurrency   := ETotalBenef.Value;
      QNfCmd.ParamByName('pTotal').AsCurrency   := ETotal.Value;
      QNfCmd.ParamByName('pNatureza').AsString  := ENatureza.Text;
      QNfCmd.ParamByName('pCfop').AsString      := ECFOP.Text;
      QNfCmd.ParamByName('pCfopRet').AsString   := ECFOPRetorno.Text;
      QNfCmd.ParamByName('pCst').AsString       := ECST.Text;
      QNfCmd.ParamByName('pCstRet').AsString    := ECSTRetorno.Text;
      QNfCmd.ParamByName('pDataS').AsDate       := EDataS.date;

      if OpS.Checked = true then
        QNfCmd.ParamByName('pTipo').AsString := 'S'
      else
        QNfCmd.ParamByName('pTipo').AsString := 'E';
      if OpTot.Checked = true then
        QNfCmd.ParamByName('pTipoRet').AsString := 'T'
      else
        QNfCmd.ParamByName('pTipoRet').AsString := 'P';
      if opVista.Checked = true then
        QNfCmd.ParamByName('pTipoPag').AsString := 'V'
      else
        QNfCmd.ParamByName('pTipoPag').AsString := 'P';

      if Opt30.Checked then QNfCmd.ParamByName('pT30').AsString := 'S' else QNfCmd.ParamByName('pT30').AsString := 'N';
      if Opt45.Checked then QNfCmd.ParamByName('pT45').AsString := 'S' else QNfCmd.ParamByName('pT45').AsString := 'N';
      if Opt60.Checked then QNfCmd.ParamByName('pT60').AsString := 'S' else QNfCmd.ParamByName('pT60').AsString := 'N';

      QNfCmd.ParamByName('pIcms').AsCurrency  := Eicms.Value;
      QNfCmd.ParamByName('pTransp').AsString  := ENome.Text;
      QNfCmd.ParamByName('pQtd').AsFloat      := StrToFloat(EQtd.Text);
      QNfCmd.ParamByName('pEsp').AsString     := EEsp.Text;
      QNfCmd.ParamByName('pPesoL').AsFloat    := EPesoL.Value;
      QNfCmd.ParamByName('pPesoB').AsFloat    := EPesoB.Value;

      if OpE.Checked = true then
        QNfCmd.ParamByName('pFrete').AsString := 'E'
      else
        QNfCmd.ParamByName('pFrete').AsString := 'D';
      if OpNormal.Checked = true then
        QNfCmd.ParamByName('pEmissao').AsString := 'N'
      else
        QNfCmd.ParamByName('pEmissao').AsString := 'D';

      QNfCmd.ParamByName('pPlaca').AsString   := EPlaca.Text;
      QNfCmd.ParamByName('pUfPlaca').AsString := Eestado.Text;
      QNfCmd.ParamByName('pCodigo').AsString  := ECodigo.Text;

      { Gravacao da NF, das referencias e dos itens em UMA unidade de trabalho.
        No BDE cada Post ia direto ao arquivo; aqui um erro no meio deixaria a
        nota com itens pela metade, por isso a transacao (secao 4.5).

        Sobre os laços: o codigo original chamava Append sem Post (o Post estava
        ate comentado). Funcionava por efeito colateral - o TDataSet do BDE faz
        post implicito do registro pendente quando o Append seguinte e chamado.
        Com SQL isso nao existe: cada linha vira um INSERT explicito. }
      Modulo.ZConexao.AutoCommit := False;
      try
        try
          QNfCmd.ExecSQL;   { UPDATE tb_nf montado acima }

          QNfRefCmd.Close;
          QNfRefCmd.SQL.Text := 'DELETE FROM tb_nf_ref WHERE COD_NF = :pCod';
          QNfRefCmd.ParamByName('pCod').AsString := ECodigo.Text;
          QNfRefCmd.ExecSQL;

          For idx := 1 to GridNF.RowCount - 1 do
          begin
            QNfRefCmd.Close;
            QNfRefCmd.SQL.Text :=
              'INSERT INTO tb_nf_ref (COD_NF, COD_NF_CLIENTE, DATA_NF_CLIENTE, ' +
              'VALOR_NF_CLIENTE, FLAG_NFE) VALUES (:pCodNf, :pCodCli, :pData, :pValor, :pFlag)';
            QNfRefCmd.ParamByName('pCodNf').AsString  := ECodigo.Text;
            QNfRefCmd.ParamByName('pCodCli').AsString := GridNF.Cells[1, idx];
            { a celula guarda a data ja formatada pelo locale, como o
              TBNf_RefDATA_NF_CLIENTE.AsString gravava }
            QNfRefCmd.ParamByName('pData').AsDate     := StrToDate(GridNF.Cells[2, idx]);
            QNfRefCmd.ParamByName('pValor').AsCurrency := StrToCurr(GridNF.Cells[3, idx]);
            if GridNF.Cells[0, idx] = 'Sim' then
              QNfRefCmd.ParamByName('pFlag').AsString := 'S'
            else
              QNfRefCmd.ParamByName('pFlag').AsString := 'N';
            QNfRefCmd.ExecSQL;
          end;

          QNfItensCmd.Close;
          QNfItensCmd.SQL.Text := 'DELETE FROM tb_nf_itens WHERE COD_NF = :pCod';
          QNfItensCmd.ParamByName('pCod').AsString := ECodigo.Text;
          QNfItensCmd.ExecSQL;

          For idx := 1 to Grid.RowCount - 1 do
          begin
            QNfItensCmd.Close;
            QNfItensCmd.SQL.Text :=
              'INSERT INTO tb_nf_itens (COD_NF, CODIGO, DESCRICAO, NCM, CEST, CFOP, ' +
              'CST, QUANTIDADE, UNIDADE, PRECO_UNITARIO, PRECO_TOTAL, COD_OS) ' +
              'VALUES (:pCodNf, :pCodigo, :pDescr, :pNcm, :pCest, :pCfop, ' +
              ':pCst, :pQtd, :pUnid, :pPrecoUni, :pPrecoTot, :pCodOs)';
            QNfItensCmd.ParamByName('pCodNf').AsString    := ECodigo.Text;
            QNfItensCmd.ParamByName('pCodigo').AsString   := Grid.Cells[0, idx];
            QNfItensCmd.ParamByName('pDescr').AsString    := Grid.Cells[1, idx];
            QNfItensCmd.ParamByName('pNcm').AsString      := Grid.Cells[2, idx];
            QNfItensCmd.ParamByName('pCest').AsString     := Grid.Cells[3, idx];
            QNfItensCmd.ParamByName('pCfop').AsString     := Grid.Cells[4, idx];
            QNfItensCmd.ParamByName('pCst').AsString      := Grid.Cells[5, idx];
            QNfItensCmd.ParamByName('pQtd').AsFloat       := StrToFloat(Grid.Cells[6, idx]);
            QNfItensCmd.ParamByName('pUnid').AsString     := Grid.Cells[7, idx];
            QNfItensCmd.ParamByName('pPrecoUni').AsFloat  := StrToFloat(Grid.Cells[8, idx]);
            QNfItensCmd.ParamByName('pPrecoTot').AsCurrency := StrToCurr(Grid.Cells[9, idx]);
            { COD_OS tem FK para tb_os ON DELETE SET NULL; celula vazia grava NULL }
            if Trim(Grid.Cells[10, idx]) = '' then
              QNfItensCmd.ParamByName('pCodOs').Clear
            else
              QNfItensCmd.ParamByName('pCodOs').AsString := Grid.Cells[10, idx];
            QNfItensCmd.ExecSQL;
          end;

          Modulo.ZConexao.Commit;
          FCodigoReservado := '';   { nota gravada: nao e mais stub a liberar }
        except
          on E: Exception do
          begin
            try Modulo.ZConexao.Rollback; except end;
            ShowMessage('Atencao: Nao foi possivel gravar a NF! ' + E.Message);
            ECodigo.SetFocus;
            Exit;
          end;
        end;
      finally
        Modulo.ZConexao.AutoCommit := True;
      end;

      { O envio da NF-e fica FORA da transacao: e chamada a webservice, nao
        pode segurar a transacao do banco aberta. O enviaNfe atualiza
        FLG_ENVIADA por conta propria. }
      try
        enviaNfe;

        Limpar;
        Modulo.NovaLeitura;
        ECodigo.Text := ProximoCodigoNf;
        ECodigo.SetFocus;
      Except
        ShowMessage('Atencao: Nao foi possivel enviar a NF-e!');
        ECodigo.SetFocus;
      end;

    end
    else
      ENatureza.SetFocus;
  end;

end;

procedure TFNf.EQtdEnter(Sender: TObject);
begin
  EQtd.Color := $00E2F5FE;
  EQtd.Font.Color := clNavy;
  EQtd.Font.style := [fsBold];

end;

procedure TFNf.EEspEnter(Sender: TObject);
begin
  EEsp.Color := $00E2F5FE;
  EEsp.Font.Color := clNavy;
  EEsp.Font.style := [fsBold];

end;

procedure TFNf.EPesoBEnter(Sender: TObject);
begin
  EPesoB.Color := $00E2F5FE;
  EPesoB.Font.Color := clNavy;
  EPesoB.Font.style := [fsBold];

end;

procedure TFNf.EPesoLEnter(Sender: TObject);
begin
  EPesoL.Color := $00E2F5FE;
  EPesoL.Font.Color := clNavy;
  EPesoL.Font.style := [fsBold];

end;

procedure TFNf.EQtdExit(Sender: TObject);
begin
  EQtd.Color := clWhite;
  EQtd.Font.Color := clBlack;
  EQtd.Font.style := [];

end;

procedure TFNf.EEspExit(Sender: TObject);
begin
  EEsp.Color := clWhite;
  EEsp.Font.Color := clBlack;
  EEsp.Font.style := [];

end;

procedure TFNf.EPesoBExit(Sender: TObject);
begin
  EPesoB.Color := clWhite;
  EPesoB.Font.Color := clBlack;
  EPesoB.Font.style := [];

end;

procedure TFNf.EPesoLExit(Sender: TObject);
begin
  EPesoL.Color := clWhite;
  EPesoL.Font.Color := clBlack;
  EPesoL.Font.style := [];

end;

procedure TFNf.ENF2Exit(Sender: TObject);
begin
  TEdit(Sender).Color := clWhite;
  TEdit(Sender).Font.Color := clBlack;
  TEdit(Sender).Font.style := [];

end;

procedure TFNf.ENF2Enter(Sender: TObject);
begin
  TEdit(Sender).Color := $00E2F5FE;
  TEdit(Sender).Font.Color := clNavy;
  TEdit(Sender).Font.style := [fsBold];
end;

procedure TFNf.EDataNF2Enter(Sender: TObject);
begin
  TDateEdit(Sender).Color := $00E2F5FE;
  TDateEdit(Sender).Font.Color := clNavy;
  TDateEdit(Sender).Font.style := [fsBold];

end;

procedure TFNf.EDataNF2Exit(Sender: TObject);
begin
  TDateEdit(Sender).Color := clWhite;
  TDateEdit(Sender).Font.Color := clBlack;
  TDateEdit(Sender).Font.style := [];

end;

procedure TFNf.EvalorNF2Enter(Sender: TObject);
begin
  TCurrencyEdit(Sender).Color := $00E2F5FE;
  TCurrencyEdit(Sender).Font.Color := clNavy;
  TCurrencyEdit(Sender).Font.style := [fsBold];

end;

procedure TFNf.EvalorNF2Exit(Sender: TObject);
begin
  TCurrencyEdit(Sender).Color := clWhite;
  TCurrencyEdit(Sender).Font.Color := clBlack;
  TCurrencyEdit(Sender).Font.style := [];

end;

procedure TFNf.BTMaisEnter(Sender: TObject);
begin
  BTMais.ButtonColor := $00E2F5FE;
  BTMais.ButtonColor1 := clGray;

end;

procedure TFNf.BTMaisExit(Sender: TObject);
begin
  BTMais.ButtonColor := $00CACACA;
  BTMais.ButtonColor1 := $00CACACA;

end;

procedure TFNf.BTMaisClick(Sender: TObject);
Var
  indice: Integer;
begin
  indice := GridNF.RowCount;
  GridNF.AddRow;
  If Length(ENF.Text) = 44 then
    GridNF.Cells[0, indice] := 'Sim'
  else
    GridNF.Cells[0, indice] := 'Não';
  GridNF.Cells[1, indice] := ENF.Text;
  if EDataNF.Text <> '' then
    GridNF.Cells[2, indice] := EDataNF.Text;
  GridNF.Cells[3, indice] := FormatFloat('#######0.00',
    StrToCurr(EValorNF.Text));
  ENF.Clear;
  EDataNF.Clear;
  EValorNF.Clear;
  BTFechar.SetFocus;
end;

procedure TFNf.BTVoltarClick(Sender: TObject);
begin
  G1.enabled := true;
  G2.enabled := true;
  EFantasia.SetFocus;
end;

procedure TFNf.FormClose(Sender: TObject; var Action: TCloseAction);
{ Antes: TBNf ficava em dsEdit desde o BTOK2 e o Delete removia o registro.
  Agora o equivalente e o codigo pre-reservado (FCodigoReservado): existe um
  stub em tb_nf com so a PK preenchida enquanto a nota nao foi gravada.
  A pergunta ao usuario e o mesmo texto de antes. }
begin
  If (FCodigoReservado <> '') and (tipo = 'gravar') then
    If Application.MessageBox(PChar(
        'VOCÊ ESTA SAINDO COM UMA NF EM ABERTO! ELA SERÁ DELETADA! Deseja proseguir?'),
      PChar('saindo do formulário'),
      MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) = IdYes then
    begin
      LiberarCodigoReservado;
    end
    else
    begin
      Action := caNone;
      ENatureza.SetFocus;
    end;
end;

procedure TFNf.BTaddClick(Sender: TObject);
begin
  If Grid.RowCount > 0 then
    Grid.InsertRows(Grid.Row + 1, 1)
  else
    Grid.AddRow;
  item := item + 1;

end;

procedure TFNf.EicmsEnter(Sender: TObject);
begin
  Eicms.Color := $00E2F5FE;
  Eicms.Font.Color := clNavy;
  Eicms.Font.style := [fsBold];

end;

procedure TFNf.EicmsExit(Sender: TObject);
begin
  Eicms.Color := clWhite;
  Eicms.Font.Color := clBlack;
  Eicms.Font.style := [];

end;

procedure TFNf.BTNfeClick(Sender: TObject);
begin

  enviaNfe;
end;

procedure TFNf.notificaTelegram;
var
  IdHTTP1 : TIdHTTP;
  Src : string;
  LHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
   // Str := IdHttp1.Get('https://api.telegram.org/bot999791218:AAFIVrZKRstA9QG_hWgSEs4ShQhFCdxrQk0/sendMessage?chat_id=@grupo_amortrat&text='+Memo1.Text);

    try
   IdHTTP1:=TIdHTTP.Create(nil);
   try
    LHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    LHandler.SSLOptions.Method := TIdSSLVersion.sslvSSLv23;
    try
      IdHTTP1.IOHandler:=LHandler;
      IdHTTP1.ProtocolVersion := TIDHTTPProtocolVersion.pv1_1;
    Src := IdHttp1.Get('https://api.telegram.org/bot999791218:AAFIVrZKRstA9QG_hWgSEs4ShQhFCdxrQk0/sendMessage?chat_id=@grupo_amortrat&text=TesteTimer');
      ShowMessage(Src);
    finally
      LHandler.Free;
    end;
   finally
     IdHTTP1.Free;
   end;
  except on E: Exception do
      ShowMessage(E.ClassName + ': '+ E.Message);
  end;

end;


procedure TFNf.enviaNfe;
var
  i: Integer;
  nfeAux, infoAdicional, codCliente: String;
    IdHTTP1 : TIdHTTP;
  Src : string;
  LHandler: TIdSSLIOHandlerSocketOpenSSL;

  CC: Tstrings;
  Mensagem: Tstrings;
  MsgTelegram: String;
  host, port, user, pass, destinatario, nf_envio: String;
  tpass: Tstrings;
  Ok: Boolean;
  arquivo: TextFile;
  qtdParcelas: Integer;
  totalParcelas: Currency;

    const
  sLineBreak = {$IFDEF LINUX} AnsiChar(#10) {$ENDIF}
               {$IFDEF MSWINDOWS} AnsiString(#13#10) {$ENDIF};

begin

  try
    ACBrNFe1.NotasFiscais.Clear;
    qtdParcelas := 0;
    totalParcelas := 0;


    with Modulo, ACBrNFe1.NotasFiscais.Add.NFe do
    begin

      infNFe.ID := ECodigo.Text;
      nfeAux := ECodigo.Text;
      nf_envio := ECodigo.Text;

      CarregarCliente('0001');   { emitente: a propria empresa }

      Ide.cUF := 35;

      //Ide.cNF := GerarCodigoDFe﻿﻿(NUmerodaNF);
  //    Ide.cNF := strtoint(ECodigo.Text) + 1;

       if ambiente = '2' then
        Ide.cNF := strtoint(ECodigo.Text) + 10000000
      else
        Ide.cNF := strtoint(ECodigo.Text) + 10000000;

      Ide.natOp := ENatureza.Text; // natureza da operacao
      // tipo de pagto
      if OpDevolucao.Checked then
        Ide.indPag := ipOutras
      else If opVista.Checked = true then
        Ide.indPag := ipVista
      else
        Ide.indPag := ipPrazo;


      Ide.Modelo := 55;
      Ide.serie := 1; // preencher com zeros conforme manual?
      Ide.nNF := strtoint(ECodigo.Text);
      Ide.dEmi := date;
      Ide.dSaiEnt := date;
      Ide.hSaiEnt := now;

      If OpS.Checked = true then
        Ide.tpNF := tnSaida
      else
        Ide.tpNF := tnEntrada;
      Ide.tpEmis := teNormal;
      Ide.tpAmb := StrToTpAmb(Ok, ambiente);

      Ide.verProc := '1.0.0.0';
      Ide.cMunFG := strtoint(DigitoCidade(QCli.FieldByName('COD_MUNICIPIO').AsString));
      Ide.finNFe := fnNormal;

      Emit.CNPJCPF := QCli.FieldByName('CNPJ').AsString;
      Emit.IE := QCli.FieldByName('INSC_EST').AsString;
      Emit.xNome := QCli.FieldByName('RAZAO').AsString;
      Emit.xFant := QCli.FieldByName('FANTASIA').AsString;
      Emit.EnderEmit.Fone := QCli.FieldByName('TEL1').AsString;
      Emit.EnderEmit.CEP := strtoint(RemoveChar(QCli.FieldByName('CEP').AsString));

      Emit.EnderEmit.xLgr := QCli.FieldByName('ENDERECO').AsString;
      Emit.EnderEmit.nro := QCli.FieldByName('NUMERO').AsString;

      Emit.EnderEmit.xBairro := QCli.FieldByName('BAIRRO').AsString;
      Emit.EnderEmit.cMun := strtoint
        (DigitoCidade(QCli.FieldByName('COD_MUNICIPIO').AsString));
      Emit.EnderEmit.xMun := QCli.FieldByName('CIDADE').AsString;
      Emit.EnderEmit.UF := QCli.FieldByName('ESTADO').AsString;
      Emit.EnderEmit.cPais := 1058;
      Emit.EnderEmit.xPais := 'BRASIL';

      Emit.IEST := '';
      Emit.IM := ''; // Preencher no caso de existir serviços na nota
      Emit.CNAE := ''; // Verifique na cidade do emissor da NFe se é permitido a inclusão de serviços na NFe
      Emit.CRT := crtSimplesNacional;


      AutXML.New.CNPJCPF := LerConfig(26);


      CarregarCliente(ECliente.Text);   { destinatario }
      codCliente := ECliente.Text;
      Dest.CNPJCPF := QCli.FieldByName('CNPJ').AsString;
      Dest.IE := QCli.FieldByName('INSC_EST').AsString;
      Dest.ISUF := '';

      if ambiente = '2' then
        Dest.xNome :=
          'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
      else
        Dest.xNome := QCli.FieldByName('RAZAO').AsString;

      Dest.EnderDest.Fone := QCli.FieldByName('TEL1').AsString;
      Dest.EnderDest.CEP := strtoint(RemoveChar(QCli.FieldByName('CEP').AsString));
      Dest.EnderDest.xLgr := QCli.FieldByName('ENDERECO').AsString;
      Dest.EnderDest.nro := QCli.FieldByName('NUMERO').AsString;
      Dest.EnderDest.xCpl := '';
      Dest.EnderDest.xBairro := QCli.FieldByName('BAIRRO').AsString;
      Dest.EnderDest.cMun := strtoint
        (DigitoCidade(QCli.FieldByName('COD_MUNICIPIO').AsString));
      Dest.EnderDest.xMun := QCli.FieldByName('CIDADE').AsString;
      Dest.EnderDest.UF := QCli.FieldByName('ESTADO').AsString;
      Dest.EnderDest.cPais := 1058;
      Dest.EnderDest.xPais := 'BRASIL';
      Dest.indIEDest := inContribuinte;


      If Dest.EnderDest.UF = 'SP' then
        Ide.idDest := doInterna
      else
        Ide.idDest := doInterestadual;
      Ide.indFinal := cfNao;
      Ide.indPres := pcNao;
      If OpNormal.Checked = true then
        Ide.finNFe := fnNormal
      else
        Ide.finNFe := fnDevolucao;


      // referencia notas fiscais do cliente (modelo 1A) - Verificar como adicionar nota NFE

      For i := 1 to GridNF.RowCount - 1 do
      begin
        if GridNF.Cells[0, i] = 'Sim' then
        begin
          Ide.NFref.Add.refNFe := GridNF.Cells[1, i];
        end
        else
          with Ide.NFref.Add.RefNF do
          begin
            cUF := 35; // recuperar o valor do codigo do estado de forma correta!!!! (ver no manual)
            AAMM := FormatDateTime('yymm', date);
            CNPJ := QCli.FieldByName('CNPJ').AsString;
            serie := 0;
            nNF := strtoint(ENF.Text);
            Modelo := 01;
          end;
        begin
        end;
      end;

      For i := 1 to Grid.RowCount - 1 do
      begin
        with Det.Add do
        begin
          Prod.nItem := i;

          Prod.cProd := Grid.Cells[0, i];

          Prod.xProd := Grid.Cells[1, i];
          Prod.NCM := Grid.Cells[2, i];
          Prod.CEST := Grid.Cells[3, i];
          Prod.EXTIPI := '';
          Prod.CFOP := Grid.Cells[4, i];
          Prod.qCom := StrToFloat(Grid.Cells[6, i]);
          Prod.uCom := UpperCase(Grid.Cells[7, i]);
          Prod.vUnCom := StrToFloat(Grid.Cells[8, i]);
          Prod.vProd := StrToCurr(Grid.Cells[9, i]);
          Prod.cEAN := 'SEM GTIN';

          Prod.cEANTrib := 'SEM GTIN';
          Prod.qTrib := StrToFloat(Grid.Cells[6, i]);
          Prod.uTrib := UpperCase(Grid.Cells[7, i]);
          Prod.vUnTrib := StrToFloat(Grid.Cells[8, i]);

          Prod.vFrete := 0;
          Prod.vSeg := 0;
          Prod.vDesc := 0;

          infAdProd := '';


          with Imposto do
          begin

           // limpando reforma tributaria
           //IBSCBS.gIBSCBS := nil;

           // lei da transparencia nos impostos
           vTotTrib := 0;


            with ICMS do
            begin
              Case strtoint(Grid.Cells[5, i]) of
                0:
                  CST := cst00;
                10:
                  CST := cst10;
                20:
                  CST := cst20;
                30:
                  CST := cst30;
                40:
                  CST := cst40;
                41:
                  CST := cst41;
                50:
                  CST := cst50;
                60:
                  CST := cst60;
                70:
                  CST := cst70;
                80:
                  CST := cst80;
              else
                CST := cst90;
              end;
              ICMS.orig := oeNacional;
              //Alteracao: ICMS.modBC := dbiPrecoTabelado;
              ICMS.modBC := dbiValorOperacao;

              ICMS.vBC := Eicms.Value / 100 * StrToFloat(Grid.Cells[8, i]);
              // verificar que valor colocar neste ponto
              ICMS.pICMS := Eicms.Value;
              ICMS.vICMS := (StrToFloat(Grid.Cells[8, i]) * (Eicms.Value / 100));
              ICMS.modBCST := dbisMargemValorAgregado;
              ICMS.pMVAST := 0;
              ICMS.pRedBCST := 0;
              ICMS.vBCST := 0;
              ICMS.pICMSST := 0;
              ICMS.vICMSST := 0;
              ICMS.pRedBC := 0;
              // Alteração


              // verificar estes valores

              // se for emerson dadario, coloca o csosn101
              if (QCli.FieldByName('CODIGO').AsString = '0343') or (QCli.FieldByName('CODIGO').AsString = '0001') then
              ICMS.CSOSN := csosn101
              else
              ICMS.CSOSN := csosn900;

              // Alteracao pedido Dadario
              ICMS.pCredSN := EAliqICMS.Value;

              //Correção NINO Faróis
             // ICMS.vCredICMSSN := Ecred.Value;
             ICMS.vCredICMSSN :=  ArredondaFinal5((StrToFloat(Grid.Cells[9, i]) * (EAliqICMS.Value / 100)));

              if (Prod.CFOP = '5902') then begin
                    ICMS.vCredICMSSN := 0;
                    ICMS.pCredSN := 0;
              end;
            end;

            with IPI do
            begin
              CST := ipi01;
              clEnq := '';
              CNPJProd := '';
              cSelo := '';
              qSelo := 0;
              cEnq := '';

              vBC := 0;
              qUnid := 0;
              vUnid := 0;
              pIPI := 0;
              vIPI := 0;
            end;
            with PIS do
            begin
              CST := pis99;
              qBCProd := 0;
              vAliqProd := 0;
              vPIS := 0;
            end;

            with ICMSUFDest do
            begin

              // ICMSUFDest.vFCPUFDest := Total.ICMSTot.vFCPUFDest;
              // ICMSUFDest.vICMSUFDest := Total.ICMSTot.vICMSUFDest;
              // ICMSUFDest.vICMSUFDest := Total.ICMSTot.vICMSUFRemet;

              ICMSUFDest.vFCPUFDest := 0;
              ICMSUFDest.vICMSUFDest := 0;
              ICMSUFDest.vICMSUFDest := 0;

            end;

        with PIS do
        begin
          CST      := pis99;
          PIS.vBC  := 0;
          PIS.pPIS := 0;
          PIS.vPIS := 0;

          PIS.qBCProd   := 0;
          PIS.vAliqProd := 0;
          PIS.vPIS      := 0;
        end;

        with PISST do
        begin
          vBc       := 0;
          pPis      := 0;
          qBCProd   := 0;
          vAliqProd := 0;
          vPIS      := 0;
          {
            abaixo o campo incluido no layout a partir da NT 2020/005
          }
          {
            valores aceitos pelo campo:
            ispNenhum, ispPISSTNaoCompoe, ispPISSTCompoe
          }
          // Indica se o valor do PISST compõe o valor total da NF-e
          IndSomaPISST :=  ispNenhum;
        end;


        with COFINSST do
        begin
          vBC       := 0;
          pCOFINS   := 0;
          qBCProd   := 0;
          vAliqProd := 0;
          vCOFINS   := 0;
          {
            abaixo o campo incluido no layout a partir da NT 2020/005
          }
          {
            valores aceitos pelo campo:
            iscNenhum, iscCOFINSSTNaoCompoe, iscCOFINSSTCompoe
          }
          // Indica se o valor da COFINS ST compõe o valor total da NF-e
          indSomaCOFINSST :=  iscNenhum;
        end;

            with COFINS do
            begin
              CST := cof99;
              qBCProd := 0;
              vAliqProd := 0;
              vCOFINS := 0;
            end;
          end;


        end;

      end;

      if ETotalBenef.Value > 0 then
        Total.ICMSTot.vBC := Eicms.Value / 100 * ETotalBenef.Value
      else
        Total.ICMSTot.vBC := 0;

      If QCli.FieldByName('ESTADO').AsString <> 'SP' then
      begin
        Total.ICMSTot.vICMS := 0.12 * Total.ICMSTot.vBC;
      end
      else
      begin
        Total.ICMSTot.vICMS := 0.18 * Total.ICMSTot.vBC;
      end;

      Total.ICMSTot.vNF := ETotal.Value; // verificar
      Total.ICMSTot.vProd := ETotal.Value; // verificar

      If OpTot.Checked = true then
        infoAdicional :=
          'Material recebido c\ vossa(s) NFe indicada(s) neste documento digital que ora retornamos totalmente:;'
      else
        infoAdicional :=
          'Material recebido c\ vossa(s) NFe indicada(s) neste documento digital que ora retornamos parcialmente:;';

      For i := 1 to GridNF.RowCount - 1 do
      begin
        if GridNF.Cells[0, i] = 'Sim' then
          infoAdicional := infoAdicional + 'Codigo NF-e: ' + GridNF.Cells[1,
            i] + ' enviada em ' + GridNF.Cells[2,
            i] + ' com valor de ' + GridNF.Cells[3, i] + ';'
        else
          infoAdicional := infoAdicional + 'Número: ' + GridNF.Cells[1,
            i] + ' de ' + GridNF.Cells[2, i] + ' com valor de ' + GridNF.Cells
            [3, i] + ';';
      end;


        if opPrazo.Checked then qtdParcelas := qtdParcelas + 1;


        if Opt30.enabled and Opt30.Checked then
          qtdParcelas := qtdParcelas + 1;
        if Opt45.enabled and Opt45.Checked then
          qtdParcelas := qtdParcelas + 1;
        if Opt60.enabled and Opt60.Checked then
          qtdParcelas := qtdParcelas + 1;


      if ETotalBenef.Value > 0 then

        if opVista.Checked then
        infoAdicional := infoAdicional + ';' + EInfAdic.Text +
          ';Valor total cobrado pelo beneficiamento: R$ ' + FormatFloat
          ('#######0.00', ETotalBenef.Value) + ' com pagto a vista.'

        else
        infoAdicional := infoAdicional + ';' + EInfAdic.Text +
          ';Valor total cobrado pelo beneficiamento: R$ ' + FormatFloat
          ('#######0.00', ETotalBenef.Value) + ' em ' + IntToStr(qtdParcelas) + ' parcela(s) com vencimento descrito(s) acima.'


      else if OpDevolucao.Checked = true then
        infoAdicional := infoAdicional + ';' + EInfAdic.Text +
          ';Retorno de embalagem utilizada para acondicionamento de produtos para beneficiamento.'

      else
        infoAdicional := infoAdicional + ';' + EInfAdic.Text +
          ';Serviço aplicado sem ônus ao cliente';

      InfAdic.infCpl := infoAdicional;
      InfAdic.infAdFisco := '';

      if OpDevolucao.Checked then  ETotalBenef.Value := 0;


      If ETotalBenef.Value > 0 then
      begin

       if opPrazo.Checked then begin

        totalParcelas := ETotalBenef.Value / qtdParcelas;

        For i := 1 to qtdParcelas do
        begin


          with cobr.Dup.Add do
          begin


            case i of
              1:
                dVenc := EDuplicata.Date;
              2:
                if opt30.Checked then
                 dVenc := ProximoDiaUtil(IncDay(EDuplicata.date, 7))
                else if opt45.Checked then
                 dVenc := ProximoDiaUtil(IncDay(EDuplicata.date, 15))
                else if opt60.Checked then
                 dVenc := ProximoDiaUtil(IncDay(EDuplicata.date, 30));
              3:
                if (opt30.Checked = true) and (opt45.Checked) then
                 dVenc := ProximoDiaUtil(IncDay(EDuplicata.date, 15))
                else if (opt30.Checked = true) and (opt60.Checked) then
                 dVenc := ProximoDiaUtil(IncMonth(EDuplicata.date, 1))
                else if (opt45.Checked = true) and (opt60.Checked) then
                 dVenc := ProximoDiaUtil(IncMonth(EDuplicata.date, 1));
              4:
                dVenc := ProximoDiaUtil(IncMonth(EDuplicata.date, 1));
            end;

            case i of

              1:
                nDup :=  '001';
              2:
                nDup :=  '002';
              3:
                nDup :=  '003';
              4:
                nDup :=  '004';
            end;
            vDup := totalParcelas;
          end;

        end;

end else

   If opVista.Checked = false then

        with cobr.Dup.Add do
        begin
        nDup := '001';
        dVenc := EDuplicata.Date;
        vDup := ETotalBenef.value;
        end;



end;


if OpDevolucao.Checked = FALSE then
BEGIN

  Cobr.Fat.nFat  := ECodigo.Text;
  Cobr.Fat.vOrig := ETotalBenef.value;
  Cobr.Fat.vDesc := 0;
  Cobr.Fat.vLiq  := ETotalBenef.value;


    with pag.Add do
       begin
         tPag:= fpBoletoBancario;
         vPag:= ETotalBenef.value;
       end;
END ELSE  BEGIN
    with pag.Add do
       begin
          tPag:= fpSemPagamento;
       end;
END;
;

      // informações sobre o transporte da mercadoria
      If OpE.Checked = true then
        transp.modFrete := mfContaEmitente
      else
        transp.modFrete := mfContaDestinatario;
      transp.Transporta.xNome := ENome.Text;

      transp.Transporta.CNPJCPF := '';
      transp.Transporta.IE := '';
      transp.Transporta.xEnder := '';
      transp.Transporta.xMun := '';
      transp.Transporta.UF := '';

      transp.retTransp.vServ := 0;
      transp.retTransp.vBCRet := 0;
      transp.retTransp.pICMSRet := 0;
      transp.retTransp.vICMSRet := 0;
      transp.retTransp.CFOP := '';
      transp.retTransp.cMunFG := 0;

      If EPlaca.Text <> '' then
      begin
        transp.veicTransp.placa := EPlaca.Text;
        transp.veicTransp.UF := Eestado.Text;
        transp.veicTransp.RNTC := '';
      end;

      with transp.Vol.Add do
      begin
        qVol := strtoint(EQtd.Text);
        esp := EEsp.Text;
        nVol := '';
        pesoL := EPesoL.Value;
        pesoB := EPesoB.Value;
      end;

      // mensagem telegram

      MsgTelegram := '*NF EMITIDA:*' + nfeAux + sLineBreak +
                     '*CLIENTE:*' + QCli.FieldByName('FANTASIA').AsString ;




      Try



        Try





          ACBrNFe1.NotasFiscais.GerarNFe;



       //   ACBrNFe1.NotasFiscais.Validar;
         // ShowMessage(ACBrNFe1.NotasFiscais.Items[0].Alertas);

          ACBrNFe1.Enviar(0, true, true);
         // ACBrNFe1.Enviar(1);

        except
          on E: Exception do
          begin

            if E.Message = 'Operation aborted' then
              ShowMessage(
                'Atenção. Você cancelou a impressão mas a Nota será encaminhar por e-mail.')
            else
            begin

              AtualizarFlagNf(nfeAux, 'N');

              ShowMessage('Atenção, erro ao enviar:' + E.message);

              AssignFile(arquivo,
                ACBrNFe1.Configuracoes.Arquivos.PathSalvar +
                  'Amortrat_NFe.log');

                  if FileExists(ACBrNFe1.Configuracoes.Arquivos.PathSalvar +
                  'Amortrat_NFe.log') then
                   Append(arquivo)
                  else
                    Rewrite(arquivo);


              Writeln(arquivo,
                '---------------------------------------------------------------------------------------------------------------------------');
              Writeln(arquivo,
                'Erro ao gerar Nota Fiscal [' + nfeAux + ']:' + E.message);
              CloseFile(arquivo);

              raise Exception.Create(E.message);
            end;
          END;
        end;

      Finally



      AssignFile(arquivo, ACBrNFe1.Configuracoes.Arquivos.PathSalvar +
            'Amortrat_NFe.log');

                              if FileExists(ACBrNFe1.Configuracoes.Arquivos.PathSalvar +
                  'Amortrat_NFe.log') then
                   Append(arquivo)
                  else
                    Rewrite(arquivo);

        Writeln(arquivo,
          '---------------------------------------------------------------------------------------------------------------------------');
        Writeln(arquivo, 'Data de envio [' + DateToStr(now) + ']');
        Writeln(arquivo, 'Log de envio da Nota Fiscal [' + nfeAux + ']');
        Writeln(arquivo,
          'Dados da mensagem: ' + UTF8Encode
            (ACBrNFe1.WebServices.Retorno.RetWS));
      //ShowMessage('Tentando escrever mensagem de erro');

        Writeln(arquivo,
          'Erro: ' + ACBrNFe1.NotasFiscais.Items[0].ErroValidacao);
        Writeln(arquivo,
          'Retorno WS: ' + UTF8Encode(ACBrNFe1.WebServices.Retorno.RetWS));

        if ACBrNFe1.NotasFiscais.Items[0].ErroValidacao <> '' then
          Application.MessageBox
            (PChar(UTF8Encode(ACBrNFe1.NotasFiscais.Items[0].ErroValidacao)),
            PChar('MENSAGEM DE RETORNO - ENVIO DA NFE' + nfeAux),
            MB_Ok + MB_IconInformation);



        CloseFile(arquivo);


      End;

      //ShowMessage('Buscano nota' + nfeAux);

    //  chave alternativa: ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtDFe.Items[0].chDFe;
      AtualizarNfEnviada(nfeAux,
                         ACBrNFe1.NotasFiscais[0].NFe.procNFe.chNFe,
                         ACBrNFe1.NotasFiscais.Items[0].NomeArq);

      QNF_Config.close;
      QNF_Config.SQL.Clear;
      QNF_Config.SQL.Text := 'SELECT COD_CONFIG, VLR_CONFIG FROM tb_config';
      QNF_Config.Open;

      If not QNF_Config.Eof then
        repeat
          If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 6 then
            host := QNF_Config.FieldByName('VLR_CONFIG').AsString;
          If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 7 then
            port := QNF_Config.FieldByName('VLR_CONFIG').AsString;
          If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 8 then
            user := QNF_Config.FieldByName('VLR_CONFIG').AsString;
          If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 9 then
            pass := QNF_Config.FieldByName('VLR_CONFIG').AsString;
          QNF_Config.Next
        until QNF_Config.Eof;

        CarregarCliente(codCliente);


      Mensagem := TstringList.Create;
      Mensagem.Add(
        '<HTML>Este e-mail refere-se à Nota Fiscal Eletronica Nacional emitida para:');
      Mensagem.Add('');
      Mensagem.Add('<b>Razao Social...:</b>' + QCli.FieldByName('RAZAO').AsString);
      Mensagem.Add('CNPJ...........:' + QCli.FieldByName('CNPJ').AsString);
      Mensagem.Add('');
      Mensagem.Add(
        'Para verificar a autorização do SEFAZ para esta NF-e, consulte o site:'
        );
      Mensagem.Add('http://www.nfe.sp.gov.br');
      Mensagem.Add('');

    Mensagem.Add
        ('Chave de acesso: ' +
          ACBrNFe1.WebServices.Retorno.ChaveNFe);
      Mensagem.Add
        ('Protocolo......: ' +
          ACBrNFe1.WebServices.Retorno.Protocolo);
      Mensagem.Add
        ('recibo.........: ' +
          ACBrNFe1.WebServices.Retorno.Recibo);
    {
      Mensagem.Add
        ('Chave de acesso: ' +
          ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtDFe.Items[0].nProt);
      Mensagem.Add
        ('Protocolo......: ' +
          ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtDFe.Items[0].nProt);
     }
      Mensagem.Add('');
      Mensagem.Add(
        'O DANFE referente à NF-e acima mencionada encontra-se em anexo.');
      Mensagem.Add('');
      Mensagem.Add('');
      Mensagem.Add(
        'Este e-mail foi enviado automaticamente pelo Sistema AMORTRAT.</HTML>'
        );

      CC := TstringList.Create;

      QEMail.close;
      QEMail.SQL.Clear;
      QEMail.SQL.Text :=
        'Select * from email where COD_CLIENTE = "' + codCliente + '"';
      QEMail.Open;

      i := 0;

      If not QEMail.Eof then
        repeat
          If QEMail.FieldByName('FLG_CQ').AsString <> 'X' then
          begin
            If i = 0 then
              destinatario := QEMail.FieldByName('EMAIL').AsString
            else
              CC.Add(QEMail.FieldByName('EMAIL').AsString);
            i := i + 1;
          end;
          QEMail.Next
        until QEMail.Eof;

        try





          ACBrMail1.host := host;
          ACBrMail1.port := port;
          ACBrMail1.Username := user;
          ACBrMail1.From := user;
          ACBrMail1.Password := pass;
          ACBrMail1.From := 'financeiro@amortrat.com.br';
          ACBrMail1.SetSSL := true; // SSL - ConexÃ£o Segura
          ACBrMail1.SetTLS := true; // Auto TLS
          ACBrMail1.ReadingConfirmation := False;
          // Pede confirmaÃ§Ã£o de leitura do email
          ACBrMail1.UseThread := false; // Aguarda Envio do Email(nÃ£o usa thread)
          ACBrMail1.FromName := 'financeiro@amortrat.com.br';

          ACBrNFe1.NotasFiscais.Items[0].EnviarEmail(destinatario,
            '[AMORTRAT] Envio da Nota Fiscal Eletronica Nacional - NF: ' +
              nfeAux, Mensagem, true // Enviar PDF junto
              , CC // Lista com emails que serÃ£o enviado cÃ³pias - TStrings
              , nil); // Lista de anexos - TStrings


        finally

        // Notifica Telegram

      {      try
             IdHTTP1:=TIdHTTP.Create(nil);
             try
              LHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
              LHandler.SSLOptions.Method := TIdSSLVersion.sslvSSLv23;
              try
                IdHTTP1.IOHandler:=LHandler;
                IdHTTP1.ProtocolVersion := TIDHTTPProtocolVersion.pv1_1;
              Src := IdHttp1.Get('https://api.telegram.org/bot999791218:AAFIVrZKRstA9QG_hWgSEs4ShQhFCdxrQk0/sendMessage?parse_mode=html&chat_id=@grupo_amortrat&text=' + MsgTelegram);

              finally
                LHandler.Free;
              end;
             finally
               IdHTTP1.Free;
             end;
            except on E: Exception do
                ShowMessage(E.ClassName + ': '+ E.Message);
            end;

          CC.Free;

         }
        end;

    end;

    ACBrNFe1.NotasFiscais.Clear;

  except
    on E: Exception do
    begin
      ShowMessage('Problema ao enviar email' + E.Message);
      AtualizarFlagNf(ECodigo.Text, 'N');

    end;
  end;
end;

procedure TFNf.ACBrNFe1StatusChange(Sender: TObject);
begin
  case ACBrNFe1.Status of
    stIdle:
      begin
        if (frmStatus <> nil) then
          frmStatus.Hide;
      end;
    stNFeStatusServico:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Verificando Status do servico...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeRecepcao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando dados da NFe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNfeRetRecepcao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Recebendo dados da NFe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNfeConsulta:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando NFe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNfeCancelamento:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando cancelamento de NFe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNfeInutilizacao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando pedido de Inutilização...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeRecibo:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando Recibo de Lote...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeCadastro:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando Cadastro...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeEmail:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando Email...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeCCe:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando Carta de Correção...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeEvento:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando Evento...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
  end;
  Application.ProcessMessages;
end;

function TFNf.RemoveChar(Const Texto: String): String;
//
// Remove caracteres de uma string deixando apenas numeros
//
var
  i: Integer;
  S: string;
begin
  S := '';
  for i := 1 To Length(Texto) Do
  begin
    if (Texto[i] in ['0' .. '9']) then
    begin
      S := S + Copy(Texto, i, 1);
    end;
  end;
  result := S;
end;

function TFNf.DigitoCidade(Codigo: String): String;
var
  i, Valor, Soma: Integer;
  Digito: string;
const
  PESO = '1212120';
  NAO_VALIDAR =
    '|2201919|2202251|2201988|2611533|3117836|3152131|4305871|5203939|5203962|';
begin
  if Length(Codigo) < 6 then
  begin
    result := 'Tamanho Inválido';
    exit;
  end;
  if pos('|' + Copy(Codigo, 1, 6), NAO_VALIDAR) > 0 then
  begin
    result := Copy(NAO_VALIDAR, pos('|' + Codigo, NAO_VALIDAR) + 1, 7);
    exit;
  end;
  Soma := 0;
  for i := 1 to 6 do
  begin
    Valor := strtoint(Copy(Codigo, i, 1)) * strtoint(Copy(PESO, i, 1));
    if Valor > 9 then
      Soma := Soma + strtoint(Copy(inttostr(Valor), 1, 1)) + strtoint
        (Copy(inttostr(Valor), 2, 1))
    else
      Soma := Soma + Valor;
  end;
  Digito := inttostr((10 - (Soma mod 10)));
  if ((Soma mod 10) = 0) then
    Digito := '0';
  result := Copy(Codigo, 1, 6) + Digito;
end;

procedure TFNf.BTDeleteRowClick(Sender: TObject);
begin
  if item > 1 then
  begin
    item := item - 1;

    if (Grid.Cells[9, Grid.Row] <> '') AND (Grid.Cells[6, Grid.Row] = '5124') then
      ETotal.Value := ETotal.Value - StrToCurr(Grid.Cells[9, Grid.Row]);

    Grid.RemoveRows(Grid.Row, 1);
  end;
end;

procedure TFNf.BTMenosClick(Sender: TObject);
begin
  if GridNF.RowCount > 1 then
    GridNF.RemoveRows(GridNF.Row, 1);
end;

procedure TFNf.ClinkClick(Sender: TObject);
begin

  if ambiente = '2' then
    HlinkNavigateString(nil,
      'http://homologacao.nfe.fazenda.sp.gov.br/ConsultaNFe/consulta/publica/ConsultarNFe.aspx')
  else
    HlinkNavigateString(nil,
      'https://nfe.fazenda.sp.gov.br/ConsultaNFe/consulta/publica/ConsultarNFe.aspx');
end;

procedure TFNf.BTEnviarEnter(Sender: TObject);
begin
  BTEnviar.ButtonColor := $00E2F5FE;
  BTEnviar.ButtonColor1 := clGray;
end;

procedure TFNf.BTEnviarExit(Sender: TObject);
begin
  BTEnviar.ButtonColor := $00CACACA;
  BTEnviar.ButtonColor1 := $00CACACA;
end;

procedure TFNf.BTNFClienteClick(Sender: TObject);
begin
  PNFCliente.Visible := true;
  ENF.SetFocus;
end;

procedure TFNf.BTFecharClick(Sender: TObject);
begin
  PNFCliente.Visible := False;
  EOs.SetFocus;
end;

procedure TFNf.BTCancelarClick(Sender: TObject);
var
  idLote, vAux: String;
var
  arquivo: TextFile;
begin
  with Modulo do
  begin

    If (tipo = 'alterar') then
    begin
      ACBrNFe1.NotasFiscais.Clear;
      ACBrNFe1.NotasFiscais.LoadFromFile(LerCampoNf(ECodigo.Text, 'PATH_NFE'));
      if not(InputQuery('Cancelamento NFE', 'Digite uma justificativa', vAux))
        then
        exit;

      idLote := '1';

      ACBrNFe1.EventoNFe.Evento.Clear;
      ACBrNFe1.EventoNFe.idLote := strtoint(idLote);



      with ACBrNFe1.EventoNFe.Evento.Add do
      begin
        infEvento.dhEvento := now;
        infEvento.tpEvento := teCancelamento;
        infEvento.detEvento.xJust := vAux;
      end;

      ACBrNFe1.EnviarEvento(strtoint(idLote));

      AtualizarFlagNf(ECodigo.Text, 'C');

      AssignFile(arquivo, ACBrNFe1.Configuracoes.Arquivos.PathSalvar +
          'Amortrat_NFe.log');
      Append(arquivo);

      Writeln(arquivo,
        '---------------------------------------------------------------------------------------------------------------------------');
      Writeln(arquivo, 'Data do cancelamento [' + DateToStr(now) + ']');
      Writeln(arquivo, 'Log de envio da Nota Fiscal [' + ECodigo.Text + ']');
      Writeln(arquivo,
        'Dados da mensagem: ' + UTF8Encode
          (ACBrNFe1.WebServices.EnvEvento.RetWS));
      Writeln(arquivo,
        'Retorno WS: ' + UTF8Encode(ACBrNFe1.WebServices.EnvEvento.RetornoWS));

      Application.MessageBox(PChar(ACBrNFe1.WebServices.Retorno.XMsg),
        PChar('MENSAGEM DE RETORNO - CANCELAMENTO DA NFE' + ECodigo.Text),
        MB_Ok + MB_IconInformation);

      CloseFile(arquivo);

      BTOK2.click;
      ECodigo.Text;

    end;
  end;
end;

procedure TFNf.BTCartaCorrecaoClick(Sender: TObject);
var
  Chave, idLote, CNPJ, nSeqEvento, Correcao: string;
var
  arquivo: TextFile;
begin

  with Modulo do
  begin

    If (tipo = 'alterar') then
    begin

      ACBrNFe1.NotasFiscais.Clear;
      ACBrNFe1.NotasFiscais.LoadFromFile(LerCampoNf(ECodigo.Text, 'PATH_NFE'));

      // if not(InputQuery('Cancelamento NFE', 'Digite uma justificativa', vAux)) then
      // exit;

      idLote := '1';

      ACBrNFe1.EventoNFe.Evento.Clear;
      ACBrNFe1.EventoNFe.idLote := strtoint(idLote);

      Chave := Trim(OnlyNumber(LerCampoNf(ECodigo.Text, 'COD_NFE')));

      CNPJ := Copy(Chave, 7, 14);
      nSeqEvento := '1';

      Correcao :=
        'Correção a ser considerada, texto livre. A correção mais recente substitui as anteriores.';

      if not(InputQuery('WebServices Eventos: Carta de Correção',
          'Correção a ser considerada', Correcao)) then
        exit;

      ACBrNFe1.EventoNFe.Evento.Clear;
      // ACBrNFe1.EnvEvento.EnvEventoNFe..idLote := StrToInt(idLote) ;
      with ACBrNFe1.EventoNFe.Evento.Add do
      begin
        infEvento.chNFe := Chave;
        infEvento.CNPJ := CNPJ;
        infEvento.dhEvento := now;
        infEvento.tpEvento := teCCe;
        infEvento.nSeqEvento := strtoint(nSeqEvento);
        infEvento.detEvento.xCorrecao := Correcao;
      end;
      ACBrNFe1.EnviarEvento(strtoint(idLote));

      // TBNf.FindKey([ECodigo.text]);
      // TBNf.Edit;
      // TBNfFLG_ENVIADA.value := 'C';
      // TBNf.Post;

      AssignFile(arquivo, ACBrNFe1.Configuracoes.Arquivos.PathSalvar +
          'Amortrat_NFe.log');
      Append(arquivo);

      Writeln(arquivo,
        '---------------------------------------------------------------------------------------------------------------------------');
      Writeln(arquivo, 'Data do cancelamento [' + DateToStr(now) + ']');
      Writeln(arquivo, 'Log de envio da Nota Fiscal [' + ECodigo.Text + ']');
      Writeln(arquivo,
        'Dados da mensagem: ' + UTF8Encode
          (ACBrNFe1.WebServices.EnvEvento.RetWS));
      Writeln(arquivo,
        'Retorno WS: ' + UTF8Encode(ACBrNFe1.WebServices.EnvEvento.RetornoWS));

      Application.MessageBox(PChar(ACBrNFe1.WebServices.Retorno.XMsg),
        PChar('MENSAGEM DE RETORNO - CARTA DE CORRECAO DA NFE' +
            ECodigo.Text), MB_Ok + MB_IconInformation);

      CloseFile(arquivo);

      BTOK2.click;
      ECodigo.Text;

    end;
  end;
end;

procedure TFNf.BTEnviarClick(Sender: TObject);
begin

  enviaNfe;
  Limpar;
  if GarantirConexao then
  begin
    Modulo.NovaLeitura;
    ECodigo.Text := ProximoCodigoNf;
  end;
  ECodigo.SetFocus;

end;

procedure TFNf.GridCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
var
  idx: Integer;
begin
  try
    if ACol = 9 then
    begin
      ETotal.Value := 0;
      ETotalBenef.Value := 0;

      For idx := 1 to Grid.RowCount - 1 do
      begin
        if Grid.Cells[ACol, idx] <> '' then
        begin
          Grid.Cells[ACol, idx] := FormatFloat('#######0.00',
            StrToFloat(StringReplace(Grid.Cells[ACol, idx], '.', '',
                [rfReplaceAll, rfIgnoreCase])));
          ETotal.Value := ETotal.Value + StrToCurr(Grid.Cells[ACol, idx]);
          If Grid.Cells[4, idx] = ECFOP.Text then
            ETotalBenef.Value := ETotalBenef.Value + StrToCurr
              (Grid.Cells[ACol, idx]);
        end;
      end;
    end;

    if ACol = 8 then
    begin
      if Grid.Cells[ACol, ARow] <> '' then
      begin
        if Grid.Cells[ACol - 2, ARow] <> '' then
        begin
          Grid.Cells[ACol + 1, ARow] := FormatFloat('#######0.00',
            StrToFloat(StringReplace(Grid.Cells[ACol, ARow], '.', ',',
                [rfReplaceAll, rfIgnoreCase])) * StrToFloat
              (StringReplace(Grid.Cells[ACol - 2, ARow], '.', ',',
                [rfReplaceAll, rfIgnoreCase])));
          Grid.Cells[ACol, ARow] := FormatFloat('#######0.000000000',
            StrToFloat(StringReplace(Grid.Cells[ACol, ARow], '.', ',',
                [rfReplaceAll, rfIgnoreCase])));

          ETotal.Value := 0;
          ETotalBenef.Value := 0;

          For idx := 1 to Grid.RowCount - 1 do
          begin
            if Grid.Cells[ACol + 1, idx] <> '' then
            begin
              Grid.Cells[ACol + 1, idx] := FormatFloat('#######0.00',
                StrToFloat(StringReplace(Grid.Cells[ACol + 1, idx], '.', ',',
                    [rfReplaceAll, rfIgnoreCase])));
              ETotal.Value := ETotal.Value + StrToCurr
                (Grid.Cells[ACol + 1, idx]);
              If Grid.Cells[4, idx] = ECFOP.Text then
                ETotalBenef.Value := ETotalBenef.Value + StrToCurr
                  (Grid.Cells[ACol + 1, idx]);
            end;
          end;

        end
        else
          Grid.Cells[ACol, ARow] := FormatFloat('#######0.000000000',
            StrToFloat(StringReplace(Grid.Cells[ACol, ARow], '.', ',',
                [rfReplaceAll, rfIgnoreCase])));
      end;
    end;

  Except
    ShowMessage('Atencao: O valor ' + Grid.Cells[ACol,
      ARow] + ' nao é válido.');
    Grid.Cells[ACol, ARow] := '';
    ETotal.Value := 0;
    ETotalBenef.Value := 0;

    For idx := 1 to Grid.RowCount - 1 do
    begin
      if Grid.Cells[ACol, idx] <> '' then
      begin
        Grid.Cells[ACol, idx] := FormatFloat('#######0.00',
          StrToCurr(Grid.Cells[ACol, idx]));
        ETotal.Value := ETotal.Value + StrToCurr(Grid.Cells[ACol, idx]);
        If Grid.Cells[3, idx] = ECFOP.Text then
          ETotalBenef.Value := ETotalBenef.Value + StrToCurr
            (Grid.Cells[ACol, idx]);
      end;
    end;
  end;

end;

procedure TFNf.FormCreate(Sender: TObject);
var
  caminho, senha, formaEmissao, ufWebService, pathNfe, pathSchema, logoDanfe,
    raveFile, aliqICMS: String;
  Ok: Boolean;
begin
  { Recuperando as informacoes para ACBRnfe1.
    'Select * from Config' -> tb_config; os TField persistentes sairam, o
    acesso e por FieldByName. EAliqICMS e TCurrencyEdit: mantido o StrToCurr
    sobre o texto de VLR_CONFIG (a coluna e varchar, nao numerica). }
  if not GarantirConexao then Exit;

  QNF_Config.close;
  QNF_Config.SQL.Clear;
  QNF_Config.SQL.Text := 'SELECT COD_CONFIG, VLR_CONFIG FROM tb_config';
  QNF_Config.Open;

  If not QNF_Config.Eof then
    repeat
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 1 then
        caminho := QNF_Config.FieldByName('VLR_CONFIG').AsString;
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 2 then
        senha := QNF_Config.FieldByName('VLR_CONFIG').AsString;
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 3 then
        formaEmissao := QNF_Config.FieldByName('VLR_CONFIG').AsString;
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 4 then
        ambiente := QNF_Config.FieldByName('VLR_CONFIG').AsString;
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 5 then
        ufWebService := QNF_Config.FieldByName('VLR_CONFIG').AsString;
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 14 then
        pathNfe := QNF_Config.FieldByName('VLR_CONFIG').AsString;
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 15 then
        pathSchema := QNF_Config.FieldByName('VLR_CONFIG').AsString;
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 16 then
        logoDanfe := QNF_Config.FieldByName('VLR_CONFIG').AsString;
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 17 then
        raveFile := QNF_Config.FieldByName('VLR_CONFIG').AsString;
      If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 18 then
        EAliqICMS.Value := StrToCurr(QNF_Config.FieldByName('VLR_CONFIG').AsString);

      QNF_Config.Next
    until QNF_Config.Eof;

  QNF_Config.Close;
  CarregarClientesCombo;   { alimenta o EFantasia (era lookup BDE) }

    ACBrNFe1.Configuracoes.Certificados.ArquivoPFX := caminho;
   ACBrNFe1.Configuracoes.Certificados.Senha := senha;
  // ACBrNFe1.Configuracoes.Geral.Salvar := True;
  ACBrNFe1.Configuracoes.Geral.formaEmissao := StrToTpEmis(Ok, formaEmissao);
  ACBrNFe1.Configuracoes.WebServices.UF := ufWebService;
  ACBrNFe1.Configuracoes.WebServices.ambiente := StrToTpAmb(Ok, ambiente);
  //ACBrNFe1.Configuracoes.Certificados.NumeroSerie := '02415d198c9b5e2bbc7986fec5743ff8';

  // ACBrNFe1.Configuracoes.Arquivos.PathCan := pathNfe;
  // ACBrNFe1.Configuracoes.Arquivos.PathDPEC := pathNfe;
  ACBrNFe1.Configuracoes.Arquivos.Salvar := true;
  ACBrNFe1.Configuracoes.Arquivos.SalvarEvento := False;
  ACBrNFe1.Configuracoes.Arquivos.PathInu := pathNfe;
  ACBrNFe1.Configuracoes.Arquivos.pathNfe := pathNfe;
  ACBrNFe1.Configuracoes.Arquivos.PathSalvar := pathNfe + '\Log';
  ACBrNFe1.Configuracoes.Arquivos.PathSchemas := pathSchema;

  ACBrNFe1.DANFE.TipoDANFE := tiRetrato;
  ACBrNFe1.DANFE.Logo := logoDanfe;
  ACBrNFe1.DANFE.PathPDF := pathNfe;

end;

procedure TFNf.ECSTEnter(Sender: TObject);
begin
  ECST.Color := $00E2F5FE;
  ECST.Font.Color := clNavy;
  ECST.Font.style := [fsBold];

end;

procedure TFNf.ECSTExit(Sender: TObject);
begin
  ECST.Color := clWhite;
  ECST.Font.Color := clBlack;
  ECST.Font.style := [];

end;

procedure TFNf.ECFOPRetornoEnter(Sender: TObject);
begin
  ECFOPRetorno.Color := $00E2F5FE;
  ECFOPRetorno.Font.Color := clNavy;
  ECFOPRetorno.Font.style := [fsBold];

end;

procedure TFNf.ECFOPRetornoExit(Sender: TObject);
begin
  ECFOPRetorno.Color := clWhite;
  ECFOPRetorno.Font.Color := clBlack;
  ECFOPRetorno.Font.style := [];

end;

procedure TFNf.ECSTRetornoEnter(Sender: TObject);
begin
  ECSTRetorno.Color := $00E2F5FE;
  ECSTRetorno.Font.Color := clNavy;
  ECSTRetorno.Font.style := [fsBold];

end;

procedure TFNf.ECSTRetornoExit(Sender: TObject);
begin
  ECSTRetorno.Color := clWhite;
  ECSTRetorno.Font.Color := clBlack;
  ECSTRetorno.Font.style := [];

end;

procedure TFNf.BTEmailClick(Sender: TObject);
var
  i: Integer;
  CC: Tstrings;
  Mensagem: Tstrings;
  host, port, user, pass, destinatario: String;
begin

  with Modulo do
  begin

    If (tipo = 'alterar') then
    begin
      ACBrNFe1.NotasFiscais.Clear;
      ACBrNFe1.NotasFiscais.LoadFromFile(LerCampoNf(ECodigo.Text, 'PATH_NFE'));
      { if ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.tpEmis = teDPEC then
        begin
        ACBrNFe1.WebServices.ConsultaDPEC.NFeChave := ACBrNFe1.NotasFiscais.Items[0].NFe.infNFe.ID;
        ACBrNFe1.WebServices.ConsultaDPEC.Executar;
        ACBrNFe1.DANFE.ProtocoloNFe := ACBrNFe1.WebServices.ConsultaDPEC.nRegDPEC +' '+ DateTimeToStr(ACBrNFe1.WebServices.ConsultaDPEC.dhRegDPEC);
        end; }

      CarregarCliente(ECliente.Text);
      ACBrNFe1.NotasFiscais.GerarNFe;
      // ACBrNFe1.Enviar(1,True);

      Mensagem := TstringList.Create;
      Mensagem.Add(
        'Este e-mail refere-se à Nota Fiscal Eletronica Nacional emitida para:'
        );
      Mensagem.Add('');
      Mensagem.Add('Razao Social...:' + QCli.FieldByName('RAZAO').AsString);
      Mensagem.Add('CNPJ...........:' + QCli.FieldByName('CNPJ').AsString);
      Mensagem.Add('');
      Mensagem.Add(
        'Para verificar a autorização do SEFAZ para esta NF-e, consulte o site:'
        );
      Mensagem.Add('https://nfe.fazenda.sp.gov.br/ConsultaNFe/consulta/publica/ConsultarNFe.aspx');
      Mensagem.Add('');
      Mensagem.Add('Chave de acesso: ' + LerCampoNf(ECodigo.Text, 'COD_NFE'));
      Mensagem.Add('');
      Mensagem.Add(
        'O DANFE referente à NF-e acima mencionada encontra-se em anexo.');
      Mensagem.Add('');
      Mensagem.Add('');
      Mensagem.Add(
        'Este e-mail foi enviado automaticamente pelo Sistema AMORTRAT.');

      CC := TstringList.Create;

      QNF_Config.close;
      QNF_Config.SQL.Clear;
      QNF_Config.SQL.Text := 'SELECT COD_CONFIG, VLR_CONFIG FROM tb_config';
      QNF_Config.Open;

      If not QNF_Config.Eof then
        repeat
          If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 6 then
            host := QNF_Config.FieldByName('VLR_CONFIG').AsString;
          If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 7 then
            port := QNF_Config.FieldByName('VLR_CONFIG').AsString;
          If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 8 then
            user := QNF_Config.FieldByName('VLR_CONFIG').AsString;
          If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 9 then
            pass := QNF_Config.FieldByName('VLR_CONFIG').AsString;
          QNF_Config.Next
        until QNF_Config.Eof;

        QEMail.close;
      QEMail.SQL.Clear;
      QEMail.SQL.Text :=
        'Select * from email where COD_CLIENTE = "' + ECliente.Text + '"';
      QEMail.Open;

      i := 0;

      If not QEMail.Eof then
        repeat
          If QEMail.FieldByName('FLG_CQ').AsString <> 'X' then
          begin
            If i = 0 then
              destinatario := QEMail.FieldByName('EMAIL').AsString
            else
              CC.Add(QEMail.FieldByName('EMAIL').AsString);
            i := i + 1;
          end;
          QEMail.Next
        until QEMail.Eof;

        try

          ACBrMail1.host := host;
          ACBrMail1.port := port;
          ACBrMail1.Username := user;
          ACBrMail1.From := user;
          ACBrMail1.Password := pass;
          ACBrMail1.From := user;
          ACBrMail1.SetSSL := true; // SSL - ConexÃ£o Segura
          ACBrMail1.SetTLS := false; // Auto TLS
          ACBrMail1.ReadingConfirmation := False;
          // Pede confirmaÃ§Ã£o de leitura do email
          ACBrMail1.UseThread := false; // Aguarda Envio do Email(nÃ£o usa thread)
          ACBrMail1.FromName := 'Financeiro AMORTRAT';

          ACBrNFe1.NotasFiscais.Items[0].EnviarEmail('nf.amortrat@gmail.com',
            '[AMORTRAT] Envio da Nota Fiscal Eletronica Nacional - NF: ' +
              ECodigo.Text, Mensagem, true // Enviar PDF junto
              , CC // Lista com emails que serÃ£o enviado cÃ³pias - TStrings
              , nil); // Lista de anexos - TStrings
        finally
          CC.Free;
          Mensagem.Free;
        end;

    end;
  end;

end;

procedure TFNf.BTEmailEnter(Sender: TObject);
begin
  BTEmail.ButtonColor := $00E2F5FE;
  BTEmail.ButtonColor1 := clGray;

end;

procedure TFNf.BTEmailExit(Sender: TObject);
begin
  BTEmail.ButtonColor := $00CACACA;
  BTEmail.ButtonColor1 := $00CACACA;

end;

procedure TFNf.BTRecuperarEnter(Sender: TObject);
begin
  BTRecuperar.ButtonColor := $00E2F5FE;
  BTRecuperar.ButtonColor1 := clGray;
end;

procedure TFNf.BTRecuperarExit(Sender: TObject);
begin
  BTRecuperar.ButtonColor := $00CACACA;
  BTRecuperar.ButtonColor1 := $00CACACA;
end;

// LimpaCNPJ (retira máscaras do CNPJ)
// ------------------------------------
Function LimpaCNPJ(CNPJ: string): string;
begin
  result := StringReplace(StringReplace(StringReplace(CNPJ, '.', '',
        [rfReplaceAll]), '-', '', [rfReplaceAll]), '/', '', [rfReplaceAll]);
end;

// Alltrim --------------------------
Function Alltrim(Text: string): string;
begin
  while pos(' ', Text) > 0 do
    Delete(Text, pos(' ', Text), 1);
  result := Text;
End;

// StrZero (Preenche com zeros à esquerda)
// ------------------------------------------------------
Function StrZero(Num: Real; Zeros, Deci: Integer): string;
var
  tam, z: Integer;
  res, zer: string;
begin
  str(Num: Zeros: Deci, res);
  res := Alltrim(res);
  tam := Length(res);
  zer := '';
  for z := 1 to (Zeros - tam) do
    zer := zer + '0';
  result := zer + res
end;

function Modulo11(Numero: String): String;
var
  i, j, k: Integer;
  Soma: Integer;
  Digito: Integer;
  CNPJ: Boolean;
begin
  result := '';
  Try
    Soma := 0;
    k := 2;
    for i := Length(Numero) downto 1 do
    begin
      Soma := Soma + (strtoint(Numero[i]) * k);
      inc(k);
      if k > 9 then
        k := 2;
    end;
    Digito := 11 - Soma mod 11;
    if Digito >= 10 then
      Digito := 0;
    result := result + Chr(Digito + Ord('0'));
  except
    result := 'X';
  end;
end;

// MontaChaveAcesso
// (codigo alterado em 19/11/08 para compor a chave no formato da versão 1.10 do laioute)
// -------------------
// Parametros:
// codUF - codigo da Unidade e Federação do Município de acordo tabela IBGE.
// dtEmissaso - data de emissão da nota fiscal
// CNPJ - codigo CNPJ do emitente
// Modelo - Modelo da Nota Fiscal NF-e (55)
// Serie - codigo de serie da NFe
// NumeroNF - Número da Nota Fiscal
// Result = Chave de acesso
//
Function MontaChaveAcessoNFe_v110(codUF: Integer; dtEmissao: TDateTime;
  CNPJ: string; Modelo, serie, NumeroNF: Integer; CodNum: Integer): string;
var
  emissao: string[10];
  Chave: string;
  CodigoNumerico: Integer;
begin
  emissao := FormatDateTime('DD/MM/YY', dtEmissao);

  // Essa parte do código gera o Código Numérico (Aleatório)
  // para que funcione inclua a unit "Math" na cláusule Uses.
  Randomize;
  // CodigoNumerico := Random(99999999);
  CodigoNumerico := CodNum;

  Chave := inttostr(codUF) + Copy(emissao, 7, 2) + Copy(emissao, 4, 2)
    + LimpaCNPJ(CNPJ) + StrZero(Modelo, 2, 0) + StrZero(serie, 3, 0) + StrZero
    (NumeroNF, 9, 0) + StrZero(CodigoNumerico, 9, 0);

  result := Chave + Modulo11(Chave);

end;


function TFNf.ArredondaFinal5(Valor: Double): Double;
var
  Valor3Casas: Int64;
  TerceiroDigito: Integer;
begin
  // 1. Multiplica por 1000 e TRUNCA.
  // Isso arranca a 4ª e 5ª casas decimais sem arredondar nada.
  // Ex: 16.595652 * 1000 = 16595.652 -> O Trunc transforma em 16595 exato.
  Valor3Casas := Trunc(Valor * 1000);

  // 2. Pega apenas o último dígito (que é a nossa 3ª casa decimal intacta)
  TerceiroDigito := Valor3Casas mod 10;

  // 3. Aplica a regra cega do final 5
  if TerceiroDigito = 5 then
    // Se for 5, trunca na 2ª casa decimal (16.59)
    Result := Trunc(Valor * 100) / 100
  else
    // Se for qualquer outra coisa (como o 9 do item 3), arredonda normal (7.44)
    Result := SimpleRoundTo(Valor, -2);
end;

procedure TFNf.BTRecuperarClick(Sender: TObject);
var
  vChave: String;
  dirName: String;
begin
  If Application.MessageBox(PChar(
      'Deseja realmente recuperar o XML desta Nota Fiscal?'),
    PChar('Confirmação para recuperação'),
    MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) = IdYes then
  begin

    with Modulo do
    begin
      vChave := MontaChaveAcessoNFe_v110(35, EDataE.date, '04989425000126', 55,
        001, strtoint(ECodigo.Text),
        strtoint('1' + StrZero(strtoint('10'+ECodigo.Text), 8, 0)));

      ShowMessage('Chave a ser recuperada: ' + vChave);

      HlinkNavigateString(nil,
        'https://nfe.fazenda.sp.gov.br/ConsultaNFe/consulta/publica/ConsultarNFe.aspx');
      Clipboard.AsText := vChave;
      // salvando

      // Create a new directory
      dirName := ACBrNFe1.Configuracoes.Arquivos.GetPathNFe(EDataE.date);

      // ACBrNFe1.NotasFiscais.SaveToFile(dirName + '\' + vChave + '-nfe.xml',false);

      ACBrNFe1.NotasFiscais.GravarXML(dirName + '\' + vChave + '-nfe.xml');

      If (Application.MessageBox(PChar(
            'O arquivo XML foi salvo corretamente no diretorio ' + dirName +
              '\' + vChave + '-nfe.xml?'),
          PChar('Confirmação para recuperação'),
          MB_YESNO + MB_IconQuestion + MB_DEFBUTTON2) = IdYes) and
        (fileexists(dirName + '\' + vChave + '-nfe.xml')) then
      begin
        AtualizarNfEnviada(ECodigo.Text, vChave,
                           dirName + '\' + vChave + '-nfe.xml');

        ShowMessage('Nota ajustada com sucesso!');

        BTOK2.click;

      end
      else
      begin
        ShowMessage(
          'A nota não foi ajustada. Tente realizar o processo novamente!');
      end;

    end;
  end;

end;

procedure TFNf.ECredEnter(Sender: TObject);
begin
  ECred.Color := $00E2F5FE;
  ECred.Font.Color := clNavy;
  ECred.Font.style := [fsBold];
end;

procedure TFNf.ECredExit(Sender: TObject);
begin
  ECred.Color := clWhite;
  ECred.Font.Color := clBlack;
  ECred.Font.style := [];
end;

procedure TFNf.ETotalBenefChange(Sender: TObject);
begin
  ECred.Value := ETotalBenef.Value * EAliqICMS.Value / 100;

  EInfAdic.Text :=
    'ICMS suspenso conforme Art. 402  §1°  inciso II do RICMS decreto 45490/2000,IPI suspenso conforme artigo 42 inciso VII do RIPI' + ' decreto 02637/1998. Empresa optante pelo Simples Nacional, Lei Complementar 2006. Este doc. não transfere crédito de impostos IPI/ISS.';

  // if (ECliente.Text = '0208') and (OpDevolucao.Checked = false) then
  EInfAdic.Text := EInfAdic.Text +
    ' Permite o aproveitamento de créd. de R$ ' + FormatCurr('##0.00',
    ECred.Value) + ' correspondente a aliquota de ' + EAliqICMS.Text +
    '% nos termos da lei complementar nº 123, de 2006 (art. 23, §§ 1 º , 2 º e 6 º , art. 26, inciso I e § 4 º )';

end;

procedure TFNf.EPlacaEnter(Sender: TObject);
begin
  EPlaca.Color := $00E2F5FE;
  EPlaca.Font.Color := clNavy;
  EPlaca.Font.style := [fsBold];
end;

procedure TFNf.EPlacaExit(Sender: TObject);
begin
  EPlaca.Color := clWhite;
  EPlaca.Font.Color := clBlack;
  EPlaca.Font.style := [];

end;

procedure TFNf.EestadoEnter(Sender: TObject);
begin
  Eestado.Color := $00E2F5FE;
  Eestado.Font.Color := clNavy;

end;

procedure TFNf.EestadoExit(Sender: TObject);
begin
  Eestado.Color := clWhite;
  Eestado.Font.Color := clBlack;
  Eestado.Font.style := [];

end;

procedure TFNf.opPrazoClick(Sender: TObject);
begin
  EDuplicata.date := ProximoDiaUtil(SomaMes(EDataE.date, 1, true));
  Opt30.enabled := true;
  Opt45.enabled := true;
  Opt60.enabled := true;
end;


procedure TFNf.opVistaClick(Sender: TObject);
begin
  EDuplicata.date := EDataE.date;
  Opt30.checked := False;
  Opt45.checked := False;
  Opt60.checked := False;
  Opt30.Enabled := False;
  Opt45.Enabled := False;
  Opt60.Enabled := False;

  end;

procedure TFNf.OpDevolucaoClick(Sender: TObject);
begin
  ENatureza.Text := 'RETORNO DE EMBALAGEM';
end;

procedure TFNf.OpNormalClick(Sender: TObject);
begin
  ENatureza.Text := 'RETORNO DE INDUSTRIALIZAÇÃO';
end;

end.
