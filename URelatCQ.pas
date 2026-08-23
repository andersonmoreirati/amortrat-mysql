unit URelatCQ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IAeverButton, Mask, ExtCtrls, mdTabEnter, XBaloon,
  RLReport, jpeg, RLFilters, RLPDFFilter, DB, ZDataset,
  mimemess, mimepart,
   ComCtrls,
TaskDialog, rxToolEdit, rxCurrEdit,
IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdSMTPBase, IdSMTP, IdMessage, IdAttachment,IdAttachmentFile, IdMessageClient,
  RLHTMLFilter, RLRichFilter, RLXLSFilter, IdServerIOHandler;
// units para enviar email

type
  TFRelatCQ = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    BTSair: TIAeverButton;
    Label1: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    BTOK: TIAeverButton;
    ECodigo: TMaskEdit;
    Label25: TLabel;
    Edesenho: TEdit;
    ELote: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EEsp1: TEdit;
    ERes1: TEdit;
    EEsp2: TEdit;
    ERes2: TEdit;
    EEsp3: TEdit;
    ERes3: TEdit;
    EEsp4: TEdit;
    ERes4: TEdit;
    Label5: TLabel;
    ECrit: TEdit;
    EEquip: TEdit;
    Label6: TLabel;
    Ecarga: TEdit;
    Label7: TLabel;
    EObs: TMemo;
    Label13: TLabel;
    BTImprimir: TIAeverButton;
    ET1: TEdit;
    ET2: TEdit;
    ET3: TEdit;
    ET4: TEdit;
    TabEnter1: TTabEnter;
    RelatCQ: TRLReport;
    RLLabel23: TRLLabel;
    RLLabel24: TRLLabel;
    LCNPJ: TRLLabel;
    RLLabel1: TRLLabel;
    LNumCQ: TRLLabel;
    LData: TRLLabel;
    RLLabel4: TRLLabel;
    RLDraw27: TRLDraw;
    RLMemo1: TRLMemo;
    RLDraw28: TRLDraw;
    RLMemo2: TRLMemo;
    RLDraw29: TRLDraw;
    RLMemo3: TRLMemo;
    RLLabel9: TRLLabel;
    LPeca: TRLLabel;
    LMaterial: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel13: TRLLabel;
    LQtd: TRLLabel;
    RLLabel25: TRLLabel;
    RLLabel26: TRLLabel;
    LEt1: TRLLabel;
    LEt2: TRLLabel;
    LEt3: TRLLabel;
    LEt4: TRLLabel;
    LEsp4: TRLLabel;
    LEsp3: TRLLabel;
    LEsp2: TRLLabel;
    LEsp1: TRLLabel;
    LRes1: TRLLabel;
    LRes2: TRLLabel;
    LRes3: TRLLabel;
    LRes4: TRLLabel;
    RLLabel39: TRLLabel;
    RLLabel40: TRLLabel;
    RLLabel41: TRLLabel;
    RLLabel42: TRLLabel;
    RLMemo4: TRLMemo;
    LCrit: TRLLabel;
    LCarga: TRLLabel;
    LNotaS: TRLLabel;
    LEquip: TRLLabel;
    LObs: TRLMemo;
    RLPanel1: TRLPanel;
    RLPanel2: TRLPanel;
    RLPanel3: TRLPanel;
    RLPanel6: TRLPanel;
    RLPanel7: TRLPanel;
    RLPanel8: TRLPanel;
    RLPanel9: TRLPanel;
    RLPanel10: TRLPanel;
    RLPanel11: TRLPanel;
    RLPanel12: TRLPanel;
    RLPanel13: TRLPanel;
    RLPanel14: TRLPanel;
    RLPanel15: TRLPanel;
    RLPanel16: TRLPanel;
    RLPanel17: TRLPanel;
    RLPanel18: TRLPanel;
    RLPanel19: TRLPanel;
    RLPanel20: TRLPanel;
    RLPanel21: TRLPanel;
    ENotaS: TEdit;
    Label8: TLabel;
    RLLabel2: TRLLabel;
    ECliente: TEdit;
    Label9: TLabel;
    EPeca: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    EMaterial: TEdit;
    EPeso: TCurrencyEdit;
    Label24: TLabel;
    BTGerarPDF: TIAeverButton;
    QNF_Config: TZQuery;   { era TRxQuery }
    IdSMTP: TIdSMTP;
    QEMail: TZQuery;       { era TRxQuery }
    PStatus: TPanel;
    Lvalor: TLabel;
    Label14: TLabel;
    Label12: TLabel;
    PB: TProgressBar;
    RLImage2: TRLImage;
    RLImage1: TRLImage;
    RLPanel22: TRLPanel;
    RLPanel23: TRLPanel;
    RLLabel6: TRLLabel;
    LCliente: TRLLabel;
    RLLabel8: TRLLabel;
    LNota: TRLLabel;
    AdvTaskDialog1: TAdvTaskDialog;
    IdMessage: TIdMessage;
    RLPDFFilter1: TRLPDFFilter;
    RLLabel21: TRLLabel;
    LTrat: TRLLabel;
    RLLabel20: TRLLabel;
    LPeso: TRLLabel;
    RLLabel18: TRLLabel;
    LLote: TRLLabel;
    RLPicture: TRLImage;
    RLHTMLFilter1: TRLHTMLFilter;
    RLXLSFilter1: TRLXLSFilter;
    RLRichFilter1: TRLRichFilter;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure BTOKClick(Sender: TObject);
    procedure BTSairClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BTImprimirClick(Sender: TObject);
    procedure ET1Enter(Sender: TObject);
    procedure EObsEnter(Sender: TObject);
    procedure ET1Exit(Sender: TObject);
    procedure EObsExit(Sender: TObject);
    procedure BTImprimirEnter(Sender: TObject);
    procedure BTSairEnter(Sender: TObject);
    procedure BTSairExit(Sender: TObject);
    procedure BTImprimirExit(Sender: TObject);
    procedure BTGerarPDFClick(Sender: TObject);
    procedure IdSMTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdSMTPWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdSMTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
  private
    { Dados da OS/cliente/peca/processo carregados por CarregarDadosOS.
      No BDE estes valores eram lidos direto dos TTable do Modulo, que ficavam
      POSICIONADOS por FindKey. Sem cursor persistente, os valores passam a
      viver aqui — o que tambem evita que uma navegacao em outro form mude o
      que este relatorio imprime. }
    FOsCodigo, FOsCliente, FOsPeca, FOsNota, FOsLote, FOsQtd: string;
    FOsData:   TDateTime;
    FOsTemData: Boolean;
    FOsPeso:   Double;
    FCliCodigo, FCliFantasia, FCliRazao: string;
    FPecaDescricao, FPecaMaterial, FPecaDureza, FPecaFigura,
    FPecaCodPecaCli, FPecaCodProc: string;
    FProcProcesso: string;
    FCarregado: Boolean;
    function  GarantirConexao: Boolean;
    function  CarregarDadosOS(const ACodigo: string): Boolean;
    procedure LimparDadosCarregados;
    function  DataOsComoTexto: string;
  procedure Limpar;
  procedure Habilitar;
  function RemoveChar(Const Texto:String):String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRelatCQ: TFRelatCQ;

