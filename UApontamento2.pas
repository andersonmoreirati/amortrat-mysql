unit UApontamento2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, RxQuery, StdCtrls, IAeverButton, Grids, AdvObj,
  BaseGrid, AdvGrid, RxLookup, rxToolEdit, rxCurrEdit, Mask, DBGrids, RXDBCtrl,
  ComCtrls, AdvDateTimePicker, AdvDBDateTimePicker;

type
  TFApontamento = class(TForm)
    GroupBox2: TGroupBox;
    BTSair: TIAeverButton;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    ECodOS: TMaskEdit;
    Label2: TLabel;
    Label3: TLabel;
    ECodEvento: TEdit;
    EEvento: TRxLookupEdit;
    EInicio: TAdvDBDateTimePicker;
    EFim: TAdvDBDateTimePicker;
    EColaborador: TRxLookupEdit;
    ECodColaborador: TEdit;
    Label4: TLabel;
    RxDBGrid1: TRxDBGrid;
    EPEso: TCurrencyEdit;
    ECodEquipamento: TEdit;
    EEquipamento: TRxLookupEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    BTGravar: TIAeverButton;
    procedure BTSairClick(Sender: TObject);
    procedure BTMaisClick(Sender: TObject);
    procedure ECodEventoEnter(Sender: TObject);
    procedure ECodEventoExit(Sender: TObject);
    procedure ECodEventoChange(Sender: TObject);
    procedure ECodColaboradorEnter(Sender: TObject);
    procedure ECodColaboradorExit(Sender: TObject);
    procedure ECodColaboradorChange(Sender: TObject);
    procedure ECodEquipamentoEnter(Sender: TObject);
    procedure ECodEquipamentoExit(Sender: TObject);
    procedure ECodEquipamentoChange(Sender: TObject);
    procedure BTGravarClick(Sender: TObject);
    procedure EEventoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EEventoCloseUp(Sender: TObject);
    procedure EColaboradorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EColaboradorCloseUp(Sender: TObject);
    procedure EEquipamentoCloseUp(Sender: TObject);
    procedure EEquipamentoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    function RetZero(ZEROS: string; QUANT: integer): String;
  public
    { Public declarations }
  end;

var
  FApontamento: TFApontamento;

implementation

uses UModulo;
{$R *.dfm}

procedure TFApontamento.BTGravarClick(Sender: TObject);
var
  cod_ultimo: String;
  gravar: Boolean;
begin

    With Modulo do
    begin

  gravar := true;

  ECodOS.EditMask := '99999/99;0;_';
  If length(ECodOS.Text) < 7 then
  begin
    Application.MessageBox(
      'O campo OS deve ser no formato numero OS/ano!!! Exemplo: 00001/05',
      'Erro de campo', MB_Ok);
    ECodOS.Setfocus;
    exit;
  end;
  ECodOS.EditMask := '99999/99;1;_';


  if gravar then
  begin


      TBApontamento.Last;
      cod_ultimo := TBApontamentoCOD_APONTAMENTO.Value;

      TBApontamento.Append;

      TBApontamentoCOD_APONTAMENTO.Value := RetZero
        (inttostr(strtoint(cod_ultimo) + 1), 8);
      TBApontamentoOS.Value := ECodOS.Text;
      TBApontamentoCOD_EVENTO.Value := ECodEvento.Text;
      TBApontamentoCOD_EQUIPAMENTO.Value := ECodEquipamento.Text;
      TBApontamentoCOD_FUNCIONARIO.Value := ECodColaborador.Text;
      TBApontamentoPESO.Value := EPEso.Value;
      TBApontamentoDATA_INICIO.Value := EInicio.DateTime;
      TBApontamentoDATA_FIM.Value := EFim.DateTime;

      TBApontamento.Post;
      TBApontamento.Refresh;
    end;
  end;
end
// ELogin.Clear;
// ESenha.Clear;
// ELogin.SetFocus;
end;

procedure TFApontamento.BTMaisClick(Sender: TObject);
Var
  indice: integer;
begin

  // indice := GridColaborador.RowCount;
  // GridColaborador.AddRow;
  // GridColaborador.Cells[0, indice] := indice;
  // GridColaborador.Cells[1, indice] := EColaborador.Text;
  // EColaborador.Clear;
  // EColaborador.SetFocus;

  // GridColaborador.SortSettings.Column := 0;
  // GridColaborador.SortSettings.Direction := sdAscending; // ou sdDescending
  // GridColaborador.QSort;

