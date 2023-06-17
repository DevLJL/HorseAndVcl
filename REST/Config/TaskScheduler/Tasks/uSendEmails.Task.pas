unit uSendEmails.Task;

interface

uses
  Quick.Threads;

type
  TSendEmailsTask = class
    class procedure HangOn(const AScheduledTasks: TScheduledTasks);
  end;

const
  TASK_NAME                    = 'SendEmails';
  MAX_RETRY                    = 3;    // "X" Tentativas
  WAIT_MS_TIME_BETWEEN_RETRIES = 5000; // Esperar "X" segundos entre tentativas
  REPEAT_MIN_INTERVAL          = 3;    // Repetir a cada "X" minutos

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Quick.Commons,
  Quick.Console,
  uQueueEmail.SendPending.UseCase,
  uRepository.Factory;

procedure Execute(task : ITask);
begin
  const LSuccessfulSendCount = TQueueEmailSendPendingUseCase.Make(TRepositoryFactory.Make).Execute;
  if (LSuccessfulSendCount > 0) then
    cout('Task: "%s" successful send count (%s)',[TASK_NAME, LSuccessfulSendCount.ToString], etInfo);
end;

procedure OnException(task: ITask; aException: Exception);
begin
  cout('Task: "%s" failed (%s)',[TASK_NAME, aException.Message], etError);
end;

procedure OnRetry(task : ITask; aException : Exception; var vStopRetries : Boolean);
begin
  cout('Task: "%s" retried %d/%d (%s)',[TASK_NAME, task.NumRetries, task.MaxRetries, aException.Message], etWarning);
end;

procedure OnTerminated(task: ITask);
begin
//
end;

procedure OnExpired(task: ITask);
begin
  cout('Task: "%s" expired', [TASK_NAME], etWarning);
end;

{ TUpdateConsoleCommand }
class procedure TSendEmailsTask.HangOn(const AScheduledTasks: TScheduledTasks);
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

