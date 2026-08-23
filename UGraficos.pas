unit UGraficos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, DbChart;

type
  TFGraficos = class(TForm)
    DBChart1: TDBChart;
    Series1: TBarSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FGraficos: TFGraficos;

implementation
Uses UGerrelat;

{$R *.dfm}

end.
