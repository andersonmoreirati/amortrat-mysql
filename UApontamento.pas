unit UApontamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CurrEdit, StdCtrls, IAeverButton, Mask, ToolEdit, RxLookup,
  Grids, BaseGrid, AdvGrid, AdvSprd, DB, DBTables, mdTabEnter, ComCtrls,
  AdvDateTimePicker, DBGrids, RXDBCtrl, RxQuery;

type
  TFApontamento = class(TForm)
    GroupBox1: TGroupBox;
    Label11: TLabel;
    ECodEquip: TEdit;
    Eequip: TRxLookupEdit;
    GroupBox2: TGroupBox;
    BTSair: TIAeverButton;
    GroupBox3: TGroupBox;
    BTMenos: TIAeverButton;
    TabEnter1: TTabEnter;
    Grid: TRxDBGrid;
    QApontamento: TQuery;
    DSApontamento: TDataSource;
    Label8: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label1: TLabel;
    cbTipo: TComboBox;
    EOs: TMaskEdit;
    EPeso: TCurrencyEdit;
    BTAdicionar: TIAeverButton;
    Label2: TLabel;
    Label3: TLabel;
    BTAtualizar: TIAeverButton;
    Eoperador: TRxLookupEdit;
    QApontamentoFORNO: TStringField;
    QApontamentoTIPO: TStringField;
    QApontamentoFUNCIONARIO: TStringField;
    QApontamentoCODIGO_EQUIP: TStringField;
    QApontamentoDATA_INI: TDateTimeField;
    QApontamentoDATA_FIM: TDateTimeField;
    QApontamentoCODIGO_OS: TStringField;
    QApontamentoPESO: TFloatField;
    QValidaApont: TQuery;
    QValidaApontFORNO: TStringField;
    QValidaApontTIPO: TStringField;
    QValidaApontFUNCIONARIO: TStringField;
    QValidaApontCODIGO_EQUIP: TStringField;
    QValidaApontDATA_INI: TDateTimeField;
    QValidaApontDATA_FIM: TDateTimeField;
    QValidaApontCODIGO_OS: TStringField;
    QValidaApontPESO: TFloatField;
    QValidaApontFUNCIONARIO_1: TStringField;
    QValidaApontTIPO_1: TFloatField;
    QDeleta: TQuery;
    QApontamentoCOD_APONTAMENTO: TIntegerField;
    procedure EequipCloseUp(Sender: TObject);
    procedure EequipKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ECodEquipEnter(Sender: TObject);
    procedure EequipEnter(Sender: TObject);
    procedure cbTipoEnter(Sender: TObject);
    procedure EOsEnter(Sender: TObject);
    procedure EHoraIniEnter(Sender: TObject);
    procedure EHoraFimEnter(Sender: TObject);
    procedure EPesoEnter(Sender: TObject);
    procedure EOperadorEnter(Sender: TObject);
    procedure BTSairClick(Sender: TObject);
    procedure BTAdicionarClick(Sender: TObject);
    procedure ECodEquipExit(Sender: TObject);
    procedure EequipExit(Sender: TObject);
    procedure cbTipoExit(Sender: TObject);
    procedure EOsExit(Sender: TObject);
    procedure EHoraIniExit(Sender: TObject);
    procedure EHoraFimExit(Sender: TObject);
    procedure EPesoExit(Sender: TObject);
    procedure EOperadorExit(Sender: TObject);
    procedure BTAtualizarClick(Sender: TObject);
    procedure BTMenosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FApontamento: TFApontamento;

implementation
Uses UModulo,StrUtils,DateUtils;


{$R *.dfm}

procedure TFApontamento.EequipCloseUp(Sender: TObject);
begin

with modulo do
ECodEquip.Text := TBEquipamentosCODIGO.Value;

end;

procedure TFApontamento.EequipKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
with modulo do
ECodEquip.Text := TBEquipamentosCODIGO.Value;

end;

procedure TFApontamento.FormCreate(Sender: TObject);
begin
//EApontHoraFim.Date := Now;
//EApontHoraIni.Date := Now - 30;
end;


procedure TFApontamento.ECodEquipEnter(Sender: TObject);
begin
ECodEquip.color := $00E2F5FE;
ECodEquip.Font.Color := clNavy;
ECodEquip.Font.style := [fsBold];
end;

procedure TFApontamento.EequipEnter(Sender: TObject);
begin
Eequip.color := $00E2F5FE;
Eequip.Font.Color := clNavy;
Eequip.Font.style := [fsBold];
end;

procedure TFApontamento.cbTipoEnter(Sender: TObject);
begin
cbTipo.color := $00E2F5FE;
cbTipo.Font.Color := clNavy;
cbTipo.Font.style := [fsBold];
end;

