unit ULocalizar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, mdTabEnter, Grids, DBGrids, RXDBCtrl, ExtCtrls, jpeg,
  IAeverButton, DB, ZDataset;

type
  TFLocalizar = class(TForm)
    GroupBox2: TGroupBox;
    BTDeletar: TIAeverButton;
    BTLocalizar: TIAeverButton;
    BTSair: TIAeverButton;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label2: TLabel;
    Etexto: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    GroupBox3: TGroupBox;
    GridCli: TRxDBGrid;
    TabEnter1: TTabEnter;
    optContem: TRadioButton;
    OptComeca: TRadioButton;
    OptTermina: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel6: TPanel;
    LBResultado: TPanel;
    Panel7: TPanel;
    QClientes: TZQuery;          { era TQuery }
    DSQuery: TDataSource;
    QClientesCODIGO: TStringField;
    QClientesRAZAO: TStringField;
    QClientesFANTASIA: TStringField;
    Qprocessos: TZQuery;         { era TQuery }
    DataSource1: TDataSource;
    QPecas: TZQuery;             { era TQuery }
    DataSource2: TDataSource;
    GridProc: TRxDBGrid;
    GridPeca: TRxDBGrid;
    QprocessosCODIGO: TStringField;
    QprocessosPROCESSO: TStringField;
    QPecasCOD_CLI: TStringField;
    QPecasCODIGO: TStringField;
    QPecasCOD_PROC: TStringField;
    QPecasDESCRICAO: TStringField;
    procedure BTLocalizarClick(Sender: TObject);
    procedure BTSairClick(Sender: TObject);
    procedure GridCliDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure EtextoEnter(Sender: TObject);
    procedure EtextoExit(Sender: TObject);
    procedure GridProcDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridPecaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridCliDblClick(Sender: TObject);
    procedure GridProcDblClick(Sender: TObject);
    procedure GridPecaDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BTLocalizarEnter(Sender: TObject);
    procedure BTDeletarEnter(Sender: TObject);
    procedure BTSairEnter(Sender: TObject);
    procedure BTLocalizarExit(Sender: TObject);
    procedure BTDeletarExit(Sender: TObject);
    procedure BTSairExit(Sender: TObject);
  private
    function  GarantirConexao: Boolean;
    procedure AbrirContando(Q: TZQuery);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLocalizar: TFLocalizar;

implementation

uses UModulo, UClientes, UProcessos, UPecas;

{$R *.dfm}

{ ---------------------------------------------------------------------------
  Infraestrutura de conexão

  Os três TZQuery vivem no DFM, mas Modulo.ZConexao é criado em RUNTIME
  (DataModuleCreate) e portanto não existe em design time — não há como
  atribuir Connection pelo Object Inspector. A ligação é feita aqui.
  --------------------------------------------------------------------------- }

function TFLocalizar.GarantirConexao: Boolean;
begin
  Result := False;
  if (Modulo = nil) or (Modulo.ZConexao = nil) then Exit;

  if not Modulo.ZConexao.Connected then
    try
      Modulo.ZConexao.Connect;
    except
      on E: Exception do
      begin
        Application.MessageBox(pchar('Erro de conexão: ' + E.Message),
          pchar('ERRO'), MB_OK + MB_IconError);
        Exit;
      end;
    end;

  QClientes.Connection  := Modulo.ZConexao;
  Qprocessos.Connection := Modulo.ZConexao;
  QPecas.Connection     := Modulo.ZConexao;
  Result := True;
end;

procedure TFLocalizar.AbrirContando(Q: TZQuery);
// Abre a query forçando o fetch completo.
// No ZeosLib RecordCount só é confiável depois de percorrer até o fim; sem o
// Last o contador de resultados (LBResultado) sairia parcial.
begin
  Q.Open;
  if not Q.IsEmpty then
  begin
    Q.Last;
    Q.First;
  end;
end;

{ ---------------------------------------------------------------------------
  Localizar
  --------------------------------------------------------------------------- }

procedure TFLocalizar.BTLocalizarClick(Sender: TObject);
var
  condicao: string;
