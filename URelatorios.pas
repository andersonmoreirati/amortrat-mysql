unit URelatorios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, RLReport, DB, TeEngine, Series, TeeProcs, Chart,
  DbChart, ExtCtrls, RLFilters, RLPDFFilter;

type
  TFRelatorios = class(TForm)
    RelatCli: TRLReport;
    RLBand1: TRLBand;
    RLLabel24: TRLLabel;
    RLLabel23: TRLLabel;
    RLImage3: TRLImage;
    LBTitRelatCliente: TRLLabel;
    RLSystemInfo1: TRLSystemInfo;
    RLBand2: TRLBand;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel6: TRLLabel;
    RLBand3: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLBand4: TRLBand;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLLabel5: TRLLabel;
    RelatProc: TRLReport;
    RLBand5: TRLBand;
    RLLabel7: TRLLabel;
    RLImage1: TRLImage;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLSystemInfo4: TRLSystemInfo;
    RLBand6: TRLBand;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLBand7: TRLBand;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText7: TRLDBText;
    RLBand8: TRLBand;
    RLSystemInfo5: TRLSystemInfo;
    RLSystemInfo6: TRLSystemInfo;
    RLLabel14: TRLLabel;
    RelatVendasG: TRLReport;
    RLBand9: TRLBand;
    LTitulo: TRLLabel;
    RLImage2: TRLImage;
    RLLabel16: TRLLabel;
    RLLabel17: TRLLabel;
    RLSystemInfo7: TRLSystemInfo;
    RLBand10: TRLBand;
    RLLabel18: TRLLabel;
    RLLabel19: TRLLabel;
    RLLabel20: TRLLabel;
    RLLabel21: TRLLabel;
    RLBand11: TRLBand;
    RLDBText9: TRLDBText;
    RLDBText10: TRLDBText;
    RLDBText11: TRLDBText;
    RLDBText12: TRLDBText;
    RLBand12: TRLBand;
    RLSystemInfo8: TRLSystemInfo;
    RLSystemInfo9: TRLSystemInfo;
    RLLabel22: TRLLabel;
    RLLabel26: TRLLabel;
    RLDBText14: TRLDBText;
    LData: TRLLabel;
    RLBand13: TRLBand;
    RLBand14: TRLBand;
    RLDBResult1: TRLDBResult;
    RLDBResult2: TRLDBResult;
    RLLabel25: TRLLabel;
    RLLabel28: TRLLabel;
    RLLabel29: TRLLabel;
    RLDBText13: TRLDBText;
    RelatVendasF: TRLReport;
    RLBand15: TRLBand;
    RLLabel30: TRLLabel;
    RLImage4: TRLImage;
    RLLabel31: TRLLabel;
    RLLabel32: TRLLabel;
    RLSystemInfo10: TRLSystemInfo;
    LdataF: TRLLabel;
    RLBand16: TRLBand;
    RLLabel36: TRLLabel;
    RLLabel38: TRLLabel;
    RLLabel39: TRLLabel;
    RLBand17: TRLBand;
    RLDBText17: TRLDBText;
    RLDBText19: TRLDBText;
    RLDBText20: TRLDBText;
    RLBand18: TRLBand;
    RLSystemInfo11: TRLSystemInfo;
    RLSystemInfo12: TRLSystemInfo;
    RLLabel40: TRLLabel;
    RLBand19: TRLBand;
    RLDBResult3: TRLDBResult;
    RLLabel41: TRLLabel;
    RLBand20: TRLBand;
    RLDBResult4: TRLDBResult;
    RLLabel42: TRLLabel;
    RLLabel34: TRLLabel;
    RLDBText15: TRLDBText;
    RelatPecas: TRLReport;
    RLBand21: TRLBand;
    RLLabel43: TRLLabel;
    RLImage5: TRLImage;
    RLLabel44: TRLLabel;
    RLLabel45: TRLLabel;
    RLSystemInfo13: TRLSystemInfo;
    RLBand22: TRLBand;
    RLLabel46: TRLLabel;
    RLLabel47: TRLLabel;
    RLLabel48: TRLLabel;
    RLLabel49: TRLLabel;
    RLBand23: TRLBand;
    RLDBText21: TRLDBText;
    RLDBText22: TRLDBText;
    RLDBText23: TRLDBText;
    RLDBText24: TRLDBText;
    RLBand24: TRLBand;
    RLSystemInfo14: TRLSystemInfo;
    RLSystemInfo15: TRLSystemInfo;
    RLLabel50: TRLLabel;
    RLDBText25: TRLDBText;
    RLLabel51: TRLLabel;
    RLLabel52: TRLLabel;
    RLDBText26: TRLDBText;
    RLDBText27: TRLDBText;
    RLLabel35: TRLLabel;
    RLDBText16: TRLDBText;
    RelatOS: TRLReport;
    RLBand25: TRLBand;
    LBTitulo: TRLLabel;
    RLImage6: TRLImage;
    RLLabel53: TRLLabel;
    RLLabel54: TRLLabel;
    RLSystemInfo16: TRLSystemInfo;
    LdataOs: TRLLabel;
    RLBand26: TRLBand;
    RLLabel56: TRLLabel;
    RLLabel57: TRLLabel;
    RLLabel58: TRLLabel;
    RLLabel59: TRLLabel;
    RLLabel60: TRLLabel;
    RLBand27: TRLBand;
    RLData: TRLDBText;
    RLOS: TRLDBText;
    RLFantasia: TRLDBText;
    RLdescricao: TRLDBText;
    RLValor: TRLDBText;
    RLBand28: TRLBand;
    RLSystemInfo17: TRLSystemInfo;
    RLSystemInfo18: TRLSystemInfo;
    RLLabel62: TRLLabel;
    RLBand29: TRLBand;
    RLDBResult5: TRLDBResult;
    RLLabel63: TRLLabel;
    RLBand30: TRLBand;
    RLDBResult6: TRLDBResult;
    RLLabel64: TRLLabel;
    RelatRankG: TRLReport;
    RLBand31: TRLBand;
    RLLabel27: TRLLabel;
    RLImage7: TRLImage;
    RLLabel33: TRLLabel;
    RLLabel55: TRLLabel;
    RLSystemInfo19: TRLSystemInfo;
    LDataRG: TRLLabel;
    RLBand32: TRLBand;
    RLLabel65: TRLLabel;
    RLLabel66: TRLLabel;
    RLLabel67: TRLLabel;
    RLLabel69: TRLLabel;
    RLBand33: TRLBand;
    RLDBText32: TRLDBText;
    RLDBText33: TRLDBText;
    RLDBText36: TRLDBText;
    RLBand34: TRLBand;
    RLSystemInfo20: TRLSystemInfo;
    RLSystemInfo21: TRLSystemInfo;
    RLLabel70: TRLLabel;
    RLBand35: TRLBand;
    RLDBResult7: TRLDBResult;
    RLLabel71: TRLLabel;
    RLBand36: TRLBand;
    RLDBResult8: TRLDBResult;
    RLLabel72: TRLLabel;
    RLSystemInfo22: TRLSystemInfo;
    RLDBResult9: TRLDBResult;
    RLDBResult10: TRLDBResult;
    RelatRankF: TRLReport;
    RLBand37: TRLBand;
    RLLabel61: TRLLabel;
    RLImage8: TRLImage;
    RLLabel68: TRLLabel;
    RLLabel73: TRLLabel;
    RLSystemInfo23: TRLSystemInfo;
    LDataRF: TRLLabel;
    RLBand38: TRLBand;
    RLLabel75: TRLLabel;
    RLLabel77: TRLLabel;
    RLBand39: TRLBand;
    RLDBText34: TRLDBText;
    RLSystemInfo24: TRLSystemInfo;
    RLBand40: TRLBand;
    RLSystemInfo25: TRLSystemInfo;
    RLSystemInfo26: TRLSystemInfo;
    RLLabel79: TRLLabel;
    RLBand41: TRLBand;
    RLLabel80: TRLLabel;
    RLBand42: TRLBand;
    RLLabel81: TRLLabel;
    RLLabel82: TRLLabel;
    RLDBText38: TRLDBText;
    RLDBResult15: TRLDBResult;
    RLDBResult16: TRLDBResult;
    RLLabel37: TRLLabel;
    RLDBText35: TRLDBText;
    RLDBText37: TRLDBText;
    RLDBText39: TRLDBText;
    RLDBText8: TRLDBText;
    RLDBText40: TRLDBText;
    RLDBText41: TRLDBText;
    RelatProducao: TRLReport;
    RLBand43: TRLBand;
    RLLabel13: TRLLabel;
    RLLabel15: TRLLabel;
    RLLabel74: TRLLabel;
    RLBand44: TRLBand;
    RLDBText43: TRLDBText;
    RLDBText44: TRLDBText;
    RLBand45: TRLBand;
    RLSystemInfo28: TRLSystemInfo;
    RLSystemInfo29: TRLSystemInfo;
    RLLabel76: TRLLabel;
    RLBand46: TRLBand;
    RLDBResult11: TRLDBResult;
    RLLabel78: TRLLabel;
    RLDBResult12: TRLDBResult;
    RLBand47: TRLBand;
    RLDBResult13: TRLDBResult;
    RLLabel83: TRLLabel;
    RLDBResult14: TRLDBResult;
    RLBand48: TRLBand;
    RLLabel84: TRLLabel;
    RLImage9: TRLImage;
    RLLabel85: TRLLabel;
    RLLabel86: TRLLabel;
    RLSystemInfo30: TRLSystemInfo;
    LDataP: TRLLabel;
    RLDBText42: TRLDBText;
    RLLabel12: TRLLabel;
    RLDBResult17: TRLDBResult;
    RLDBResult18: TRLDBResult;
    RLLabel87: TRLLabel;
    RLSubDetail1: TRLSubDetail;
    RLBand49: TRLBand;
    RLLabel88: TRLLabel;
    RLSystemInfo27: TRLSystemInfo;
    RLLabel1: TRLLabel;
    RLDBText45: TRLDBText;
    RelatOSTerceiros: TRLReport;
    RLBand50: TRLBand;
    RLSystemInfo31: TRLSystemInfo;
    LDataT: TRLLabel;
    LTituloT: TRLLabel;
    RLLabel91: TRLLabel;
    RLImage10: TRLImage;
    RLLabel92: TRLLabel;
    RLBand51: TRLBand;
    RLLabel94: TRLLabel;
    RLLabel95: TRLLabel;
    RLLabel96: TRLLabel;
    RLBand52: TRLBand;
    RLDBText47: TRLDBText;
    RLDBText48: TRLDBText;
    RLDBText49: TRLDBText;
    RLDBText50: TRLDBText;
    RLBand53: TRLBand;
    RLSystemInfo32: TRLSystemInfo;
    RLSystemInfo33: TRLSystemInfo;
    RLLabel98: TRLLabel;
    RLBand54: TRLBand;
    RLDBResult19: TRLDBResult;
    RLLabel99: TRLLabel;
    RLBand55: TRLBand;
    RLDBResult20: TRLDBResult;
    RLLabel100: TRLLabel;
    RLLabel97: TRLLabel;
    RLLabel89: TRLLabel;
    RLDBText46: TRLDBText;
    RLLabel93: TRLLabel;
    RLDBText51: TRLDBText;
    RLLabel90: TRLLabel;
    RLUrg: TRLDBText;
    RLLabel101: TRLLabel;
    RLLeadtime: TRLDBText;
    RLLabel102: TRLLabel;
    RLDBText18: TRLDBText;
    procedure RLDBText19BeforePrint(Sender: TObject; var Text: String;
      var PrintIt: Boolean);
    procedure RLSystemInfo22BeforePrint(Sender: TObject; var Text: String;
      var PrintIt: Boolean);

    procedure RLBand27MeasureHeight(Sender: TObject);
    procedure RLLeadtimeBeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRelatorios: TFRelatorios;

