unit MySqlTestConn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ZAbstractConnection, ZConnection, ZDataset, DB, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractTable, StdCtrls;

type
  TForm4 = class(TForm)
    ZConnection1: TZConnection;
    ZTable1: TZTable;
    ZQuery1: TZQuery;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
try
    ZConnection1.Connected := False;

    // Diz ao connector para não verificar o certificado do servidor
    ZConnection1.Properties.Values['usessl'] := 'false';
    ZConnection1.Properties.Values['usessl'] := 'false';
ZConnection1.Properties.Values['MYSQL_OPT_SSL_VERIFY_SERVER_CERT'] := 'FALSE';

    ZConnection1.Connect;
    ShowMessage('Conectado! Banco: ' + ZConnection1.Database);
  except
    on E: Exception do
      ShowMessage('ERRO: ' + E.Message);
  end;
end;

procedure TForm4.Button2Click(Sender: TObject);
var
  Q: TZQuery;
  Linhas: TStringList;
begin
  Q := TZQuery.Create(nil);
  Linhas := TStringList.Create;
  try
    Q.Connection := ZConnection1;

    Q.SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM tb_config';
    Q.Open;
    Linhas.Add('tb_config: ' + Q.FieldByName('TOTAL').AsString + ' registros');
    Q.Close;

    Q.SQL.Text := 'SELECT cod_config, vlr_config FROM tb_config ORDER BY cod_config LIMIT 5';
    Q.Open;
    Linhas.Add('--- primeiros 5 ---');
    while not Q.Eof do
    begin
      Linhas.Add('cod=' + Q.FieldByName('cod_config').AsString +
                 '  valor=' + Q.FieldByName('vlr_config').AsString);
      Q.Next;
    end;
    Q.Close;

    Q.SQL.Text := 'SELECT codigo, data FROM tb_os ORDER BY codigo DESC LIMIT 1';
    Q.Open;
    if not Q.IsEmpty then
      Linhas.Add('Última OS: ' + Q.FieldByName('codigo').AsString +
                 '  entrada: ' + Q.FieldByName('data').AsString);
    Q.Close;

    ShowMessage(Linhas.Text);
  except
    on E: Exception do
      ShowMessage('ERRO: ' + E.Message);
  end;
  Q.Free;
  Linhas.Free;

end;

end.