implementation

uses UModulo, UOS;

{$R *.dfm}
procedure TFRelatCQ.LimparDadosCarregados;
begin
  FOsCodigo := ''; FOsCliente := ''; FOsPeca := ''; FOsNota := '';
  FOsLote := '';  FOsQtd := '';    FOsPeso := 0;   FOsTemData := False;
  FCliCodigo := ''; FCliFantasia := ''; FCliRazao := '';
  FPecaDescricao := ''; FPecaMaterial := ''; FPecaDureza := '';
  FPecaFigura := ''; FPecaCodPecaCli := ''; FPecaCodProc := '';
  FProcProcesso := '';
  FCarregado := False;
end;

function TFRelatCQ.DataOsComoTexto: string;
// Antes era TBOsDATA.AsString. Um TDateField devolve '' quando nulo; aqui a
// checagem e explicita para nao imprimir uma data invalida no certificado.
begin
  if FOsTemData then Result := DateToStr(FOsData) else Result := '';
end;

function TFRelatCQ.GarantirConexao: Boolean;
// QNF_Config e QEMail vem do DFM, mas Modulo.ZConexao e criado em RUNTIME
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
        Application.MessageBox(pchar('Erro de conexao: ' + E.Message),
          pchar('ERRO'), MB_OK + MB_IconError);
        Exit;
      end;
    end;

  QNF_Config.Connection := Modulo.ZConexao;
  QEMail.Connection     := Modulo.ZConexao;
  Result := True;
