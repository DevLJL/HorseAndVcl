unit u2023_02_08_09_56_AclUser.Seeder;

interface

uses
  uBase.Migration,
  uConnMigration,
  uEnv.Rest,
  uZLConnection.Types,
  System.SysUtils,
  uQuotedStr,
  uHlp,
  uAppRest.Types;

type
  TSeeder = class(TBaseMigration)
    class function &Register: TSeeder;
  end;

implementation

function MySQLScript: String;
begin
  const LSQL = ' INSERT INTO acl_user '+
               '   (name, login, login_password, acl_role_id, flg_superuser) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s)';

  Result := Format(LSQL, [
    Q('lead'),
    Q('lead'),
    Q(Encrypt(ENCRYPTATION_KEY, 'lead321')),
    Q(1),
    Q(1)
  ]);
end;

{ TSeeder }
class function TSeeder.&Register: TSeeder;
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddSeeder(Self.UnitName, MySQLScript);
  end;
end;

initialization
  TSeeder.&Register;

end.