begin
  If ETexto.Text = '' then
    begin
     Application.MessageBox('Digite no campo TEXTO algo para ser localizado!', 'Aviso', MB_IconInformation+MB_Ok);
     Etexto.SetFocus;
     exit;
  end;

  If (OptContem.Checked = false) and (OptComeca.Checked = false) and (OptTermina.Checked = false) then
    begin
     Application.MessageBox('Escolha primeiro um tipo de busca!', 'Aviso', MB_IconInformation+MB_Ok);
     QClientes.close;
     Etexto.SetFocus;
     exit;
  end;

  if not GarantirConexao then Exit;
  Modulo.NovaLeitura;   // busca sempre sobre dados atuais (ver TModulo.NovaLeitura)

  // O valor do LIKE agora é PARÂMETRO — antes era concatenado direto no SQL
  // com aspas duplas (sintaxe Paradox) e sem escape nenhum.
  If OptContem.Checked  = true then condicao := '%' + uppercase(Etexto.Text) + '%';
  If OptComeca.Checked  = true then condicao := uppercase(Etexto.Text) + '%';
  If OptTermina.Checked = true then condicao := '%' + uppercase(Etexto.Text);

  try
    If GridCli.Visible = true then
    begin
     QClientes.Close;
     QClientes.SQL.Text :=
       'SELECT CODIGO, RAZAO, FANTASIA FROM tb_clientes ' +
       'WHERE upper(FANTASIA) LIKE :pTexto ORDER BY FANTASIA';
     QClientes.ParamByName('pTexto').AsString := condicao;
     AbrirContando(QClientes);
     LBResultado.caption := Modulo.RetZero(inttostr(QClientes.recordcount), 6);
     If strtofloat(LBResultado.caption) = 0 then Application.MessageBox('A sua busca retornou 0 registros. Tente ser menos específico ou verifique se a condição de busca está correta!', 'Aviso', MB_IconExclamation+MB_Ok);
     GridCli.SetFocus;
    end else
     If GridProc.Visible = true then
      begin
      QProcessos.Close;
      QProcessos.SQL.Text :=
        'SELECT CODIGO, PROCESSO FROM tb_proc ' +
        'WHERE upper(PROCESSO) LIKE :pTexto ORDER BY PROCESSO';
      QProcessos.ParamByName('pTexto').AsString := condicao;
      AbrirContando(QProcessos);
      LBResultado.caption := Modulo.RetZero(inttostr(QProcessos.recordcount), 6);
      If strtofloat(LBResultado.caption) = 0 then Application.MessageBox('A sua busca retornou 0 registros. Tente ser menos específico ou verifique se a condição de busca está correta!', 'Aviso', MB_IconExclamation+MB_Ok);
      GridProc.SetFocus;
      end else
       begin
       QPecas.Close;
       QPecas.SQL.Text :=
         'SELECT COD_CLI, CODIGO, COD_PROC, DESCRICAO FROM tb_pecas ' +
         'WHERE upper(DESCRICAO) LIKE :pTexto ORDER BY DESCRICAO';
       QPecas.ParamByName('pTexto').AsString := condicao;
       AbrirContando(QPecas);
       LBResultado.caption := Modulo.RetZero(inttostr(QPecas.recordcount), 6);
       If strtofloat(LBResultado.caption) = 0 then Application.MessageBox('A sua busca retornou 0 registros. Tente ser menos específico ou verifique se a condição de busca está correta!', 'Aviso', MB_IconExclamation+MB_Ok);
       GridPeca.SetFocus;
    end;
  except
    on E: Exception do
    begin
      // Reconexão: o servidor pode ter derrubado a conexão por inatividade (2006)
      try
        Modulo.ZConexao.Disconnect;
        Modulo.ZConexao.Connect;
        Application.MessageBox(
          pchar('A conexão havia caído e foi restabelecida. Refaça a busca.'),
          pchar('Aviso'), MB_OK + MB_IconInformation);
      except
        Application.MessageBox(pchar('Erro na busca: ' + E.Message),
          pchar('ERRO'), MB_OK + MB_IconError);
      end;
    end;
  end;
end;

procedure TFLocalizar.BTSairClick(Sender: TObject);
begin

if gridCli.Visible = true then
begin
if QClientes.Active and not QClientes.IsEmpty then
begin
FClientes.ECodigo.text := QClientesCODIGO.value;
FClientes.BTOK.Click;
end;
ETexto.Clear;
QClientes.Close;
QPecas.Close;
QProcessos.Close;
OptContem.Checked := true;
close;
end;

