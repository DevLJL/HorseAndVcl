unit u2023_02_08_09_20_CreateAclRoleTable.Migration;

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
  const lAux = TSQLBuilderFactory.Make(ENV_REST.DriverDB).AclRole.ScriptCreateTable;
  ConnMigration.AddMigration(
    Self.UnitName,
    TSQLBuilderFactory.Make(ENV_REST.DriverDB).AclRole.ScriptCreateTable
  );
end;

initialization
  TMigration.&Register;

end.

