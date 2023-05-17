unit u2023_02_13_12_33_Unit.Seeder;

interface

uses
  uBase.Migration;

type
  TSeeder = class(TBaseMigration)
    class function &Register: TSeeder;
  end;

implementation

uses
  uConnMigration,
  uSQLBuilder.Factory,
  uEnv.Rest,
  System.SysUtils;

{ TSeeder }

class function TSeeder.&Register: TSeeder;
begin
  ConnMigration.AddSeeder(
    Self.UnitName,
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).&Unit.ScriptSeedTable
  );
end;

initialization
  TSeeder.&Register;

end.
