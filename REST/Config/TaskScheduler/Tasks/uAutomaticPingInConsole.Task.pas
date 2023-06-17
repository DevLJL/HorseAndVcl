unit uAutomaticPingInConsole.Task;

interface

uses
  Quick.Threads;

type
  TAutomaticPingInConsoleTask = class
    class procedure HangOn(const AScheduledTasks: TScheduledTasks);
  end;

const
  TASK_NAME                    = 'AutomaticPingInConsole';
  MAX_RETRY                    = 3;    // "X" Tentativas
  WAIT_MS_TIME_BETWEEN_RETRIES = 5000; // Esperar "X" segundos entre tentativas
  REPEAT_MIN_INTERVAL          = 30;   // Repetir a cada "X" minutos

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Quick.Commons,
  Quick.Console,
  System.Classes;

procedure Execute(task : ITask);
begin
  cout('Task: "%s" started', [TASK_NAME], etDebug);
end;

procedure OnException(task: ITask; aException: Exception);
begin
  cout('Task: "%s" failed (%s)',[TASK_NAME, aException.Message], etError);
end;

procedure OnRetry(task : ITask; aException : Exception;  var vStopRetries : Boolean);
begin
  if not aException.Message.Contains('Division by zero') then
    vStopRetries := True
  else
    cout('Task: "%s" retried %d/%d (%s)',[TASK_NAME, task.NumRetries, task.MaxRetries, aException.Message], etWarning);
end;

procedure OnTerminated(task: ITask);
begin
  cout('Task: "%s" at %s finished', [TASK_NAME, DateTimeToStr(Now)], etDebug);
end;

procedure OnExpired(task: ITask);
begin
  cout('Task: "%s" expired', [TASK_NAME], etWarning);
end;

{ TUpdateConsoleCommand }
class procedure TAutomaticPingInConsoleTask.HangOn(const AScheduledTasks: TScheduledTasks);
begin
  AScheduledTasks
    .AddTask      (TASK_NAME, [], True, Execute)
    .WaitAndRetry (MAX_RETRY, WAIT_MS_TIME_BETWEEN_RETRIES)
    .OnException  (OnException)
    .OnRetry      (OnRetry)
    .OnTerminated (OnTerminated)
    .OnExpired    (OnExpired)
    .StartAt      (IncMinute(Now, REPEAT_MIN_INTERVAL))
    .RepeatEvery  (REPEAT_MIN_INTERVAL, TTimeMeasure.tmMinutes);
end;

end.

