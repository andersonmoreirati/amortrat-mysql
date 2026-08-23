unit URelat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComboBox97, VrControls, VrLabel, mdTabEnter, RxGrdCpt,
  IAeverButton, VrCheckLed, Db, DBTables, RxQuery, Mask, ToolEdit;

type
  TF_Relat = class(TForm)
    RxGradientCaption1: TRxGradientCaption;
    TabEnter1: TTabEnter;
    GroupBox7: TGroupBox;
    VrLabel1: TVrLabel;
    ETipo: TComboBox97;
    GroupBox1: TGroupBox;
    VrLabel2: TVrLabel;
    EIndice: TComboBox97;
    OpDecresce: TVrCheckLed;
    OpCresce: TVrCheckLed;
    BTGravarS: TIAeverButton;
    BTGravarA: TIAeverButton;
    QCliente: TRxQuery;
    DsCliente: TDataSource;
    QReceber: TRxQuery;
    DsReceber: TDataSource;
    QPagar: TRxQuery;
    DSPagar: TDataSource;
    GroupBox2: TGroupBox;
    VrLabel3: TVrLabel;
    ECodigoB: TEdit;
    EDataC: TDateEdit;
    VrLabel4: TVrLabel;
    Edit1: TEdit;
    EDataF: TDateEdit;
    GroupBox3: TGroupBox;
    VrLabel7: TVrLabel;
    EComecaC: TEdit;
    QTitCli: TRxQuery;
    DsTitCli: TDataSource;
    QTitFornec: TRxQuery;
    DSTitFornec: TDataSource;
    QRateio: TRxQuery;
    DSRateio: TDataSource;
    QRateioCODIGO: TStringField;
    QRateioDESCRICAO: TStringField;
    QTitCliREFERENCIA: TStringField;
    QTitCliDATA: TDateField;
    QTitCliCLIENTE: TStringField;
    QTitCliCLINOME: TStringField;
    QTitCliCONTABIL: TCurrencyField;
    QTitCliDESC_BANCO: TCurrencyField;
    QTitCliATRASADO: TCurrencyField;
    QTitCliDEPOSITO: TCurrencyField;
    QTitCliDEP_SEMCONF: TCurrencyField;
    QTitCliVALOR: TCurrencyField;
    QTitCliCONTA: TStringField;
    QTitCliOBSERVACAO: TStringField;
    QTitCliFLOATING: TStringField;
    QTitCliTIPOTITULO: TStringField;
    QTitCliCOLUNAD: TStringField;
    QTitCliJUROS: TCurrencyField;
    QTitCliDESCONTO: TCurrencyField;
    QTitCliRATEIO: TStringField;
    QTitCliDATAB: TDateField;
    QTitCliCOR: TStringField;
    QPagarREFERENCIA: TStringField;
    QPagarDATA: TDateField;
    QPagarDATAB: TDateField;
    QPagarFORNECEDOR: TStringField;
    QPagarFORNECNOME: TStringField;
    QPagarCONTABIL: TCurrencyField;
    QPagarVALOR: TCurrencyField;
    QPagarSN: TStringField;
    QPagarCONTA: TStringField;
    QPagarRATEIO: TStringField;
    QPagarJUROS: TCurrencyField;
    QPagarDESCONTO: TCurrencyField;
    QPagarOBSERVACAO: TStringField;
    QPagarCOR: TStringField;
    QPagarTIPOTITULO: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ETipoChange(Sender: TObject);
    procedure BTGravarAClick(Sender: TObject);
    procedure BTGravarAEnter(Sender: TObject);
    procedure BTGravarAExit(Sender: TObject);
    procedure BTGravarAMouseEnter(sender: TObject);
    procedure BTGravarAMouseExit(sender: TObject);
    procedure BTGravarSEnter(Sender: TObject);
    procedure BTGravarSExit(Sender: TObject);
    procedure BTGravarSMouseEnter(sender: TObject);
    procedure BTGravarSMouseExit(sender: TObject);
    procedure BTGravarSClick(Sender: TObject);
    procedure EDataCEnter(Sender: TObject);
    procedure EDataFEnter(Sender: TObject);
    procedure EDataCExit(Sender: TObject);
    procedure EDataFExit(Sender: TObject);
    procedure EComecaCEnter(Sender: TObject);
    procedure EComecaCExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Relat: TF_Relat;

implementation

uses URelatCli, URelatFornec, URelatPagar, URelatReceber, URelatTitCli,
  URelatTitFornec, URelatRateio;

{$R *.DFM}

procedure TF_Relat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
F_Relat.release;
F_Relat := nil;

end;

procedure TF_Relat.FormShow(Sender: TObject);
begin
ETipo.ItemIndex := 0;
EIndice.ItemIndex := 0;
end;

procedure TF_Relat.ETipoChange(Sender: TObject);
var x:integer;
begin

If ETipo.ItemIndex = 0 then
begin
for x := 0 to EIndice.Items.Count - 1 do
EIndice.Items.Delete(0);

EIndice.Items.Add('CODIGO');
EIndice.Items.Add('NOME');
end;

