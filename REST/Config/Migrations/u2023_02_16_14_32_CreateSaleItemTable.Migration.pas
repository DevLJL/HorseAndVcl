unit u2023_02_16_14_32_CreateSaleItemTable.Migration;

interface

uses
  uBase.Migration;

type
  TMigration = class(TBaseMigration)
    class function &Register: TMigration;
  end;

var
  Migration: TMigration;

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
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).Sale.ScriptCreateSaleItemTable
  );
end;

initialization
  TMigration.&Register;

end.
