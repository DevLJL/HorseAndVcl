unit u2023_02_26_12_47_CreateConsumptionTable.Migration;

interface

uses
  uBase.Migration;

type
  TMigration = class(TBaseMigration)
    class function &Register: TMigration;
  end;

implementation

uses
  uConnMigration,
  uSQLBuilder.Factory,
  uEnv.Rest;

{ TMigration }

class function TMigration.&Register: TMigration;
begin
  ConnMigration.AddMigration(
    Self.UnitName,
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).Consumption.ScriptCreateTable
  );
end;

initialization
  TMigration.&Register;

end.