If ETipo.ItemIndex = 1 then
begin
for x := 0 to EIndice.Items.Count - 1 do
EIndice.Items.Delete(0);

EIndice.Items.Add('CODIGO');
EIndice.Items.Add('NOME');
end;

If (ETipo.ItemIndex = 2) or (ETipo.ItemIndex = 5) then
begin
for x := 0 to EIndice.Items.Count - 1 do
EIndice.Items.Delete(0);
EIndice.Items.Add('REFERENCIA');
EIndice.Items.Add('FORNECNOME');
EIndice.Items.Add('DATA');
EIndice.Items.Add('VALOR');
end;

If (ETipo.ItemIndex = 3) or (ETipo.ItemIndex = 4)  then
begin
for x := 0 to EIndice.Items.Count - 1 do
EIndice.Items.Delete(0);

EIndice.Items.Add('REFERENCIA');
EIndice.Items.Add('DATA');
EIndice.Items.Add('CLINOME');
EIndice.Items.Add('VALOR');
EIndice.Items.Add('DESC_BANCO');
EIndice.Items.Add('ATRASADO');
EIndice.Items.Add('DEP_SEMCONF');
EIndice.Items.Add('DEPOSITO');
end;

If ETipo.ItemIndex = 6 then
begin
for x := 0 to EIndice.Items.Count - 1 do
EIndice.Items.Delete(0);
EIndice.Items.Add('CODIGO');
EIndice.Items.Add('DESCRICAO');
end;


EIndice.ItemIndex := 0;
end;

procedure TF_Relat.BTGravarAClick(Sender: TObject);
begin

If ETipo.Itemindex = 0 then
begin
QCliente.close;
QCliente.SQL.Clear;
IF OpCresce.Checked = true then QCliente.SQL.Add ('Select Codigo, Nome from CLIENTE where NOME like "' + EComecaC.Text + '%" order by ' + EIndice.Items.Strings[EIndice.ItemIndex]) else QCliente.SQL.Add ('Select Codigo, Nome from CLIENTE where NOME like "' + EComecaC.Text + '%" order by ' + EIndice.Items.Strings[EIndice.ItemIndex] + ' DESC');
QCliente.Prepare;
QCliente.open;
Application.CreateForm(TF_RelatCli, F_RelatCli);
F_RelatCli.RelatCli.preview;
end;

If ETipo.Itemindex = 1 then
begin
QCliente.close;
QCliente.SQL.Clear;
IF OpCresce.Checked = true then QCliente.SQL.Add ('Select Codigo, Nome from FORNEC where NOME like "' + EComecaC.Text + '%" order by ' + EIndice.Items.Strings[EIndice.ItemIndex]) else QCliente.SQL.Add ('Select Codigo, Nome from FORNEC where NOME like "' + EComecaC.Text + '%" order by ' + EIndice.Items.Strings[EIndice.ItemIndex] + ' DESC');
QCliente.Prepare;
QCliente.open;
Application.CreateForm(TF_RelatFornec, F_RelatFornec);
F_RelatFornec.RelatFornec.preview;
end;

If ETipo.Itemindex = 2 then
begin
QPagar.close;
QPagar.SQL.Clear;
IF OpCresce.Checked = true then QPagar.SQL.Add ('Select Referencia, FornecNome, DATA, VALOR from PAGAR where DATA < :Data order by ' + EIndice.Items.Strings[EIndice.ItemIndex]) else QPagar.SQL.Add ('Select Referencia, FornecNome, DATA, VALOR from PAGAR where DATA < :Data order by '+ EIndice.Items.Strings[EIndice.ItemIndex] +' DESC');
QPagar.ParamByName('Data').AsDateTime := Date;
QPagar.Prepare;
QPagar.open;
Application.CreateForm(TF_RelatPagar, F_RelatPagar);
F_RelatPagar.RelatPagar.preview;
end;

If ETipo.Itemindex = 3 then
begin
QReceber.close;
QReceber.SQL.Clear;
IF OpCresce.Checked = true then QReceber.SQL.Add ('Select * from Receber where DATA < :Data order by ' + EIndice.Items.Strings[EIndice.ItemIndex]) else QReceber.SQL.Add ('Select * from Receber where DATA < :Data order by ' + EIndice.Items.Strings[EIndice.ItemIndex] +' DESC');
QReceber.ParamByName('Data').AsDateTime := Date;
QReceber.Prepare;
QReceber.open;
Application.CreateForm(TF_RelatReceber, F_RelatReceber);
F_RelatReceber.RelatReceber.preview;
end;

If ETipo.Itemindex = 4 then
begin
QTitCli.close;
QTitCli.SQL.Clear;
IF OpCresce.Checked = true then QTitCli.SQL.Add ('Select * from Receber where CLINOME like "' + EComecaC.text + '%" and DATA >= :DataI and DATA <= :DataF order by ' + EIndice.Items.Strings[EIndice.ItemIndex]) else QTitCLI.SQL.Add ('Select * from Receber where CLINOME like "' + EComecaC.text + '%" and DATA >= :DataI and DATA <= :DataF order by ' + EIndice.Items.Strings[EIndice.ItemIndex] +' DESC');
QTitCli.ParamByName('DataI').AsDateTime := EDataC.Date;
QTitCli.ParamByName('DataF').AsDateTime := EDataF.Date;
QTitCli.Prepare;
QTitCli.open;
Application.CreateForm(TF_RelatTitCli, F_RelatTitCli);
F_RelatTitCli.RelatTitCli.preview;
end;