end;

function TFRelatCQ.CarregarDadosOS(const ACodigo: string): Boolean;
// Substitui a cadeia de FindKey/GotoKey do BDE:
//   TBOs -> TBClientes -> TBPecas -> TBProc
// por SELECTs diretos. Mantida a regra de negocio de escolha manual de cliente
// para os pares PINOFIX/OTIA (0003/0019) e MICHELAN/CARTOFIX (0180/0219).
var
  Q: TZQuery;
  codCli: string;
begin
  Result := False;
  LimparDadosCarregados;
  if not GarantirConexao then Exit;
  Modulo.NovaLeitura;   // CQ sempre com dados atuais da OS

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Modulo.ZConexao;

    // --- OS ---
    Q.SQL.Text :=
      'SELECT CODIGO, CLIENTE, PECA, NOTA, DATA, QUANTIDADE, PESO, LOTE ' +
      'FROM tb_os WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := ACodigo;
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
    if Q.IsEmpty then Exit;

    FOsCodigo  := Q.FieldByName('CODIGO').AsString;
    FOsCliente := Q.FieldByName('CLIENTE').AsString;
    FOsPeca    := Q.FieldByName('PECA').AsString;
    FOsNota    := Q.FieldByName('NOTA').AsString;
    FOsLote    := Q.FieldByName('LOTE').AsString;
    FOsQtd     := Q.FieldByName('QUANTIDADE').AsString;
    FOsPeso    := Q.FieldByName('PESO').AsFloat;
    FOsTemData := not Q.FieldByName('DATA').IsNull;
    if FOsTemData then FOsData := Q.FieldByName('DATA').AsDateTime;
    Q.Close;

    // --- Cliente (com a escolha manual dos pares) ---
    codCli := FOsCliente;
    if (FOsCliente = '0003') or (FOsCliente = '0019') then
    begin
      If Application.MessageBox(pchar('Esta OS e do cliente PINOFIX ou OTIA? Clique SIM para PINOFIX e NAO para Otia.'),
           pchar('Confirmacao'), MB_YESNO+MB_IconQuestion+MB_DEFBUTTON2) = IDYes then
        codCli := '0003'
      else
        codCli := '0019';
    end
    else if (FOsCliente = '0180') or (FOsCliente = '0219') then
    begin
      If Application.MessageBox(pchar('Esta OS e do cliente MICHELAN ou CARTOFIX? Clique SIM para MICHELAN e NAO para CARTOFIX.'),
           pchar('Confirmacao'), MB_YESNO+MB_IconQuestion+MB_DEFBUTTON2) = IDYes then
        codCli := '0180'
      else
        codCli := '0219';
    end;

    Q.SQL.Text := 'SELECT CODIGO, FANTASIA, RAZAO FROM tb_clientes WHERE CODIGO = :pCodigo';
    Q.ParamByName('pCodigo').AsString := codCli;
    try
      Q.Open;
      if not Q.IsEmpty then
      begin
        FCliCodigo   := Q.FieldByName('CODIGO').AsString;
        FCliFantasia := Q.FieldByName('FANTASIA').AsString;
        FCliRazao    := Q.FieldByName('RAZAO').AsString;
      end;
    except end;
    Q.Close;

    // --- Peca (chave composta COD_CLI + CODIGO) ---
    // Usa o cliente ORIGINAL da OS, nao o escolhido acima: a peca pertence ao
    // cliente que emitiu a OS. Era o mesmo comportamento do BDE, que fazia
    // TBPecas.FindKey([TBOsCLIENTE, TBOsPECA]).
    Q.SQL.Text :=
      'SELECT DESCRICAO, MATERIAL, DUREZA, FIGURA, COD_PECA_CLI, COD_PROC ' +
      'FROM tb_pecas WHERE COD_CLI = :pCli AND CODIGO = :pPeca';
    Q.ParamByName('pCli').AsString  := FOsCliente;
    Q.ParamByName('pPeca').AsString := FOsPeca;
    try
      Q.Open;
      if not Q.IsEmpty then
      begin
        FPecaDescricao  := Q.FieldByName('DESCRICAO').AsString;
        FPecaMaterial   := Q.FieldByName('MATERIAL').AsString;
        FPecaDureza     := Q.FieldByName('DUREZA').AsString;
        FPecaFigura     := Q.FieldByName('FIGURA').AsString;
        FPecaCodPecaCli := Q.FieldByName('COD_PECA_CLI').AsString;
        FPecaCodProc    := Q.FieldByName('COD_PROC').AsString;
      end;
    except end;
    Q.Close;

    // --- Processo ---
    if FPecaCodProc <> '' then
    begin
      Q.SQL.Text := 'SELECT PROCESSO FROM tb_proc WHERE CODIGO = :pCodigo';
      Q.ParamByName('pCodigo').AsString := FPecaCodProc;
      try
        Q.Open;
        if not Q.IsEmpty then FProcProcesso := Q.FieldByName('PROCESSO').AsString;
      except end;
      Q.Close;
    end;
  finally
    Q.Free;
  end;

  FCarregado := True;
  Result := True;
