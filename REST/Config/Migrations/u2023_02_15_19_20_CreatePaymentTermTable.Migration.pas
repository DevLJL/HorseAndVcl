unit u2023_02_15_19_20_CreatePaymentTermTable.Migration;

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
  uEnv.Rest,
  System.SysUtils;

{ TMigration }

class function TMigration.&Register: TMigration;
begin
  ConnMigration.AddMigration(
    Self.UnitName,
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).Payment.ScriptCreatePaymentTermTable
  );
end;

initialization
  TMigration.&Register;

end.
