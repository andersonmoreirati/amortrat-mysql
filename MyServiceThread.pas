unit MyServiceThread;
{ This thread frees itself when it terminates }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics;

type
  TMyServiceThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TMyServiceThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TMyServiceThread }

constructor TMyServiceThread.Create;
// Create the thread Suspended so that properties can be set before resuming the thread.
begin
  FreeOnTerminate := True;
  inherited Create(True);
end;

procedure TMyServiceThread.Execute;
const
  SecBetweenRuns = 10;
var
  Count: Integer;
begin
  { Place thread code here }
  while not Terminated do  // loop around until we should stop
  begin
    Inc(Count);
    if Count >= SecBetweenRuns then
    begin
      Count := 0;

      { place your service code here }
      { this is where the action happens }
     // SomeProcedureInAnotherUnit;

    end;
    Sleep(1000);
  end;
end;

end.
