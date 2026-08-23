unit UOrcamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, ToolEdit, ExtCtrls, Grids, BaseGrid, AdvGrid, AdvSprd,
  StdCtrls, IAeverButton, RLReport, jpeg, mdTabEnter, RxLookup;

type
  TFOrcamento = class(TForm)
    TabEnter1: TTabEnter;
    RelatCQ: TRLReport;
    RLImage1: TRLImage;
    RLPanel4: TRLPanel;
    RLPanel21: TRLPanel;
    RLPanel20: TRLPanel;
    RLPanel19: TRLPanel;
    RLPanel18: TRLPanel;
    RLPanel17: TRLPanel;
    RLPanel16: TRLPanel;
    RLPanel15: TRLPanel;
    RLPanel14: TRLPanel;
    RLPanel13: TRLPanel;
    RLPanel12: TRLPanel;
    RLPanel11: TRLPanel;
    RLPanel10: TRLPanel;
    RLPanel9: TRLPanel;
    RLPanel8: TRLPanel;
    RLPanel7: TRLPanel;
    RLPanel6: TRLPanel;
    RLPanel5: TRLPanel;
    RLPanel3: TRLPanel;
    RLPanel2: TRLPanel;
    RLPanel1: TRLPanel;
    RLDraw27: TRLDraw;
    RLImage3: TRLImage;
    RLLabel23: TRLLabel;
    RLLabel24: TRLLabel;
    LCNPJ: TRLLabel;
    RLLabel1: TRLLabel;
    LNumCQ: TRLLabel;
    LData: TRLLabel;
    RLLabel4: TRLLabel;
    RLMemo1: TRLMemo;
    RLDraw28: TRLDraw;
    RLMemo2: TRLMemo;
    RLDraw29: TRLDraw;
    RLMemo3: TRLMemo;
    RLLabel6: TRLLabel;
    LCliente: TRLLabel;
    RLLabel8: TRLLabel;
    LNota: TRLLabel;
    RLLabel9: TRLLabel;
    LPeca: TRLLabel;
    LMaterial: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel13: TRLLabel;
    LQtd: TRLLabel;
    RLLabel15: TRLLabel;
    LDesenho: TRLLabel;
    LLote: TRLLabel;
    RLLabel18: TRLLabel;
    LPeso: TRLLabel;
    RLLabel20: TRLLabel;
    RLLabel21: TRLLabel;
    LTrat: TRLLabel;
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
    RLLabel2: TRLLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    BTOK: TIAeverButton;
    Panel3: TPanel;
    Panel4: TPanel;
    ECodigo: TEdit;
    BTadd: TIAeverButton;
    Grid: TAdvSpreadGrid;
    Label3: TLabel;
    Edit1: TEdit;
    Image1: TImage;
    EDataE: TDateEdit;
    Label4: TLabel;
    Label2: TLabel;
    ECliente: TEdit;
    EFantasia: TRxLookupEdit;
    GroupBox2: TGroupBox;
    BTSair: TIAeverButton;
    BTLimpar: TIAeverButton;
    BTFinalizar: TIAeverButton;
    BTGravar: TIAeverButton;
    BTDeletar: TIAeverButton;
    GroupBox5: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    OpEnt: TRadioButton;
    OpS: TRadioButton;
    GroupBox6: TGroupBox;
    Edit2: TEdit;
    GroupBox7: TGroupBox;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label5: TLabel;
    procedure BTSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FOrcamento: TFOrcamento;

implementation

{$R *.dfm}

procedure TFOrcamento.BTSairClick(Sender: TObject);
begin
close;
end;

end.
