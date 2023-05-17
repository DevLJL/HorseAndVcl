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
  end;

var
  TaskScheduler: TTaskScheduler;

implementation

uses
  System.SysUtils,
  uAutomaticPingInConsole.Task,
  uSendEmails.Task,
  uConnMigration,
  Vcl.Forms;

{ TTaskScheduler }
constructor TTaskScheduler.Create;
begin
  FScheduledTasks                           := TScheduledTasks.Create;
  FScheduledTasks.RemoveTaskAfterExpiration := True;
  FScheduledTasks.FaultPolicy.MaxRetries    := 5;

  // Tasks
  TAutomaticPingInConsoleTask.HangOn(FScheduledTasks);
  TSendEmailsTask.HangOn(FScheduledTasks);
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

initialization
  TaskScheduler := TTaskScheduler.Create;

finalization
  FreeAndNil(TaskScheduler);
end.