end;

procedure TFApontamento.BTSairClick(Sender: TObject);
begin
  close;
end;

procedure TFApontamento.ECodColaboradorChange(Sender: TObject);
begin
  Modulo.TBFuncionario.FindKey([RetZero(ECodColaborador.Text, 4)]);
end;

procedure TFApontamento.ECodColaboradorEnter(Sender: TObject);
begin
  ECodColaborador.color := $00E2F5FE;
  ECodColaborador.Font.color := clNavy;
  ECodColaborador.Font.style := [fsBold];
end;

procedure TFApontamento.ECodColaboradorExit(Sender: TObject);
begin
  ECodColaborador.color := clWhite;
  ECodColaborador.Font.color := clBlack;
  ECodColaborador.Font.style := [];
  If EColaborador.Text <> '' then
    ECodColaborador.Text := Modulo.RetZero(ECodColaborador.Text, 4);
end;

procedure TFApontamento.ECodEquipamentoChange(Sender: TObject);
begin
  Modulo.TBEquipamentos.FindKey([RetZero(ECodEquipamento.Text, 2)]);
end;

procedure TFApontamento.ECodEquipamentoEnter(Sender: TObject);
begin
  ECodEquipamento.color := $00E2F5FE;
  ECodEquipamento.Font.color := clNavy;
  ECodEquipamento.Font.style := [fsBold];
end;

procedure TFApontamento.ECodEquipamentoExit(Sender: TObject);
begin
  ECodEquipamento.color := clWhite;
  ECodEquipamento.Font.color := clBlack;
  ECodEquipamento.Font.style := [];
  If EEvento.Text <> '' then
    ECodEvento.Text := Modulo.RetZero(ECodEvento.Text, 2);
end;

procedure TFApontamento.ECodEventoChange(Sender: TObject);
begin
  Modulo.TBEvento.FindKey([RetZero(ECodEvento.Text, 2)]);
end;

procedure TFApontamento.ECodEventoEnter(Sender: TObject);
begin
  ECodEvento.color := $00E2F5FE;
  ECodEvento.Font.color := clNavy;
  ECodEvento.Font.style := [fsBold];
end;

procedure TFApontamento.ECodEventoExit(Sender: TObject);
begin
  ECodEvento.color := clWhite;
  ECodEvento.Font.color := clBlack;
  ECodEvento.Font.style := [];
  If EEvento.Text <> '' then
    ECodEvento.Text := Modulo.RetZero(ECodEvento.Text, 2);
end;

procedure TFApontamento.EColaboradorCloseUp(Sender: TObject);
begin
  with Modulo do
    ECodColaborador.Text := TBFuncionarioCODIGO.Value;

end;

procedure TFApontamento.EColaboradorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with Modulo do
    ECodColaborador.Text := TBFuncionarioCODIGO.Value;

  If EColaborador.Text = '' then
  begin
    ECodColaborador.Text := '';
  end;

end;

procedure TFApontamento.EEquipamentoCloseUp(Sender: TObject);
begin
  with Modulo do
    ECodEquipamento.Text := TBEquipamentosCODIGO.Value;

end;

procedure TFApontamento.EEquipamentoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with Modulo do
    ECodEquipamento.Text := TBEquipamentosCODIGO.Value;

  If EEquipamento.Text = '' then
  begin
    ECodEquipamento.Text := '';
  end;
end;

procedure TFApontamento.EEventoCloseUp(Sender: TObject);
begin
  with Modulo do
    ECodEvento.Text := TBEventoCODIGO.Value;
end;

procedure TFApontamento.EEventoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with Modulo do
    ECodEvento.Text := TBEventoCODIGO.Value;

  If EEvento.Text = '' then
  begin
    ECodEvento.Text := '';
  end;

end;

function TFApontamento.RetZero(ZEROS: string; QUANT: integer): String;
var
  I, Tamanho: integer;
  aux: string;
begin
  aux := ZEROS;
  Tamanho := length(ZEROS);
  ZEROS := '';
  for I := 1 to QUANT - Tamanho do
    ZEROS := ZEROS + '0';
  aux := ZEROS + aux;
  RetZero := aux;
end;

end.