end;

procedure TFRelatCQ.Limpar;
var
i : Integer;
begin
for i := 0 to FRelatCQ.ComponentCount - 1 do
if (FRelatCQ.Components[i] is TCustomEdit) and (FRelatCQ.Components[i].Name <> 'ECodigo')  then
(FRelatCQ.Components[i] as TCustomEdit).Clear;
end;

procedure TFRelatCQ.Habilitar;
var
i : Integer;
begin

for i := 0 to FRelatCQ.ComponentCount - 1 do
begin
if (FRelatCQ.Components[i] is TCustomEdit) and (FRelatCQ.Components[i].Name <> 'ECodigo') and (FRelatCQ.Components[i].Name <> 'EValor') then
begin
 (FRelatCQ.Components[i] as TCustomEdit).enabled := true;
 (FRelatCQ.Components[i] as TCustomEdit).Brush.Color := clWhite;
end;

if (FRelatCQ.Components[i] is TIAeverButton) and (FRelatCQ.Components[i].Name <> 'BTOK') and (FRelatCQ.Components[i].Name <> 'BTLocalizar') and (FRelatCQ.Components[i].Name <> 'BTSair') and (FRelatCQ.Components[i].Name <> 'BTFechar') then
 (FRelatCQ.Components[i] as TIAeverButton).enabled := true;
end;
end;


procedure TFRelatCQ.BTOKClick(Sender: TObject);
begin
ECodigo.EditMask := '999999/99;0;_';
If length(ECodigo.Text) < 7 then
begin
 Application.MessageBox('O campo OS deve ser no formato numero OS/ano!!! Exemplo: 00001/05', 'Erro de campo', MB_Ok);
 ECodigo.Setfocus;
 exit;
end;
ECodigo.EditMask := '999999/99;1;_';

If ECodigo.Text = '' then
begin
ECodigo.SetFocus;
exit;
end;

If not CarregarDadosOS(ECodigo.Text) then
begin
  Application.MessageBox('Os nao encontrada ou nao finalizada!','AVISO!', MB_Ok+MB_IconInformation);
  ECodigo.SetFocus;
  Exit;
end;

habilitar;
Limpar;
ET1.SetFocus;
ECliente.Text  := FCliFantasia;
EPeca.Text     := FPecaDescricao;
EMaterial.Text := FPecaMaterial;
ET1.Text       := 'DUREZA SUPERFICIAL';
EEsp1.Text     := FPecaDureza;
ECrit.Text     := 'IT - 006';
EEquip.Text    := 'DR-001';
EPeso.Value    := FOsPeso;
ELote.Text     := FOsLote;
end;

