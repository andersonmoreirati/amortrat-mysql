unit UModulo;

interface

uses
  SysUtils, Windows, Registry, Classes, ImgList, Controls, DB, DBTables, BDE,
  DBClient, RxQuery, FixBDE4GbBug, Dialogs,
  ZConnection, ZDataset, IniFiles;


type
  TModulo = class(TDataModule)
    imagens: TImageList;
    DSPecas: TDataSource;
    TBPecas: TTable;
    DSOs: TDataSource;
    TBOs: TTable;
    TBOsCODIGO: TStringField;
    TBOsPROCESSO: TStringField;
    TBOsCLIENTE: TStringField;
    TBOsDATA: TDateField;
    TBOsQUANTIDADE: TFloatField;
    TBOsEMBALAGEM: TStringField;
    TBOsPESO: TFloatField;
    TBOsOBS: TStringField;
    TBOsNOTA: TStringField;
    DSOs_Finalizados: TDataSource;
    TBOs_Finalizados: TTable;
    TBOsFINALIZADA: TBooleanField;
    TBOsPECA: TStringField;
    TBProc: TTable;
    DSProc: TDataSource;
    TBProcCODIGO: TStringField;
    TBProcPROCESSO: TStringField;
    TBProcLINHA1: TStringField;
    TBProcLINHA2: TStringField;
    TBProcLINHA3: TStringField;
    TBProcLINHA4: TStringField;
    TBProcLINHA5: TStringField;
    TBProcLINHA6: TStringField;
    TBProcLINHA7: TStringField;
    TBProcOBS: TStringField;
    TBPecasCOD_CLI: TStringField;
    TBPecasCODIGO: TStringField;
    TBPecasCOD_PROC: TStringField;
    TBPecasDESCRICAO: TStringField;
    TBPecasMATERIAL: TStringField;
    TBPecasPRECO: TCurrencyField;
    TBPecasDUREZA: TStringField;
    TBPecasOBS: TStringField;
    TBNf: TTable;
    DSNf: TDataSource;
    TBUsuario: TTable;
    DSUsuario: TDataSource;
    TBUsuarioLOGIN: TStringField;
    TBUsuarioSENHA: TStringField;
    TBUsuarioPRECO: TBooleanField;
    TBUsuarioUSUARIO: TBooleanField;
    TBUsuarioCLIENTE: TBooleanField;
    TBUsuarioNF: TBooleanField;
    TBUsuarioRELATORIOS: TBooleanField;
    TBOs_FinalizadosCODIGO: TStringField;
    TBOs_FinalizadosNOTA: TStringField;
    TBOs_FinalizadosDATA_FIM: TDateField;
    TBOs_FinalizadosVALOR: TCurrencyField;
    TBOs_FinalizadosRETRABALHO: TBooleanField;
    TBOs_FinalizadosDEVOLUCAO: TBooleanField;
    TBOs_FinalizadosFORNO: TSmallintField;
    TBNf_Itens: TTable;
    DSNF_Itens: TDataSource;
    TBNfCODIGO: TStringField;
    TBNfCOD_CLI: TStringField;
    TBNfDATAE: TDateField;
    TBNfVALOR: TCurrencyField;
    TBNfTIPO: TStringField;
    TBNfNATUREZA: TStringField;
    TBNfCFOP: TStringField;
    TBNfDATAS: TDateField;
    TBNfTIPO_RETORNO: TStringField;
    TBNfTIPO_PAGAMENTO: TStringField;
    TBNfICMS_BASE: TCurrencyField;
    TBNfNOME_TRANSPORTADORA: TStringField;
    TBNfQUANTIDADE: TFloatField;
    TBNfESPECIE: TStringField;
    TBNfPESOL: TFloatField;
    TBNfTIPO_FRETE: TStringField;
    TBNfPESOB: TFloatField;
    TBNf_Ref: TTable;
    TBNf_RefCOD_NF: TStringField;
    TBNf_RefDATA_NF_CLIENTE: TDateField;
    TBNf_RefVALOR_NF_CLIENTE: TCurrencyField;
    TBNf_RefFLAG_NFE: TStringField;
    TBNf_ItensCOD_NF: TStringField;
    TBNf_ItensCOD_OS: TStringField;
    TBNfCOD_NFE: TStringField;
    TBNfPATH_NFE: TStringField;
    TBConfig: TTable;
    TBConfigCOD_CONFIG: TIntegerField;
    TBConfigDSC_CONFIG: TStringField;
    TBConfigVLR_CONFIG: TStringField;
    TBNfFLG_ENVIADA: TStringField;
    TBNf_RefCOD_NF_CLIENTE: TStringField;
    TBEmail: TTable;
    TBEmailCOD_CLIENTE: TStringField;
    TBEmailEMAIL: TStringField;
    TBNf_ItensCODIGO: TStringField;
    TBNf_ItensDESCRICAO: TStringField;
    TBNf_ItensCFOP: TStringField;
    TBNf_ItensCST: TStringField;
    TBNf_ItensUNIDADE: TStringField;
    TBNf_ItensPRECO_TOTAL: TCurrencyField;
    TBNfCFOP_RETORNO: TStringField;
    TBNfCST: TStringField;
    TBNfCST_RETORNO: TStringField;
    TBNfTOTAL_NOTA: TCurrencyField;
    TBNf_ItensNCM: TStringField;
    TBEmailFLG_CQ: TStringField;
    TBEquipamentos: TTable;
    DSEquipamentos: TDataSource;
    TBEquipPeca: TTable;
    DSEquipPeca: TDataSource;
    TBEquipPecaCODIGO_EQUIP: TStringField;
    TBEquipPecaCODIGO_CLI: TStringField;
    TBEquipPecaCODIGO_PECA: TStringField;
    TBEquipPecaVL_PRODUTIVIDADE: TFloatField;
    TBPecasCOD_PECA_CLI: TStringField;
    TBApontamento: TTable;
    DSApontamento: TDataSource;
    TBPecasITEM_SEG: TBooleanField;
    TBPecasREVISAO: TStringField;
    TBPecasDATA_REVISAO: TDateField;
    TBFuncionario: TTable;
    DSFuncionario: TDataSource;
    TBOsLOTE: TStringField;
    TBPecasANALISE_DET: TBooleanField;
    TBPecasMARCHA: TStringField;
    TBNfTIPO_EMISSAO: TStringField;
    TBNfPLACA: TStringField;
    TBNfUF_PLACA: TStringField;
    TBFornec: TTable;
    TBNf_ItensCEST: TStringField;
    VendasGerais: TRxQuery;
    VendasGeraisCLIENTE: TStringField;
    VendasGeraisCODIGO_CLIENTE: TStringField;
    VendasGeraisCODIGO_OS: TStringField;
    VendasGeraisDATA_ABERTURA: TDateField;
    VendasGeraisDATA_FIM: TDateField;
    VendasGeraisVALOR: TCurrencyField;
    VendasGeraisQUANTIDADE: TFloatField;
    VendasGeraisPESO: TFloatField;
    VendasGeraisCODIGO_PECA: TStringField;
    VendasGeraisPECA: TStringField;
    VendasGeraisPRECO_KG: TCurrencyField;
    VendasGeraisPRECO_COBRADO: TCurrencyField;
    VendasGeraisMES_OS_FIM: TFloatField;
    VendasGeraisANO_OS_FIM: TFloatField;
    OrdensNaoFilalizadas: TRxQuery;
    OrdensNaoFilalizadasCLIENTE: TStringField;
    OrdensNaoFilalizadasCODIGO_CLIENTE: TStringField;
    OrdensNaoFilalizadasCODIGO: TStringField;
    OrdensNaoFilalizadasDATA_ABERTURA: TDateField;
    OrdensNaoFilalizadasQUANTIDADE: TFloatField;
    OrdensNaoFilalizadasPESO: TFloatField;
    OrdensNaoFilalizadasCODIGO_PECA: TStringField;
    OrdensNaoFilalizadasPECA: TStringField;
    OrdensNaoFilalizadasPRECO_KG: TCurrencyField;
    OrdensNaoFilalizadasMES_OS_ABERTURA: TFloatField;
    OrdensNaoFilalizadasANO_OS_ABERTURA: TFloatField;
    OrdensNaoFilalizadasvalor_estimado: TCurrencyField;
    PesoTotal: TRxQuery;
    PesoTotaldata: TDateField;
    PesoTotalpeso: TFloatField;
    TBClientes: TTable;
    TBClientesRAZAO: TStringField;
    TBClientesFANTASIA: TStringField;
    TBClientesCNPJ: TStringField;
    TBClientesENDERECO: TStringField;
    TBClientesBAIRRO: TStringField;
    TBClientesCIDADE: TStringField;
    TBClientesESTADO: TStringField;
    TBClientesCEP: TStringField;
    TBClientesINSC_EST: TStringField;
    TBClientesTEL1: TStringField;
    TBClientesTEL2: TStringField;
    TBClientesRESPONSAVEL: TStringField;
    TBClientesCARGO: TStringField;
    TBClientesCODIGO: TStringField;
    TBClientesEMAIL: TStringField;
    TBClientesHOME: TStringField;
    TBClientesINATIVO: TBooleanField;
    TBClientesCOD_MUNICIPIO: TStringField;
    TBClientesNUMERO: TStringField;
    TBClientesLT_MINIMO: TCurrencyField;
    DSClientes: TDataSource;
    TBNfTIPO_45: TStringField;
    TBNfTIPO_30: TStringField;
    TBNfTIPO_60: TStringField;
    DSTerceirizadas: TDataSource;
    TBOSTerceirizadas: TTable;
    TBOSTerceirizadasCODIGO: TStringField;
    TBOSTerceirizadasCOD_CLI: TStringField;
    TBOSTerceirizadasCOD_PROC: TStringField;
    TBOSTerceirizadasDATA_ENVIO: TDateField;
    TBOSTerceirizadasDATA_RETORNO: TDateField;
    TBOSTerceirizadasOBS: TStringField;
    TBPecasFIGURA: TStringField;
    TBNf_ItensQUANTIDADE: TFloatField;
    TBNf_ItensPRECO_UNITARIO: TFloatField;
    DSFornec: TDataSource;
    TBFornecCODIGO: TStringField;
    TBFornecRAZAO: TStringField;
    TBFornecFANTASIA: TStringField;
    TBFornecCNPJ: TStringField;
    TBFornecENDERECO: TStringField;
    TBFornecBAIRRO: TStringField;
    TBFornecCIDADE: TStringField;
    TBFornecESTADO: TStringField;
    TBFornecCEP: TStringField;
    TBFornecINSC_EST: TStringField;
    TBFornecTEL1: TStringField;
    TBFornecTEL2: TStringField;
    TBFornecRESPONSAVEL: TStringField;
    TBFornecCARGO: TStringField;
    TBFornecEMAIL: TStringField;
    TBFornecHOME: TStringField;
    TBFornecINATIVO: TBooleanField;
    TBFornecCOD_MUNICIPIO: TStringField;
    TBFornecNUMERO: TStringField;
    TBFornecLT_MINIMO: TCurrencyField;
    TBOsFORNECEDOR: TStringField;
    TBOsDATA_ENVIO: TDateField;
    TBOsDATA_RETORNO: TDateField;
    TBOsFLG_RETORNO: TStringField;
    TBOsVALOR_RETORNO: TCurrencyField;
    TBOsOBS_FORNECEDOR: TStringField;
    TBOsPROCESSO_FORNECEDOR: TStringField;
    TBOsURGENCIA: TStringField;
    DSEvento: TDataSource;
    TBEquipamentosCODIGO: TStringField;
    TBEquipamentosDESCRICAO: TStringField;
    TBEvento: TTable;
    TBEventoCODIGO: TStringField;
    TBEventoEVENTO: TStringField;
    TBApontamentoCOD_APONTAMENTO: TStringField;
    TBApontamentoCOD_EQUIPAMENTO: TStringField;
    TBApontamentoCOD_FUNCIONARIO: TStringField;
    TBApontamentoOS: TStringField;
    TBApontamentoDATA_INICIO: TDateTimeField;
    TBApontamentoDATA_FIM: TDateTimeField;
    TBApontamentoOBS: TStringField;
    TBApontamentoCOD_EVENTO: TStringField;
    TBApontamentoPESO: TFloatField;
    TBFuncionarioCODIGO: TStringField;
    TBFuncionarioNOME: TStringField;
    TBFuncionarioFUNCAO: TStringField;
    OrdensDoAno: TRxQuery;
    DataSource1: TDataSource;
    OrdensFinalizadasDoAno: TRxQuery;
    procedure TBClientesAfterPost(DataSet: TDataSet);
    procedure TBPecasAfterPost(DataSet: TDataSet);
    procedure TBOs_FinalizadosAfterPost(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure TBOsAfterPost(DataSet: TDataSet);
    procedure TBNfAfterPost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Conexão MySQL — usada por todos os módulos migrados }
    ZConexao: TZConnection;

    { tb_usuario — dupla convivência: BDE intacto, MySQL ao lado }
    ZTBUsuario: TZTable;
    ZDSUsuario: TDataSource;

    { LOGIN do usuário autenticado, preenchido pelo ULogin após validar a senha.
      Antes os forms descobriam quem estava logado lendo TBUsuarioLOGIN.Value —
      o cursor BDE de tb_usuario, que precisava estar posicionado no registro
      certo. Sem cursor persistente, o login passa a viver aqui. }
    UsuarioLogado: string;

    procedure NovaLeitura;

    function RetZero(ZEROS:string;QUANT:integer):String;
    function Number(Key: Char): char;
    function MapeamentosDisponiveis():string;
    procedure ConectarRede;
    function Getcomputer : string;
  end;

