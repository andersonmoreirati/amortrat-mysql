unit UFechamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mdTabEnter, ExtCtrls, StdCtrls, Mask, mdCpfCnpj,
  VrEdit, IAeverButton, jpeg, BDE, DB, DBCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Grids, BaseGrid,
  AdvGrid, DBTables, RxQuery, AdvObj, rxToolEdit,
  rxCurrEdit, UModulo, RxLookup, UModulo;

type
  TFFechamento = class(TForm)
    G1: TGroupBox;
    Label14: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    ECodigo: TEdit;
    BTOK2: TIAeverButton;
    ECliente: TEdit;
    Label11: TLabel;
    EFantasia: TRxLookupEdit;
    EData: TDateEdit;
    Label9: TLabel;
    GroupBox2: TGroupBox;
    BTSair: TIAeverButton;
    BTLimpar: TIAeverButton;
    BTGravar: TIAeverButton;
    BTDeletar: TIAeverButton;
    BTEnviar: TIAeverButton;
    EOs: TMaskEdit;
    BTOK: TIAeverButton;
    Label6: TLabel;
    Grid: TAdvStringGrid;
    ETotal: TCurrencyEdit;
    Label7: TLabel;
    BTadd: TIAeverButton;
    BTDeleteRow: TIAeverButton;
    RxLookupEdit1: TRxLookupEdit;
    procedure FormCreate(Sender: TObject);
  private
    procedure Limpar;
  public
    { Public declarations }
  end;

var
  FFechamento: TFFechamento;
  ativar:boolean=true;

implementation

{$R *.dfm}

procedure TFFechamento.Limpar;
var
i : Integer;
begin
for i := 0 to FFechamento.ComponentCount - 1 do
if (FFechamento.Components[i] is TCustomEdit) and (FFechamento.Components[i].Name <> 'ECodigo') then
(FFechamento.Components[i] as TCustomEdit).Clear;


//for i := 1 to GridEmail.RowCount - 1 do
//  GridEmail.Rows[i].Clear;

end;

procedure TFFechamento.FormCreate(Sender: TObject);
begin
if ativar=true then
begin
limpar;
//Application.OnActivate := FormRefresh;
With Modulo do
begin
  TBNf.Refresh;
  TBNf.Last;
  If TBNf.RecordCount <= 0 then ECodigo.Text := '000001' else
     ECodigo.Text := inttostr(TBNfCODIGO.AsInteger + 1);
  ECodigo.SetFocus;
end;
desabilitar;
end;
ativar:=true;

end;

end.