procedure TFRelatCQ.BTSairClick(Sender: TObject);
begin
limpar;
close;

end;

procedure TFRelatCQ.FormActivate(Sender: TObject);
begin
ECodigo.SetFocus;

If FOs.PFinalizar.Visible = true then BTOk.Click;
end;

procedure TFRelatCQ.BTImprimirClick(Sender: TObject);
begin
  LCliente.Caption := ECliente.Text;

  if FCliCodigo = '0208' then
    LPEca.Caption := EPeca.Text + ' - COD AUST�MPERA: ' + FPecaCodPecaCli
  else
    LPEca.Caption := EPeca.Text;

  LTRat.Caption := FProcProcesso;
  LNota.Caption := FOsNota;
  LNUmCQ.Caption := FOsCodigo;
  LData.Caption := DataOsComoTexto;
  //LDesenho.Caption := EDesenho.Text;
  LMaterial.Caption := EMaterial.Text;

   If Application.MessageBox('Deseja inserir a imagem da pe�a no CQ?', 'Aviso de impress�o!', MB_YESNO+MB_IconQuestion) = IDYes then
  begin
  // FIGURA e NULL/vazia em muitas pecas (e o caminho pode nao existir na rede).
  // O codigo BDE chamava LoadFromFile direto e levantava excecao nesses casos.
  if (FPecaFigura <> '') and FileExists(FPecaFigura) then
  begin
    try RLPicture.Picture.LoadFromFile(FPecaFigura); except
      RLPicture.Picture.Assign(nil);
      RLPicture.Refresh;
    end;
  end
  else
  begin
    RLPicture.Picture.Assign(nil);
    RLPicture.Refresh;
  end;
  end else begin
      RLPicture.Picture.Assign(nil);
       RLPicture.Refresh;
  end;


  LLOte.Caption := ELote.Text;
  LQtd.Caption := FOsQtd;
  LPeso.Caption := EPeso.Text + ' Kg';
  LNotaS.Caption := ENotaS.text;
  LCrit.Caption := ECrit.Text;
  LEquip.Caption := EEquip.Text;
  LCarga.Caption := ECarga.Text;
  EObs.Text := EObs.Text;
  LET1.Caption := ET1.Text;
  LET2.Caption := ET2.Text;
  LET3.Caption := ET3.Text;
  LET4.Caption := ET4.Text;
  LEsp1.Caption := EEsp1.Text;
  LEsp2.Caption := EEsp2.Text;
  LEsp3.Caption := EEsp3.Text;
  LEsp4.Caption := EEsp4.Text;
  LRes1.Caption := ERes1.Text;
  LRes2.Caption := ERes2.Text;
  LRes3.Caption := ERes3.Text;
  LRes4.Caption := ERes4.Text;
  LObs.Lines := EObs.Lines;
  RelatCQ.Clear;
  RelatCQ.Preview;
end;

procedure TFRelatCQ.ET1Enter(Sender: TObject);
begin
TEdit(sender).color := $00E2F5FE;
TEdit(sender).Font.Color := clNavy;
TEdit(sender).Font.style := [fsBold];
end;

procedure TFRelatCQ.EObsEnter(Sender: TObject);
begin
TMemo(sender).color := $00E2F5FE;
TMemo(sender).Font.Color := clNavy;
TMemo(sender).Font.style := [fsBold];

end;

procedure TFRelatCQ.ET1Exit(Sender: TObject);
begin
TEdit(Sender).color := clWhite;
TEdit(Sender).Font.Color := clBlack;
TEdit(Sender).Font.style := [];

end;

procedure TFRelatCQ.EObsExit(Sender: TObject);
begin
TMemo(Sender).color := clWhite;
TMemo(Sender).Font.Color := clBlack;
TMemo(Sender).Font.style := [];

end;

procedure TFRelatCQ.BTImprimirEnter(Sender: TObject);
begin
BTImprimir.ButtonColor := $00E2F5FE;
BTImprimir.ButtonColor1 := clGray;

end;

