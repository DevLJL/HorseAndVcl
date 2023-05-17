unit uTestConnection;

interface

uses
  uZLConnection.Interfaces;

type
  TTestConnection = class
  private
    FConn: IZLConnection;
  public
    constructor Create;
    function Conn: IZLConnection;
  end;

var
  TestConnection: TTestConnection;

implementation

{ TTestConnection }

uses
  uConnection.Factory;

function TTestConnection.Conn: IZLConnection;
begin
  Result := FConn;
end;

constructor TTestConnection.Create;
begin
  inherited Create;
  FConn := TConnectionFactory.Make;
end;

initialization
  TestConnection := TTestConnection.Create;

finalization
  TestConnection.Free;
end.
