unit u2023_02_15_19_20_CreatePaymentTable.Migration;

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
  uEnv.Rest,
  System.SysUtils;

{ TMigration }

class function TMigration.&Register: TMigration;
begin
  const lAux =  TSQLBuilderFactory.Make(ENV_REST.DriverDB).Payment.ScriptCreateTable;
  ConnMigration.AddMigration(
    Self.UnitName,
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).Payment.ScriptCreateTable
  );
end;

initialization
  TMigration.&Register;

end.
