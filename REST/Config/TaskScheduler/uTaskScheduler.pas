unit uTaskScheduler;

interface

uses
  Quick.Commons,
  Quick.Console,
  Quick.Threads;

type
  TTaskScheduler = class
  private
    FScheduledTasks: TScheduledTasks;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    function Tasks: TScheduledTasks;
  end;

var
  TaskScheduler: TTaskScheduler;

implementation

uses
  System.SysUtils,
  uConnMigration,
  Vcl.Forms,
  uAutomaticPingInConsole.Task,
  uSendEmails.Task,
  uPrintContentListAtPosPrinter.Task,
  uEnv.Rest;

{ TTaskScheduler }
constructor TTaskScheduler.Create;
begin
  FScheduledTasks                           := TScheduledTasks.Create;
  FScheduledTasks.RemoveTaskAfterExpiration := True;
  FScheduledTasks.FaultPolicy.MaxRetries    := 5;

  TAutomaticPingInConsoleTask.HangOn(FScheduledTasks);
  if ENV_REST.SendEmailsTask then TSendEmailsTask.HangOn(FScheduledTasks);
  if ENV_REST.PosPrinterTask then TPrintContentListAtPosPrinterTask.HangOn(FScheduledTasks);
end;

destructor TTaskScheduler.Destroy;
begin
  FScheduledTasks.Free;
  inherited;
end;

procedure TTaskScheduler.Start;
begin
  FScheduledTasks.Start;
end;

function TTaskScheduler.Tasks: TScheduledTasks;
begin
  Result := FScheduledTasks;
end;

initialization
  TaskScheduler := TTaskScheduler.Create;

finalization
  FreeAndNil(TaskScheduler);
end.