procedure TFRelatCQ.BTSairEnter(Sender: TObject);
begin
BTSAir.ButtonColor := $00E2F5FE;
BTSair.ButtonColor1 := clGray;

end;

procedure TFRelatCQ.BTSairExit(Sender: TObject);
begin
BTSAir.ButtonColor := $00CACACA;
BTSair.ButtonColor1 := $00CACACA;

end;

procedure TFRelatCQ.BTImprimirExit(Sender: TObject);
begin
BTimprimir.ButtonColor := $00CACACA;
BTimprimir.ButtonColor1 := $00CACACA;

end;

 function TFRelatCQ.RemoveChar(Const Texto:String):String;
  var
    I: integer;
    S: string;
  begin
    S := '';
    for I := 1 To Length(Texto) Do
    begin
      if (Texto[I] in ['0'..'9']) then
      begin
        S := S + Copy(Texto, I, 1);
      end;
    end;
    result := S;
  end;

procedure TFRelatCQ.BTGerarPDFClick(Sender: TObject);
var CC,host,port,user,pass,destinatario,fileName,pathCQ: String;
 i,t:Integer;
  td: TAdvTaskDialog;
 // tb: TTaskDialogBaseButtonItem;

begin


t := AdvTaskDialog1.Execute;

CC := '';
host := '';
port:= '';
user:= '';
pass:= '';
destinatario:= '';
fileName:= '';
IdMessage.Clear;

// O 'with Modulo do' foi removido: nao ha mais referencia a dataset BDE do
// datamodule neste metodo. O 'begin' e mantido para preservar o pareamento
// com o 'end' do fim do bloco.
begin

  if not GarantirConexao then Exit;

  PStatus.Visible := true;
  PStatus.Refresh;

  RelatCQ.Clear;
  RelatCQ.Refresh;

  LCliente.Caption := ECliente.Text;
  LPEca.Caption := EPeca.Text;
  LTRat.Caption := FProcProcesso;
  LNota.Caption := FOsNota;
  LNUmCQ.Caption := FOsCodigo;
  LData.Caption := DataOsComoTexto;
 // LDesenho.Caption := EDesenho.Text;

   If Application.MessageBox('Deseja inserir a imagem da pe�a no CQ?', 'Aviso de impress�o!', MB_YESNO+MB_IconQuestion) = IDYes then
  begin
  // FIGURA e NULL/vazia em muitas pecas (e o caminho pode nao existir na rede).
  // O codigo BDE chamava LoadFromFile direto e levantava excecao nesses casos.
  if (FPecaFigura <> '') and FileExists(FPecaFigura) then
  begin
    try RLPicture.Picture.LoadFromFile(FPecaFigura); except
      RLPicture.Picture.Assign(nil);
      RLPicture.Refresh;
    end;
  end
  else
  begin
    RLPicture.Picture.Assign(nil);
    RLPicture.Refresh;
  end;
  end else begin
      RLPicture.Picture.Assign(nil);
       RLPicture.Refresh;
  end;


  LMaterial.Caption := EMaterial.Text;
  LLOte.Caption := ELote.Text;
  LQtd.Caption := FOsQtd;
  LPeso.Caption := EPeso.Text + ' Kg';
  LNotaS.Caption := ENotaS.text;
  LCrit.Caption := ECrit.Text;
  LEquip.Caption := EEquip.Text;
  LCarga.Caption := ECarga.Text;
  EObs.Text := EObs.Text;
  LET1.Caption := ET1.Text;
  LET2.Caption := ET2.Text;
  LET3.Caption := ET3.Text;
  LET4.Caption := ET4.Text;
  LEsp1.Caption := EEsp1.Text;
  LEsp2.Caption := EEsp2.Text;
  LEsp3.Caption := EEsp3.Text;
  LEsp4.Caption := EEsp4.Text;
  LRes1.Caption := ERes1.Text;
  LRes2.Caption := ERes2.Text;
  LRes3.Caption := ERes3.Text;
  LRes4.Caption := ERes4.Text;
  LObs.Lines := EObs.Lines;
  // (dados de cliente/peca/processo ja carregados por CarregarDadosOS)
  QNF_Config.Close;
  QNF_Config.SQL.Clear;
  QNF_Config.SQL.Text := 'SELECT COD_CONFIG, VLR_CONFIG FROM tb_config';
  QNF_Config.Open;

  If not QNF_Config.Eof then
  repeat

    if t = 100 then begin
     If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 10 then host := QNF_Config.FieldByName('VLR_CONFIG').AsString;
     If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 11 then port := QNF_Config.FieldByName('VLR_CONFIG').AsString;
     If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 12 then user := QNF_Config.FieldByName('VLR_CONFIG').AsString;
     If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 13 then pass := QNF_Config.FieldByName('VLR_CONFIG').AsString;
    end else if t = 101 then begin
     If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 19 then host := QNF_Config.FieldByName('VLR_CONFIG').AsString;
     If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 20 then port := QNF_Config.FieldByName('VLR_CONFIG').AsString;
     If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 21 then user := QNF_Config.FieldByName('VLR_CONFIG').AsString;
     If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 22 then pass := QNF_Config.FieldByName('VLR_CONFIG').AsString;
    end;

     If QNF_Config.FieldByName('COD_CONFIG').AsInteger = 23 then pathCQ := QNF_Config.FieldByName('VLR_CONFIG').AsString;

     QNF_Config.Next
  until QNF_Config.Eof;


  fileName := pathCQ+ '\CQ_'+RemoveChar(FOsCodigo)+'_'+ ECliente.Text +'.pdf';
  RelatCQ.SaveToFile(fileName);

  QEMail.Close;
  QEMail.SQL.Clear;
  QEMail.SQL.Text := 'SELECT DISTINCT EMAIL, FLG_CQ FROM tb_email WHERE COD_CLIENTE = :pCli';
  QEMail.ParamByName('pCli').AsString := FOsCliente;
  QEMail.Open;

  i := 0;

  If not QEMail.Eof then
  repeat
    If QEMail.FieldByName('FLG_CQ').AsString = 'X' then begin
     If i = 0 then destinatario := QEMail.FieldByName('EMAIL').AsString else CC := CC + ',' + QEMail.FieldByName('EMAIL').AsString;
     i := i + 1;
    end;
     QEMail.Next
  until QEMail.Eof;

