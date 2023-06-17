unit uClientSocket;

interface

uses
  GenericSocket,
  GenericSocket.Interfaces;

type
  TClientSocket = class
  private
    FClientSocket: IGenericSocket;
    function  Notification(Message: String): String;
  public
    constructor Create;
  end;

var
  ClientSocket: TClientSocket;
const
  SOCKET_HOST = 'localhost';
  SOCKET_PORT = 8050;
  ANSWERED = 'Answered';

implementation

{ TClientSocket }

uses
  uHlp,
  uApplicationError.View,
  Vcl.Dialogs,
  uToast.View;

constructor TClientSocket.Create;
begin
  inherited Create;
  FClientSocket := TGenericSocket.New;
  FClientSocket.SocketClient
    .RegisterCallBack('/notification', Notification)
    .Connect(SOCKET_HOST, SOCKET_PORT, '@XXX');

  if not FClientSocket.SocketClient.Connected then
    TApplicationErrorView.Handle('Falhou na conexão Sockets com o Servidor.');
end;

function TClientSocket.Notification(Message: String): String;
begin
  ShowMessage('Recebi ' + Message + ' e Respondi.');
  Result := ANSWERED;
end;

initialization
  //ClientSocket := TClientSocket.Create;

finalization
  //ClientSocket.Free;

end.