if gridProc.Visible = true then
begin
if QProcessos.Active and not QProcessos.IsEmpty then
begin
FProcessos.ECodigo.text := QProcessosCODIGO.value;
FProcessos.BTOK.Click;
end;
ETexto.Clear;
QClientes.Close;
QPecas.Close;
QProcessos.Close;
OptContem.Checked := true;
close;
end;

if gridPeca.Visible = true then
begin
if QPecas.Active and not QPecas.IsEmpty then
begin
FPecas.ECliente.text := QPecasCOD_CLI.value;
FPecas.ECodigo.text := QPecasCODIGO.value;
FPecas.BTOK.Click;
end;
ETexto.Clear;
QClientes.Close;
QPecas.Close;
QProcessos.Close;
OptContem.Checked := true;
close;
end;


end;

procedure TFLocalizar.GridCliDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
   if gdSelected in State then

      begin
         GridCli.Canvas.Font.Color := clNavy;
         GridCli.canvas.Brush.Color := $00E2F5FE;
      end;
   Gridcli.Canvas.FillRect(Rect);
   Gridcli.Canvas.TextOut(Rect.Left + 2, Rect.Top, Column.Field.text);
end;

procedure TFLocalizar.EtextoEnter(Sender: TObject);
begin
ETexto.color := $00E2F5FE;
ETexto.Font.Color := clNavy;
ETexto.Font.style := [fsBold];
end;

procedure TFLocalizar.EtextoExit(Sender: TObject);
begin
ETexto.color := clWhite;
ETexto.Font.Color := clBlack;
ETexto.Font.style := [];
end;

procedure TFLocalizar.GridProcDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if gdSelected in State then

      begin
         GridProc.Canvas.Font.Color := clNavy;
         GridProc.canvas.Brush.Color := $00E2F5FE;
      end;
   GridProc.Canvas.FillRect(Rect);
   GridProc.Canvas.TextOut(Rect.Left + 2, Rect.Top, Column.Field.text);
end;

procedure TFLocalizar.GridPecaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if gdSelected in State then

      begin
         GridPeca.Canvas.Font.Color := clNavy;
         GridPeca.canvas.Brush.Color := $00E2F5FE;
      end;
   GridPeca.Canvas.FillRect(Rect);
   GridPeca.Canvas.TextOut(Rect.Left + 2, Rect.Top, Column.Field.text);
end;

procedure TFLocalizar.GridCliDblClick(Sender: TObject);
begin
BTSair.click;
end;

procedure TFLocalizar.GridProcDblClick(Sender: TObject);
begin
BTSair.click;
end;

procedure TFLocalizar.GridPecaDblClick(Sender: TObject);
begin
   BTsair.click;
end;

procedure TFLocalizar.FormActivate(Sender: TObject);
begin
GarantirConexao;
ETexto.SetFocus;
end;

procedure TFLocalizar.BTLocalizarEnter(Sender: TObject);
begin
BTLocalizar.ButtonColor := $00E2F5FE;
BTLocalizar.ButtonColor1 := clGray;
end;

procedure TFLocalizar.BTDeletarEnter(Sender: TObject);
begin
BTDeletar.ButtonColor := $00E2F5FE;
BTDeletar.ButtonColor1 := clGray;
end;

procedure TFLocalizar.BTSairEnter(Sender: TObject);
begin
BTSAir.ButtonColor := $00E2F5FE;
BTSair.ButtonColor1 := clGray;
end;

procedure TFLocalizar.BTLocalizarExit(Sender: TObject);
begin
BTLocalizar.ButtonColor := $00CACACA;
BTLocalizar.ButtonColor1 := $00CACACA;
end;

procedure TFLocalizar.BTDeletarExit(Sender: TObject);
begin
BTdeletar.ButtonColor := $00CACACA;
BTdeletar.ButtonColor1 := $00CACACA;
end;

procedure TFLocalizar.BTSairExit(Sender: TObject);
begin
BTSAir.ButtonColor := $00CACACA;
BTSair.ButtonColor1 := $00CACACA;
end;

end.