implementation
Uses UGerRelat;
{$R *.dfm}




procedure TFRelatorios.RLBand27MeasureHeight(Sender: TObject);
begin
try
  if StrToFloat(RLLeadTime.Text) > 10 then RlBand27.Color := clSilver else RlBand27.Color := clWhite;
except begin
end;
end;
end;

procedure TFRelatorios.RLDBText19BeforePrint(Sender: TObject;
  var Text: String; var PrintIt: Boolean);
begin
// Os TField persistentes do UGerrelat foram removidos na migracao (o BDE
// precisava deles por causa das colunas duplicadas do join). Acesso agora por
// FieldByName, com guarda: o BeforePrint pode disparar com a query fechada.
if FGerRelat.QVendasF.Active and (not FGerRelat.QVendasF.IsEmpty) and
   (FGerRelat.QVendasF.FieldByName('VALOR').AsFloat <= 0) then
  RLDBText19.Font.Color := clRed
else
  RLDBText19.Font.Color := clBlack;
end;

procedure TFRelatorios.RLLeadtimeBeforePrint(Sender: TObject; var AText: string;
  var PrintIt: Boolean);
begin

  if FGerRelat.QOs.Active and (not FGerRelat.QOs.IsEmpty) and
     (FGerRelat.QOs.FieldByName('URGENCIA').AsString = 'X') then
    RLBand27.Color := $00f0f0f0
  else
    RLBand27.Color := clWhite ;


  if FGerRelat.QOs.Active and (not FGerRelat.QOs.IsEmpty) and
     (FGerRelat.QOs.FieldByName('LEADTIME').AsFloat >= 10) then begin
      RLURg.font.Color := clRed;
      RLOS.font.Color := clRed;
      RLData.font.Color := clRed;
      RLFantasia.font.Color := clRed;
  RLdescricao.font.Color := clRed;
  RLLeadtime.font.Color := clRed;
            RLDescricao.font.Color := clRed;

  end else begin
        RLURg.font.Color := clBlack;
      RLOS.font.Color := clBlack;
      RLData.font.Color := clBlack;
      RLFantasia.font.Color := clBlack;
  RLdescricao.font.Color := clBlack;
  RLLeadtime.font.Color := clBlack;
            RLDescricao.font.Color := clBlack;
  end;





end;

procedure TFRelatorios.RLSystemInfo22BeforePrint(Sender: TObject;
  var Text: String; var PrintIt: Boolean);
begin
text := text + 'º';
end;

end.
