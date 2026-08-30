unit USplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, pngimage, ExtCtrls, rtflabel;

type
  TFSplash = class(TForm)
    Image1: TImage;
    LStatus: TLabel;
    RTFLabel1: TRTFLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSplash: TFSplash;

implementation

{$R *.dfm}

end.
