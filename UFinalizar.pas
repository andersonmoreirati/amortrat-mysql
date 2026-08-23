unit UFinalizar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IAeverButton, Grids, VolDBGrid, Mask, ToolEdit, DB,
  DBTables, RxQuery, DBGrids, BDE, XBaloon, mdTabEnter;

type
  TFFinalizar = class(TForm)
    GroupBox1: TGroupBox;
    EDataIni: TDateEdit;
    Label4: TLabel;
    EDataFim: TDateEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label6: TLabel;
    GroupBox3: TGroupBox;
    BTSair: TIAeverButton;
    BTFinalizar: TIAeverButton;
    DataSource1: TDataSource;
    BTSel: TIAeverButton;
    EOsIni: TMaskEdit;
    EOsFim: TMaskEdit;
    TBOSF: TTable;
    TBOSFCODIGO: TStringField;
    TBOSFPECA: TStringField;
    TBOSFDATA: TDateField;
    TBOSFPESO: TFloatField;
    TBOSFFINALIZADA: TBooleanField;
    TBOSFCLIENTE: TStringField;
    TBOSFCLINOME: TStringField;
    Label3: TLabel;
    TabEnter1: TTabEnter;
    XBaloon: TXBaloon;
    TBOSFNOTA: TStringField;
    DBGrid1: TVolgaDBGrid;
    TBOSFVAL: TCurrencyField;
    procedure FormActivate(Sender: TObject);
    procedure BTSairClick(Sender: TObject);
    procedure EDataIniEnter(Sender: TObject);
    procedure EOsIniEnter(Sender: TObject);
    procedure EDataFimEnter(Sender: TObject);
    procedure EOsFimEnter(Sender: TObject);
    procedure EDataIniChange(Sender: TObject);
    procedure EOsIniChange(Sender: TObject);
    procedure BTSelClick(Sender: TObject);
    procedure TBOSFFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure TBOSFAfterPost(DataSet: TDataSet);
    procedure BTFinalizarClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TVolgaColumn; State: TGridDrawState);
    procedure TBOSFVALORSetText(Sender: TField; const Text: String);
    procedure TBOSFVALORChange(Sender: TField);
    procedure TBOSFVALChange(Sender: TField);
  private
    { Private declarations }
  public
  procedure FormRefresh(Sender: TObject);
    { Public declarations }
  end;

var
  FFinalizar: TFFinalizar;

implementation

uses UModulo;

{$R *.dfm}

procedure TFFinalizar.FormRefresh(Sender: TObject);
begin
With Modulo do
begin
TBOs.Refresh;
end;
end;



procedure TFFinalizar.FormActivate(Sender: TObject);
begin
Application.OnActivate := FormRefresh;
end;

procedure TFFinalizar.BTSairClick(Sender: TObject);
begin
close;
end;

procedure TFFinalizar.EDataIniEnter(Sender: TObject);
begin
TEdit(sender).color := $00E2F5FE;
TEdit(sender).Font.Color := clNavy;
TEdit(sender).Font.style := [fsBold];

end;

procedure TFFinalizar.EOsIniEnter(Sender: TObject);
begin
TEdit(sender).color := $00E2F5FE;
TEdit(sender).Font.Color := clNavy;
TEdit(sender).Font.style := [fsBold];

end;

procedure TFFinalizar.EDataFimEnter(Sender: TObject);
begin
TEdit(sender).color := $00E2F5FE;
TEdit(sender).Font.Color := clNavy;
TEdit(sender).Font.style := [fsBold];

end;

procedure TFFinalizar.EOsFimEnter(Sender: TObject);
begin
TEdit(sender).color := $00E2F5FE;
TEdit(sender).Font.Color := clNavy;
TEdit(sender).Font.style := [fsBold];

end;

procedure TFFinalizar.EDataIniChange(Sender: TObject);
begin
EOsFim.Clear;
EOsIni.Clear;
end;

procedure TFFinalizar.EOsIniChange(Sender: TObject);
begin
EDataini.Clear;
Edatafim.Clear;
end;

procedure TFFinalizar.BTSelClick(Sender: TObject);
begin