var
  Modulo: TModulo;

implementation


function TModulo.Number(Key: Char): char;
begin
  case Key of
    '0'..'9': Number := Key;
    chr(08): Number := Key;
  else Number := chr(0)
  end;
end;

procedure TModulo.NovaLeitura;
{ Encerra a transação de leitura em curso, para que a PRÓXIMA consulta enxergue
  os dados mais recentes.

  Por que isso é necessário: o InnoDB roda em REPEATABLE READ. O snapshot é
  criado na primeira leitura da transação e NÃO muda até haver commit — mesmo
  relendo a tabela. Verificado no servidor:

      transação abre e lê ......... 404 registros
      (outra conexão insere 1)
      relê na MESMA transação ..... 404   <-- snapshot preso
      COMMIT e lê ................. 405   <-- só aqui aparece

  Sintoma prático: emitir um relatório, cadastrar um cliente e reemitir o
  relatório — o novo cliente não aparecia até reiniciar o sistema.

  Chamar isto ANTES de reabrir datasets de consulta/relatório. É barato: se não
  houver transação aberta, não faz nada de custoso. }
begin
  if (ZConexao = nil) or (not ZConexao.Connected) then Exit;
  try
    if not ZConexao.AutoCommit then
    begin
      // havia transação explícita em aberto (ex.: gravação interrompida)
      ZConexao.Rollback;
      ZConexao.AutoCommit := True;
    end
    else
    begin
      // AutoCommit ligado: encerra o snapshot REPEATABLE READ do InnoDB.
      // ZeosLib 8.x rejeita Commit() direto em modo AutoCommit=True
      // (CheckNonAutoCommitMode lança EZDatabaseError).
      // Solução: StartTransaction emite BEGIN explícito e ajusta os contadores
      // internos; o Commit seguinte emite COMMIT e restaura AutoCommit=True.
      ZConexao.StartTransaction;
      ZConexao.Commit;
    end;
  except
    // Não deve mais chegar aqui; mantido como fallback defensivo.
    try ZConexao.AutoCommit := True; except end;
  end;
