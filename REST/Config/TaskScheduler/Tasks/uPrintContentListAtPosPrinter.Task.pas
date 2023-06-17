unit uPrintContentListAtPosPrinter.Task;

interface

uses
  Quick.Threads;

type
  TPrintContentListAtPosPrinterTask = class
    class procedure HangOn(const AScheduledTasks: TScheduledTasks);
  end;

const
  TASK_NAME                    = 'PrintContentListAtPosPrinter';
  MAX_RETRY                    = 3;    // "X" Tentativas
  WAIT_MS_TIME_BETWEEN_RETRIES = 3000; // Esperar "X" segundos entre tentativas
  REPEAT_MS_INTERVAL           = 750;  // Repetir a cada "X" milisegundos

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Quick.Commons,
  Quick.Console,
  uCache,
  uPosPrinter.PrintContent.UseCase,
  uRepository.Factory;

procedure Execute(task : ITask);
begin
  if (Cache.PosPrinterContentList.Count <= 0) then
    Exit;

  cout('Task: "%s" started. Documents to print "%d"', [TASK_NAME, Cache.PosPrinterContentList.Count], etDebug);
  TPosPrinterPrintContentUseCase
    .Make(TRepositoryFactory.Make.PosPrinter)
    .Execute(Cache.PosPrinterContentList);
end;

procedure OnException(task: ITask; aException: Exception);
begin
  cout('Task: "%s" failed (%s)',[TASK_NAME, aException.Message], etError);
end;

procedure OnRetry(task : ITask; aException : Exception; var vStopRetries : Boolean);
begin
  cout('Task: "%s" retried %d times (%s)',[TASK_NAME, task.MaxRetries, aException.Message], etWarning);
end;

procedure OnExpired(task: ITask);
begin
  cout('Task: "%s" expired', [TASK_NAME], etWarning);
end;

procedure OnTerminated(task: ITask);
begin
//
end;

{ TUpdateConsoleCommand }
class procedure TPrintContentListAtPosPrinterTask.HangOn(const AScheduledTasks: TScheduledTasks);
begin
   AScheduledTasks
    .AddTask      (TASK_NAME, [], True, Execute)
    .WaitAndRetry (MAX_RETRY, WAIT_MS_TIME_BETWEEN_RETRIES)
    .OnException  (OnException)
    .OnRetry      (OnRetry)
    .OnTerminated (OnTerminated)
    .OnExpired    (OnExpired)
    .StartAt      (IncSecond(Now, 10))
    .RepeatEvery  (REPEAT_MS_INTERVAL, TTimeMeasure.tmMilliseconds);
end;

end.

