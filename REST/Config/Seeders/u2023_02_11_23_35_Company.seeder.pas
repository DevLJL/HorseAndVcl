unit u2023_02_11_23_35_Company.Seeder;

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
  uCompany.SQLBuilder.Interfaces,
  uSQLBuilder.Factory,
  uEnv.Rest,
  System.SysUtils;

{ TSeeder }

class function TSeeder.&Register: TSeeder;
begin
  ConnMigration.AddSeeder(
    Self.UnitName,
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).Company.ScriptSeedTable
  );
end;

initialization
  TSeeder.&Register;

end.