procedure TFApontamento.EOsEnter(Sender: TObject);
begin
EOs.color := $00E2F5FE;
EOs.Font.Color := clNavy;
EOs.Font.style := [fsBold];
end;

procedure TFApontamento.EHoraIniEnter(Sender: TObject);
begin
EHoraIni.color := $00E2F5FE;
EHoraIni.Font.Color := clNavy;
EHoraIni.Font.style := [fsBold];
end;

procedure TFApontamento.EHoraFimEnter(Sender: TObject);
begin
EHoraFim.color := $00E2F5FE;
EHoraFim.Font.Color := clNavy;
EHoraFim.Font.style := [fsBold];
end;

procedure TFApontamento.EPesoEnter(Sender: TObject);
begin
EPeso.color := $00E2F5FE;
EPeso.Font.Color := clNavy;
EPeso.Font.style := [fsBold];
end;

procedure TFApontamento.EOperadorEnter(Sender: TObject);
begin
EOperador.color := $00E2F5FE;
EOperador.Font.Color := clNavy;
EOperador.Font.style := [fsBold];
end;

procedure TFApontamento.BTSairClick(Sender: TObject);
begin
close;
end;

procedure TFApontamento.BTAdicionarClick(Sender: TObject);
var sql : string;
begin

with Modulo do
begin


