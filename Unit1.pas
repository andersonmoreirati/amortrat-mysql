unit Unit1;

interface

uses

Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
StdCtrls, Db, DBTables, ExtCtrls, MPlayer, DBCtrls, Grids, DBGrids, ExtDlgs,
  ImgList, JPEG, BDE;

type
  TForm1 = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBImage1: TDBImage;
    Button1: TButton;
    ImageList1: TImageList;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Table1COD_CLI: TStringField;
    Table1CODIGO: TStringField;
    Table1COD_PROC: TStringField;
    Table1DESCRICAO: TStringField;
    Table1MATERIAL: TStringField;
    Table1PRECO: TCurrencyField;
    Table1DUREZA: TStringField;
    Table1FIGURA: TGraphicField;
    procedure dirClose(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    Procedure Grava_Imagem_JPEG(Tabela:TTable; Campo:TBlobField; Foto:TImage; Dialog:TOpenPictureDialog);

    { Private declarations }
  public

    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Procedure TForm1.Grava_Imagem_JPEG(Tabela:TTable; Campo:TBlobField;
Foto:TImage; Dialog:TOpenPictureDialog);
var BS:TBlobStream;
MinhaImagem:TJPEGImage;
Begin
Dialog.InitialDir := 'c:\temp';
Dialog.Execute;
if Dialog.FileName <> '' Then
Begin
if not (Tabela.State in [dsEdit, dsInsert]) Then
Tabela.Edit;
BS := TBlobStream.Create((Campo as TBlobField), BMWRITE);
MinhaImagem := TJPEGImage.Create;
MinhaImagem.LoadFromFile(Dialog.FileName);
MinhaImagem.SaveToStream(BS);
Foto.Picture.Assign(MinhaImagem);
BS.Free;
MinhaImagem.Free;
Tabela.Post;
DBISaveChanges(Tabela.Handle);
End;
End;


procedure TForm1.dirClose(Sender: TObject);
begin
   table1.Edit;
   DBImage1.Picture.Bitmap.LoadFromFile('D:\back\teste\arq\teste.bmp');
   table1.Post;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 OpenPictureDialog1.Execute;
table1.Edit;
table1FIGURA.LoadFromFile(OpenPictureDialog1.FileName);
table1.Post;
DBISaveChanges(Table1.Handle);
table1.Free;
end;

end.