IdMessage.From.Address := user;
IdMessage.From.Name := 'AMORTRAT';
IdMessage.CharSet := 'ISO-8859-1';
IdMessage.Recipients.EMailAddresses := destinatario;
IdMessage.CCList.EMailAddresses := CC;
IdMessage.Subject := '[AMORTRAT] Envio do Certificado de Qualidade OS:'+FOsCodigo;
IdMessage.Body.Add('Este e-mail refere-se � emiss�o do Certificado de Qualidade para:');
IdMessage.Body.Add('');
IdMessage.Body.Add('Cliente.: ' + FCliRazao);
IdMessage.Body.Add('OS......: ' + FOsCodigo);
IdMessage.Body.Add('');
IdMessage.Body.Add('O documento de Certificado de Qualidade encontra-se em anexo.');
IdMessage.Body.Add('');
IdMessage.Body.Add('E-mail foi enviado automaticamente pelo SIA - Sistema Informatizado AMORTRAT.');

IdSMTP.Host := host;
IdSMTP.Port := StrToInt(port);
IdSMTP.username := user;
IdSMTP.Password := pass;

//anderson.moreira - VALIDAR MIGRACAO
TIdAttachmentFile.create(idmessage.MessageParts, TFileName(fileName));
IdSMTP.Connect;
try
IdSMTP.Send(IdMessage);
finally
IdSMTP.Disconnect;
end;
Application.MessageBox(PWideChar('O CQ foi enviado com sucesso para o(s) endere�o(s): '+destinatario+' '+CC +'!'), 'Confirma��o', MB_ICONINFORMATION + MB_OK);



end;

end;

procedure TFRelatCQ.IdSMTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
PB.Position := 0;
PB.Max:=820000;
end;


procedure TFRelatCQ.IdSMTPWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin

PB.Position:=AWorkCount;


end;

procedure TFRelatCQ.IdSMTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
PStatus.Visible := false;
end;

end.