end;

function TModulo.RetZero(ZEROS:string;QUANT:integer):String;
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
{$R *.dfm}

procedure TModulo.TBClientesAfterPost(DataSet: TDataSet);
begin
   TBClientes.FlushBuffers;
   DBISaveChanges(TBClientes.Handle);
end;

procedure TModulo.TBPecasAfterPost(DataSet: TDataSet);
begin
   TBPecas.FlushBuffers;
   DBISaveChanges(TBPecas.Handle);
end;

procedure TModulo.TBOs_FinalizadosAfterPost(DataSet: TDataSet);
begin
   TBOS_Finalizados.FlushBuffers;
   DBISaveChanges(TBOS_Finalizados.Handle);
end;

procedure TModulo.DataModuleCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  // --- Conexão MySQL (fundação para migração progressiva) ---
  try
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'amortrat.ini');
    try
      ZConexao := TZConnection.Create(Self);
      ZConexao.Protocol  := 'mysql';
      ZConexao.HostName  := Ini.ReadString('BD', 'Host',    '');
      ZConexao.Port      := Ini.ReadInteger('BD', 'Porta',  3306);
      ZConexao.Database  := Ini.ReadString('BD', 'Banco',   '');
      ZConexao.User      := Ini.ReadString('BD', 'Usuario', '');
      ZConexao.Password  := Ini.ReadString('BD', 'Senha',   '');
      ZConexao.Properties.Values['codepage'] := 'utf8mb4';
      ZConexao.Properties.Values['usessl']   := 'false';
      ZConexao.Properties.Values['MYSQL_OPT_SSL_VERIFY_SERVER_CERT'] := 'FALSE';
      ZConexao.Properties.Values['MYSQL_OPT_RECONNECT'] := '1';  // reconexão automática se o servidor derrubar por inatividade
      ZConexao.LibraryLocation :=
        ExtractFilePath(ParamStr(0)) + 'libmysql.dll';
      ZConexao.Connected := True;
    finally
      Ini.Free;
    end;
  except
    on E: Exception do
      ShowMessage(
        'Aviso: não foi possível conectar ao MySQL.' + #13#10 +
        'Verifique o arquivo amortrat.ini.' + #13#10 + E.Message);
  end;

  // Tabelas MySQL — dupla convivência (BDE não é alterado)
  // Nota: ZTBUsuario é criado mas não ativado aqui; será aberto sob demanda.
  // TRxLookupEdit é BDE-only — não atribuímos LookupSource a ele.
  if (ZConexao <> nil) and ZConexao.Connected then
  try
    ZTBUsuario := TZTable.Create(Self);
    ZTBUsuario.Connection := ZConexao;
    ZTBUsuario.TableName  := 'tb_usuario';
    { Active := True propositalmente omitido aqui:
      TRxLookupEdit faz casts BDE-internos e causaria AV com TZTable.
      A autenticação usa TZQuery diretamente no BTEntrarClick. }

    ZDSUsuario := TDataSource.Create(Self);
    ZDSUsuario.DataSet := ZTBUsuario;
  except
    // falhou ao preparar ZTBUsuario — login continua por TZQuery
    FreeAndNil(ZDSUsuario);
    FreeAndNil(ZTBUsuario);
  end;

  // --- BDE (tabelas Paradox — sem alteração) ---
  TBClientes.DBSession.AddPassword('99866');
    TBFornec.DBSession.AddPassword('99866');
  TBPecas.DBSession.AddPassword('99866');
  TBOs.DBSession.AddPassword('99866');
  TBOs_Finalizados.DBSession.AddPassword('99866');
  TBNf.DBSession.AddPassword('99866');
  TBNf_Ref.DBSession.AddPassword('99866');
  TBNf_Itens.DBSession.AddPassword('99866');
  TBProc.DBSession.AddPassword('99866');
  TBUsuario.DBSession.AddPassword('99866');
  TBConfig.DBSession.AddPassword('99866');
  TBEmail.DBSession.AddPassword('99866');
  TBEquipamentos.DBSession.AddPassword('99866');
  TBEquipPeca.DBSession.AddPassword('99866');
  TBApontamento.DBSession.AddPassword('99866');
  TBFuncionario.DBSession.AddPassword('99866');
  VendasGerais.DBSession.AddPassword('99866');
  OrdensNaoFilalizadas.DBSession.AddPassword('99866');
  PesoTotal.DBSession.AddPassword('99866');
  TBClientes.Active := true;
  TBProc.Active := true;
  TBPecas.Active := true;
  TBOs.Active := true;
  TBOs_Finalizados.Active := true;
  TBNf.Active := true;
  TBNf_Ref.Active := true;
  TBNf_Itens.Active := true;
  TBUsuario.Active := true;
  TBConfig.Active := true;
  TBEmail.Active := true;
  TBFornec.Active := true;
  TBOSTerceirizadas.Active := true;


  TBFuncionario.Active := true;

  TBEquipamentos.Active := true;
 // TBEquipPeca.Active := true;
  TBApontamento.Active := true;
  TBEvento.Active := true;
end;

procedure TModulo.TBOsAfterPost(DataSet: TDataSet);
begin
   TBOS.FlushBuffers;
   DBISaveChanges(TBOS.Handle);
end;

procedure TModulo.TBNfAfterPost(DataSet: TDataSet);
begin
   TBNf.FlushBuffers;
   DBISaveChanges(TBNf.Handle);

end;

function TModulo.MapeamentosDisponiveis():string;
var
  I : Integer;
  Caminho, Drive : String;
  Tamanho : Cardinal;
begin
  SetLength(Caminho,255);
  Tamanho:=255;
  For I:=0 to 25 do
  begin
    Drive := Chr(Ord('A')+I)+':';
    if WNetGetConnection(PChar(Drive),PChar(Caminho),Tamanho) = NO_ERROR then
       MapeamentosDisponiveis := Caminho else MapeamentosDisponiveis := 'erro';
  end;
end;

procedure TModulo.ConectarRede;
var
  NRW: TNetResource;
begin
  with NRW do
  begin
  dwType := RESOURCETYPE_ANY;
  lpLocalName := 'F:';
  lpRemoteName := '\\producao\c';
  lpProvider := '';
  end;
  WNetAddConnection2(NRW, '', '', CONNECT_UPDATE_PROFILE);
end;


function TModulo.Getcomputer : string;
var
registro : tregistry;
begin
registro:=tregistry.create;
registro.RootKey:=HKEY_LOCAL_MACHINE;
registro.openkey('System\CurrentControlSet\Services\VXD\VNETSUP',false);
result:=registro.readstring('ComputerName');
end;



end.
