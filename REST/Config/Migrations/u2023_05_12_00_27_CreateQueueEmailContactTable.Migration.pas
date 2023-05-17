unit u2023_05_12_00_27_CreateQueueEmailContactTable.Migration;

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
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).QueueEmail.ScriptCreateQueueEmailContactTable
  );
end;

initialization
  TMigration.&Register;

end.

