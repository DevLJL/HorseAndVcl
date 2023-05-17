unit u2023_02_13_13_47_Ncm.Seeder;

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
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).Ncm.ScriptSeedTable
  );
end;

initialization
  TSeeder.&Register;

end.


