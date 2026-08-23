unit Uexport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs, MyServiceThread,
  ExtCtrls, scExcelExport, UModulo;

type
  TdatabaseExportService = class(TService)
    Timer1: TTimer;
    scExcelExport1: TscExcelExport;
    procedure ServiceExecute(Sender: TService);
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  databaseExportService: TdatabaseExportService;
    { Private declarations }

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  databaseExportService.Controller(CtrlCode);
end;

function TdatabaseExportService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TdatabaseExportService.ServiceCreate(Sender: TObject);
begin

scExcelExport1.ExcelVisible:=False;

ShowMessage('Teste 2');

With Modulo do begin

 try
scExcelExport1.LoadDefaultProperties;
scExcelExport1.ExcelVisible:=False;
scExcelExport1.WorksheetName := 'Dados Clientes';
scExcelExport1.Dataset:= TBClientes;
scExcelExport1.ExportDataset;

scExcelExport1.SaveAs('C:\Users\DAM\Desktop\clientes.xlsx',ffDefault); //without file extension

finally
scExcelExport1.Disconnect(True);

end;

end;


end;

procedure TdatabaseExportService.ServiceExecute(Sender: TService);
begin

Timer1.Enabled := True;
while not Terminated do
ServiceThread.ProcessRequests(True);// wait for termination
Timer1.Enabled := False;

end;

procedure TdatabaseExportService.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
ShowMessage('Teste 1');
end;

procedure TdatabaseExportService.Timer1Timer(Sender: TObject);
begin
scExcelExport1.ExcelVisible:=False;

ShowMessage('Teste 2');

With Modulo do begin

 try
scExcelExport1.LoadDefaultProperties;
scExcelExport1.ExcelVisible:=False;
scExcelExport1.WorksheetName := 'Dados Clientes';
scExcelExport1.Dataset:= TBClientes;
scExcelExport1.ExportDataset;

scExcelExport1.SaveAs('C:\Users\DAM\Desktop\clientes.xlsx',ffDefault); //without file extension

finally
scExcelExport1.Disconnect(True);

end;

end;
end;

end.