If ETipo.Itemindex = 5 then
begin
QTitFornec.close;
QTitFornec.SQL.Clear;
IF OpCresce.Checked = true then QTitFornec.SQL.Add ('Select Referencia, FornecNome, DATA, VALOR from PAGAR where FORNECNOME like "' + EComecaC.text + '%" and DATA >= :DataI and DATA <= :DataF order by ' + EIndice.Items.Strings[EIndice.ItemIndex]) else QTitFornec.SQL.Add ('Select Referencia, FornecNome, DATA, VALOR from PAGAR where FORNECNOME like "' + EComecaC.text + '%" and DATA >= :DataI and DATA <= :DataF order by '+ EIndice.Items.Strings[EIndice.ItemIndex] +' DESC');
QTitFornec.ParamByName('DataI').AsDateTime := EDataC.date;
QTitFornec.ParamByName('DataF').AsDateTime := EDataF.date;
QTitFornec.Prepare;
QTitFornec.open;
Application.CreateForm(TF_RelatTitFornec, F_RelatTitFornec);
F_RelatTitFornec.RelatTitFornec.preview;
end;

If ETipo.Itemindex = 6 then
begin
QRateio.close;
QRateio.SQL.Clear;
IF OpCresce.Checked = true then QRateio.SQL.Add ('Select * from RATEIO where DESCRICAO like "' + EComecaC.Text + '%" order by ' + EIndice.Items.Strings[EIndice.ItemIndex]) else QRateio.SQL.Add ('Select * from RATEIO where DESCRICAO like "' + EComecaC.Text + '%" order by ' + EIndice.Items.Strings[EIndice.ItemIndex] + ' DESC');
QRateio.Prepare;
QRateio.open;
Application.CreateForm(TF_RelatRateio, F_RelatRateio);
F_RelatRateio.RelatRateio.preview;
end;


end;

procedure TF_Relat.BTGravarAEnter(Sender: TObject);
begin
 BTGravarA.ButtonColor := $00C8C8C8;
end;

procedure TF_Relat.BTGravarAExit(Sender: TObject);
begin
 BTGravarA.ButtonColor := clSilver;
end;

procedure TF_Relat.BTGravarAMouseEnter(sender: TObject);
begin
 BTGravarA.ButtonColor := $00C8C8C8;
end;

procedure TF_Relat.BTGravarAMouseExit(sender: TObject);
begin
 BTGravarA.ButtonColor := clSilver;
end;

procedure TF_Relat.BTGravarSEnter(Sender: TObject);
begin
 BTGravarS.ButtonColor := $00C8C8C8;
end;

procedure TF_Relat.BTGravarSExit(Sender: TObject);
begin
 BTGravarS.ButtonColor := clSilver;
end;

procedure TF_Relat.BTGravarSMouseEnter(sender: TObject);
begin
 BTGravarS.ButtonColor := $00C8C8C8;
end;

procedure TF_Relat.BTGravarSMouseExit(sender: TObject);
begin
 BTGravarS.ButtonColor := clSilver;
end;

procedure TF_Relat.BTGravarSClick(Sender: TObject);
begin
close;
end;

procedure TF_Relat.EDataCEnter(Sender: TObject);
begin
EDataC.color := clWhite;
end;

procedure TF_Relat.EDataFEnter(Sender: TObject);
begin
EDataF.color := clWhite;
end;

procedure TF_Relat.EDataCExit(Sender: TObject);
var data: string;
    D: TDate;
begin
         if EDataC.Text <> '  /  /    ' then
            begin
               try
                  data := datetostr(EDataC.date);
                  D := StrToDate(EDataC.Text);
                  EDataC.Text := DateToStr(D);
               except
                  Application.MessageBox('Digite uma data válida!', 'Data Inválida', MB_Ok+Mb_IconInformation);
                  EdataC.SetFocus;
                  Abort;
               end;
            end;
EDataC.color := clBtnFace;
end;

procedure TF_Relat.EDataFExit(Sender: TObject);
var data: string;
    D: TDate;
begin
         if EDataF.Text <> '  /  /    ' then
            begin
               try
                  data := datetostr(EDataF.date);
                  D := StrToDate(EDataF.Text);
                  EDataF.Text := DateToStr(D);
               except
                  Application.MessageBox('Digite uma data válida!', 'Data Inválida', MB_Ok+Mb_IconInformation);
                  EdataF.SetFocus;
                  Abort;
               end;
            end;
EDataF.color := clBtnFace;
end;

procedure TF_Relat.EComecaCEnter(Sender: TObject);
begin
EComecaC.color := clWhite;
end;

procedure TF_Relat.EComecaCExit(Sender: TObject);
begin
EComecaC.color := clBtnFace;
end;

procedure TF_Relat.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If key = VK_ESCAPE then BTGravarS.Click;
end;

end.
