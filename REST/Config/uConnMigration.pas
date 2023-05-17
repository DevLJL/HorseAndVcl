unit uConnMigration;

interface

uses
  uZLConnection.Interfaces;

type
  TConnMigration = class
  private
    FConn: IZLConnection;
  public
    constructor Create;
    function AddMigration(const ADescription, AScript: String): TConnMigration;
    function AddSeeder(const ADescription, AScript: String): TConnMigration;
    procedure RunPendingMigrationsAndSeeders;
  end;

var
  ConnMigration: TConnMigration;

implementation

uses
  uConnection.Factory,
  System.SysUtils;

{ TConnMigration }

function TConnMigration.AddMigration(const ADescription, AScript: String): TConnMigration;
var
  LDescription: String;
begin
  Result := Self;

  // Formatar descrição
  LDescription := ADescription;
  LDescription := StringReplace(LDescription, '.Migration', '', [rfReplaceAll]);
  if (Copy(LDescription, 1,1) = 'u') then
    LDescription := Copy(LDescription,2);

  FConn.AddMigration(LDescription, AScript);
end;

function TConnMigration.AddSeeder(const ADescription, AScript: String): TConnMigration;
var
  LDescription: String;
begin
  // Formatar descrição
  LDescription := ADescription;
  LDescription := StringReplace(LDescription, '.Seeder', '', [rfReplaceAll]);
  if (Copy(LDescription, 1,1) = 'u') then
    LDescription := Copy(LDescription,2);

  FConn.AddSeeder(LDescription, AScript);
end;

constructor TConnMigration.Create;
begin
  inherited Create;
  FConn := TConnectionFactory.Make;
end;

procedure TConnMigration.RunPendingMigrationsAndSeeders;
begin
  FConn.RunPendingMigrations;
  FConn.RunPendingSeeders;
  Self.Free;
end;

initialization
  ConnMigration := TConnMigration.Create;

end.
