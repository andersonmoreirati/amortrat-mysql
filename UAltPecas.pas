unit UAltPecas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB, DBTables;

type
  TForm1 = class(TForm)
    barra: TProgressBar;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    BTSair: TButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    DataSource1: TDataSource;
    TBPecas: TTable;
    TBPecasCOD_CLI: TStringField;
    TBPecasCODIGO: TStringField;
    TBPecasCOD_PROC: TStringField;
    TBPecasDESCRICAO: TStringField;
    TBPecasMATERIAL: TStringField;
    TBPecasPRECO: TCurrencyField;
    TBPecasDUREZA: TStringField;
    TBPecasFIGURA: TGraphicField;
    TBPecasOBS: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BTSairClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 TBPecas.DBSession.AddPassword('99866');
  TBPecas.Active := true;
end;

procedure TForm1.Button1Click(Sender: TObject);
var I:integer;
begin
   If Application.MessageBox(pchar('Voce tem certeza que deseja alterar todos os campos OBSERVAÇÃOS da tabela PEÇAS? A Alteração é irreversível e afetará o cadastro das peças de todos clientes.'), pchar('Confirmação para Alteração'), MB_YESNO+MB_IconQuestion++MB_DEFBUTTON2) = IDYes then
    begin
        Barra.Min := 1;
        barra.Max := TBPecas.RecordCount;

        TBPecas.First;
          for I := Barra.Min to Barra.Max do begin
                Barra.Position := I;
                TBPecas.Edit;
                TBPecasOBS.Value := TBPecasOBS.Value + edit1.Text;
                TBPecas.Post;
                TBPecas.Next;
         end;
   Showmessage('CADASTRO ATUALIZADO COM ÊXITO!');
   BTSair.click;
   end;
end;

procedure TForm1.BTSairClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
showmessage('Para sua segurança, antes de qualquern alteração, FAÇA UM BACKUP!');
end;

end.
