unit u2023_02_07_10_01_Station.Seeder;

interface

uses
  uBase.Migration,
  uConnMigration,
  uEnv.Rest,
  uZLConnection.Types;

type
  TSeeder = class(TBaseMigration)
    class function &Register: TSeeder;
  end;

implementation

{ TSeeder }
class function TSeeder.&Register: TSeeder;
const
  LMYSQL_SCRIPT = ' insert into station (name) values (''Esta��o 001''); '+
                  ' insert into station (name) values (''Esta��o 002''); '+
                  ' insert into station (name) values (''Esta��o 003''); '+
                  ' insert into station (name) values (''Esta��o 004''); '+
                  ' insert into station (name) values (''Esta��o 005''); ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddSeeder(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;

initialization
  TSeeder.&Register;

end.

