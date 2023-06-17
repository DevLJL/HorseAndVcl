unit u2023_02_13_18_01_Size.Seeder;

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
  LMYSQL_SCRIPT = '';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddSeeder(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;

initialization
  TSeeder.&Register;

end.
