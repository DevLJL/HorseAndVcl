unit uHandle.Exception;

interface

uses
  System.SysUtils,
  System.Classes;

type
  THandleException = class
  private
    FSender: TObject;
    FException: Exception;
    FHandleMessage: TStringList;
    function GetWindowsUser: string;
    function GetWindowsVersion: string;
    function WriteLog: THandleException;
    function ShowMessageForUser: THandleException;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(Sender: TObject; E: Exception);
    function  HandleMessage: THandleException;

    class function TranslateToLayMessage(ATechnicalMessage: String): String;
  end;

implementation

uses
  Vcl.Forms,
  Vcl.Dialogs,
  System.Types,
  Winapi.Windows,
  uApplicationError.View;

CONST
  CONNECTION_TO_SERVER_FAILED = 'uma conex�o com o servidor n�o p�de ser estabelecida';
  UNKNOWN_MYSQL_SERVER_HOST = 'unknown mysql server host';
  ACCESS_VIOLATION_AT_ADDRESS = 'access violation at address';

{ TExecuteException }

constructor THandleException.Create;
begin
  FHandleMessage := TStringList.Create;
  Application.OnException := Execute;
end;

destructor THandleException.Destroy;
begin
  if Assigned(FHandleMessage) then
    FreeAndNil(FHandleMessage);

  inherited;
end;

procedure THandleException.Execute(Sender: TObject; E: Exception);
begin
  FSender := Sender;
  FException := E;

  HandleMessage;
  WriteLog;
  ShowMessageForUser;
end;

function THandleException.ShowMessageForUser: THandleException;
var
  lStrList: TStringList;
begin
  Result := Self;

  // Exibir mensagem para o usu�rio
  lStrList := TStringList.Create;
  try
    lStrList.Add('Oops... Ocorreu um erro!');
    lStrList.AddStrings(FHandleMessage);
    lStrList.Add(EmptyStr);
    lStrList.Add('Se n�o souber como proceder, entre em contato com o administrador do sistema.');

    TApplicationErrorView.Handle(lStrList.Text);
  finally
    lStrList.Free;
  end;
end;

class function THandleException.TranslateToLayMessage(ATechnicalMessage: String): String;
begin
  Result := EmptyStr;
  ATechnicalMessage := ATechnicalMessage.ToLower.Trim;

  if (Pos(CONNECTION_TO_SERVER_FAILED, ATechnicalMessage) > 0) then
    Result := 'A conex�o com o servidor falhou.' + #13 +
              'Verifique suas configura��es de rede e internet.' + #13 +
              'Verifique se o servidor est� ligado, conectado, em rede.' + #13 +
              'Se necess�rio, reinicie seu modem de internet, servidor e terminal.';

  // Order sql por coluna n�o encontrada
  if (Pos('unknown column', ATechnicalMessage) > 0) and (Pos('order clause', ATechnicalMessage) > 0) then
    Result := 'N�o � poss�vel ordenar por esta coluna.';

  // Coluna n�o pode ser nula
  if (Pos('column', ATechnicalMessage) > 0) and (Pos('cannot be null', ATechnicalMessage) > 0) then
    Result := 'Coluna n�o pode ser nula.';

  if (Pos(ACCESS_VIOLATION_AT_ADDRESS, ATechnicalMessage) > 0) Then
    Result := 'O aplicativo tentou acessar um recurso que n�o est� dispon�vel no momento.';
end;

function THandleException.WriteLog: THandleException;
var
  lPathLogFile: string;
  lLogFile: TextFile;
begin
  Result := Self;

  // Inicializar arquivo
  lPathLogFile := GetCurrentDir + '\error_log_'+FormatDateTime('YYYY_mm', now)+'.txt';
  AssignFile(lLogFile, lPathLogFile);
  case FileExists(lPathLogFile) of
    True:  Append(lLogFile);
    False: ReWrite(lLogFile);
  end;

  // Escreve os dados no arquivo
  WriteLn(lLogFile, 'Date/Time.........: ' + DateTimeToStr(Now));
  WriteLn(lLogFile, 'Message...........: ' + FHandleMessage.Text);
  WriteLn(lLogFile, 'Classe Exception..: ' + FException.ClassName);
  WriteLn(lLogFile, 'Form..............: ' + Screen.ActiveForm.Name);
  WriteLn(lLogFile, 'Unit..............: ' + FSender.UnitName);
  WriteLn(lLogFile, 'Visual Control....: ' + Screen.ActiveControl.Name);
  WriteLn(lLogFile, 'Windows User......: ' + GetWindowsUser);
  WriteLn(lLogFile, 'Windows Version...: ' + GetWindowsVersion);
  WriteLn(lLogFile, StringOfChar('-', 70));

  // Fecha o arquivo
  CloseFile(lLogFile);
end;

function THandleException.GetWindowsUser: string;
var
  Size: DWord;
begin
  // retorna o login do usu�rio do sistema operacional
  Size := 1024;
  SetLength(result, Size);
  GetUserName(PChar(result), Size);
  SetLength(result, Size - 1);
end;

function THandleException.GetWindowsVersion: string;
begin
  case System.SysUtils.Win32MajorVersion of
    5:
      case System.SysUtils.Win32MinorVersion of
        1: result := 'Windows XP';
      end;
    6:
      case System.SysUtils.Win32MinorVersion of
        0: result := 'Windows Vista';
        1: result := 'Windows 7';
        2: result := 'Windows 8';
        3: result := 'Windows 8.1';
      end;
    10:
      case System.SysUtils.Win32MinorVersion of
        0: result := 'Windows 10';
      end;
  end;
end;

function THandleException.HandleMessage: THandleException;
var
  lLayMessage: String;
begin
  Result := Self;
  FHandleMessage.Clear;

  // Mensagem Leiga
  lLayMessage := TranslateToLayMessage(FException.Message.Trim.ToLower);
  if not lLayMessage.IsEmpty then
    FHandleMessage.Add(lLayMessage);

  // Mesagem T�cnica
  FHandleMessage.Add('');
  FHandleMessage.Add('Mensagem t�cnica:');
  FHandleMessage.Add(FException.Message);
  if (FException.ClassName.ToLower.Trim <> 'exception') then
  begin
    FHandleMessage.Add('');
    FHandleMessage.Add('Aux�lio t�cnico:');
    FHandleMessage.Add(FException.ClassName);
  end;
end;

var
  AppException: THandleException;

initialization
  AppException := THandleException.Create;

finalization
  AppException.Free;

end.