If (Eequip.Text = '') then
begin
  Application.MessageBox('O campo Equipamento deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  Eequip.SetFocus;
  exit;
end;

If (Eequip.Text = '') then
begin
  Application.MessageBox('O campo Equipamento deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  Eequip.SetFocus;
  exit;
end;

If (EOperador.LookupValue = '') then
begin
  Application.MessageBox('O campo Funcionário deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  Eoperador.SetFocus;
  exit;
end;


If (EOs.Text = '') or (EOs.Text = '     /  ') then
begin
  Application.MessageBox('O campo Número da Os deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  EOs.SetFocus;
  exit;
end;

{
If (EHoraIni.Text = '') or (EHoraIni.Text = '  :  :  ') then
begin
  Application.MessageBox('O campo Hora Início deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  EHoraIni.SetFocus;
  exit;
end;

If (EHoraFim.Text = '') or (EHoraFim.Text = '  :  :  ') then
begin
  Application.MessageBox('O campo Hora Fim deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  EHoraFim.SetFocus;
  exit;
end;}

If (EPeso.Text = '') or (EPeso.Value = 0) then
begin
  Application.MessageBox('O campo Peso Tratado deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  EHoraFim.SetFocus;
  exit;
end;

If (EOperador.Text = '') then
begin
  Application.MessageBox('O campo Operador deve ser preenchido!', 'AVISO', MB_Ok+MB_IconInformation);
  EHoraFim.SetFocus;
  exit;
end;

TBOs.FindKey([EOS.text]);

If (TBOs.GotoKey = false) then
begin
  Application.MessageBox('O Número da Os informado não é válido!', 'AVISO', MB_Ok+MB_IconInformation);
  EOs.SetFocus;
  exit;
end;

//antes de inserir, valida se o apontamento não conflita com algum apontamento na base
  QValidaApont.Close;
  QValidaApont.SQL.Clear;

  sql := 'select eq.descricao FORNO, t.descricao TIPO, f.NOME FUNCIONARIO, ap.* from equipamentos eq, apontamento ap, tipo_apontamento t, funcionario f  WHERE eq.CODIGO = ap.codigo_equip AND ap.tipo = t.codigo AND ap.FUNCIONARIO = f.CODIGO '
  + ' AND ap.CODIGO_EQUIP = '''+ECodEquip.Text+''' AND ( EXISTS ( SELECT 1 FROM  apontamento ap3 WHERE ap3.CODIGO_EQUIP = ap.CODIGO_EQUIP AND CAST('''+DateTimeToStr(EHoraIni.DateTime)+''' AS TIMESTAMP) BETWEEN CAST((CAST(ap3.DATA_INI AS CHARACTER(19))) AS  TIMESTAMP)'
  + ' AND CAST((CAST(ap3.DATA_FIM AS CHARACTER(19))) AS  TIMESTAMP) ) OR EXISTS ( SELECT 1 FROM  apontamento ap3 WHERE ap3.CODIGO_EQUIP = ap.CODIGO_EQUIP AND CAST('''+DateTimeToStr(EHoraFim.DateTime)+''' AS TIMESTAMP) BETWEEN CAST((CAST(ap3.DATA_INI AS CHARACTER(19))) AS  TIMESTAMP) '
  + ' AND CAST((CAST(ap3.DATA_FIM AS CHARACTER(19))) AS  TIMESTAMP) ))';

  QValidaApont.SQL.Add(sql);

  QValidaApont.Open;

If (QValidaApont.RecordCount > 1) then
begin
  Application.MessageBox('O apontamento informado conflita com algum apontamento já inserido na base. Por favor, valide o período informado e tente novamente!', 'AVISO', MB_Ok+MB_IconInformation);
  EHoraIni.SetFocus;
  exit;
end;

//tudo validado, o apontamneto pode ser inserido
TBApontamento.Append;
TBApontamentoCODIGO_EQUIP.Value := ECodEquip.Text;
TBApontamentoCODIGO_OS.Value := EOs.Text;
TBApontamentoDATA_INI.AsDateTime := EHoraIni.DateTime;
TBApontamentoDATA_FIM.AsDateTime := EHoraFim.DateTime;
TBApontamentoFUNCIONARIO.Value := EOperador.LookupValue;
TBApontamentoTIPO.Value := StrToInt( LeftStr(cbTipo.Text,2));
TBApontamentoPESO.Value := EPeso.value;

TBApontamento.Post;

EHoraIni.DateTime := IncSecond(EHoraFim.DateTime,1);
EHoraFim.DateTime := IncHour(EHoraFim.DateTime,1);

EApontHoraIni.DateTime := IncDay(EHoraFim.DateTime,-1);
EApontHoraFim.DateTime := EHoraFim.DateTime;

EOS.Clear;
EPeso.Clear;

BTAtualizar.Click;

end;
end;

procedure TFApontamento.ECodEquipExit(Sender: TObject);
begin
ECodEquip.color := clWhite;
ECodEquip.Font.Color := clBlack;
ECodEquip.Font.style := [];

end;

procedure TFApontamento.EequipExit(Sender: TObject);
begin
Eequip.color := clWhite;
Eequip.Font.Color := clBlack;
Eequip.Font.style := [];

end;

procedure TFApontamento.cbTipoExit(Sender: TObject);
begin
cbTipo.color := clWhite;
cbTipo.Font.Color := clBlack;
cbTipo.Font.style := [];

end;

procedure TFApontamento.EOsExit(Sender: TObject);
begin
EOs.color := clWhite;
EOs.Font.Color := clBlack;
EOs.Font.style := [];

end;

procedure TFApontamento.EHoraIniExit(Sender: TObject);
begin
EHoraIni.color := clWhite;
EHoraIni.Font.Color := clBlack;
EHoraIni.Font.style := [];

end;

procedure TFApontamento.EHoraFimExit(Sender: TObject);
begin
EHoraFim.color := clWhite;
EHoraFim.Font.Color := clBlack;
EHoraFim.Font.style := [];

end;

procedure TFApontamento.EPesoExit(Sender: TObject);
begin
EPeso.color := clWhite;
EPeso.Font.Color := clBlack;
EPeso.Font.style := [];

end;

procedure TFApontamento.EOperadorExit(Sender: TObject);
begin
EOperador.color := clWhite;
EOperador.Font.Color := clBlack;
EOperador.Font.style := [];

end;

procedure TFApontamento.BTAtualizarClick(Sender: TObject);
begin
  QApontamento.Close;
  QApontamento.SQL.Clear;
  QApontamento.SQL.Text :=
  'select eq.descricao FORNO, t.descricao TIPO,f.NOME FUNCIONARIO, ap.* from equipamentos eq, apontamento ap, tipo_apontamento t, funcionario f'
  +' WHERE ap.FUNCIONARIO = f.CODIGO AND eq.CODIGO = ap.codigo_equip AND ap.tipo = t.codigo'
  +' AND ap.CODIGO_EQUIP=:equip AND ap.DATA_INI>=:dataIni and ap.DATA_FIM<=:dataFim'
  +' ORDER BY ap.DATA_INI desc';

  QApontamento.ParamByName('equip').AsString := ECodEquip.Text;
  QApontamento.ParamByName('dataIni').AsDateTime := EApontHoraIni.DateTime;
  QApontamento.ParamByName('dataFim').AsDateTime := EApontHoraFim.DateTime;

  QApontamento.Open;

end;

procedure TFApontamento.BTMenosClick(Sender: TObject);
VAR sql:String;
begin

If Application.MessageBox(pchar('Deseja realmente remover a linha selecionada ?'), pchar('AVISO'), MB_YESNO+MB_IconQuestion+MB_DEFBUTTON2) = IDYes then
begin

sql := 'delete from apontamento ap WHERE ap.COD_APONTAMENTO='+QApontamentoCOD_APONTAMENTO.Text;
 
  QDeleta.Close;
  QDeleta.SQL.Clear;
  QDeleta.SQL.Text := sql;

  QDeleta.ExecSQL;
  QDeleta.Close;


BTAtualizar.Click;
end;
end;

end.
