unit u2023_04_18_12_14_CreateDepartmentTable.Migration;

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
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).Department.ScriptCreateTable
  );
end;

initialization
  TMigration.&Register;

end.