if EdataIni.Date <> 0 then
begin
  TBOSF.Filter := 'FINALIZADA = ' + QuotedStr('false') + ' and DATA >= ' + QuotedStr(EDataIni.Text) + ' and DATA <= ' + QuotedStr(EDataFim.Text);
end else

begin
 EOsIni.EditMask := '99999/99;0;_';
EOsFim.EditMask := '99999/99;0;_';
If (length(EOsIni.Text) < 7) or (length(EOsIni.Text) < 7) then
begin
 Application.MessageBox('O campo OS deve ser no formato numero OS/ano!!! Exemplo: 00001/05', 'Erro de campo', MB_Ok);
 EOsIni.Setfocus;
 exit;
end;
EOsIni.EditMask := '99999/99;1;_';
EOsFim.EditMask := '99999/99;1;_';
TBOSF.Filter := 'FINALIZADA = ' + QuotedStr('false') + ' and CODIGO >= ' + QuotedStr(EOsIni.Text) + ' and CODIGO <= ' + QuotedStr(EOsFim.Text);
end;
  TBOSF.Active := true;
end;

// TBPecas.FindKey([TBOSFCLIENTE.text, TBOSFPECA.text]);
// text := formatfloat('######0.00',TBOSFPESO.Value * TBPecasPRECO.Value);
procedure TFFinalizar.TBOSFFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
// if TBOSFPESO.Value < 10 then Accept := false;
end;

procedure TFFinalizar.TBOSFAfterPost(DataSet: TDataSet);
begin
   TBOSF.FlushBuffers;
   DBISaveChanges(TBOSF.Handle);

end;

procedure TFFinalizar.BTFinalizarClick(Sender: TObject);
var i:integer;
begin
with Modulo do begin
TBOSF.Filtered := true;
TBOSF.First;

for i:=1 to TBOSF.recordcount do
begin
  TBOSF.Edit;
  TBOsFFINALIZADA.Value := true;
  TBOsF.Post;

  TBOs_FInalizados.Append;
  TBOS_FinalizadosCODIGO.Value := DBgrid1.Fields[0].text;
  TBOS_FinalizadosNOTA.Value := DBgrid1.Fields[4].text;
  TBOS_FinalizadosDATA_FIM.Value := now;
  TBOS_FinalizadosVALOR.Value := DBgrid1.Fields[3].AsFloat;
  TBOS_Finalizados.Post;
  TBOSF.Next;
  IF TBOSF.Eof = true then break;
end;

end;

end;

procedure TFFinalizar.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TVolgaColumn;
  State: TGridDrawState);
begin

{If strtocurr(DBGrid1.Fields[3].text) < 50 then
begin
  Dbgrid1.Canvas.Font.Color:= clred;
end else
begin
  Dbgrid1.Canvas.Font.Color:= clblack; // coloque aqui a cor desejada
end;
     if gdSelected in State then
      begin
        DBGrid1.Canvas.Brush.Color:= $00E2F5FE;
        Dbgrid1.Canvas.Font.Style:= [fsBold];
      end;

DBGrid1.Canvas.FillRect(Rect);
DBGrid1.DefaultDrawColumnCell(Rect, datacol,column , State);
//Dbgrid1.DefaultDrawDataCell(Rect, dbgrid1.columns[datacol].field, State);
}
end;

procedure TFFinalizar.TBOSFVALORSetText(Sender: TField;
  const Text: String);
begin
DBGrid1.Fields[3].text := text;
end;


procedure TFFinalizar.TBOSFVALORChange(Sender: TField);
begin
 with Modulo do begin
 TBPecas.FindKey([TBOSFCLIENTE.text, TBOSFPECA.text]);
 DbGrid1.Fields[3].Text := formatfloat('######0.00',TBOSFPESO.Value * TBPecasPRECO.Value);
 end;

end;

procedure TFFinalizar.TBOSFVALChange(Sender: TField);
begin
 with Modulo do begin
 TBPecas.FindKey([TBOSFCLIENTE.text, TBOSFPECA.text]);
 DbGrid1.Fields[3].Text := formatfloat('######0.00',TBOSFPESO.Value * TBPecasPRECO.Value);
 end;

end;

end.
