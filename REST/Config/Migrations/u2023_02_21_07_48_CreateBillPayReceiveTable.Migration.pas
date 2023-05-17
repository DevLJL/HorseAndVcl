unit u2023_02_21_07_48_CreateBillPayReceiveTable.Migration;

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
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).BillPayReceive.ScriptCreateTable
  );
end;

initialization
  TMigration.&Register;

end.

