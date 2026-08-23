program amortrat_mysql;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  MySqlTestConn in 'MySqlTestConn.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
    Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
