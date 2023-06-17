unit u2023_02_08_09_55_CreateAclUserTable.Migration;

interface

uses
  uBase.Migration,
  uConnMigration,
  uEnv.Rest,
  uZLConnection.Types;

type
  TMigration = class(TBaseMigration)
    class function &Register: TMigration;
  end;

implementation

{ TMigration }
class function TMigration.&Register: TMigration;
const
  LMYSQL_SCRIPT = ' CREATE TABLE `acl_user` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(100) NOT NULL, '+
                  '   `login` varchar(100) NOT NULL, '+
                  '   `login_password` varchar(100) NOT NULL, '+
                  '   `acl_role_id` bigint NOT NULL, '+
                  '   `flg_superuser` tinyint(4) DEFAULT NULL, '+
                  '   `seller_id` bigint DEFAULT NULL, '+
                  '   `last_token` text, '+
                  '   `last_expiration` datetime DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   UNIQUE KEY `login_UNIQUE` (`login`), '+
                  '   KEY `acl_user_fk_acl_role_id` (`acl_role_id`), '+
                  '   CONSTRAINT `acl_user_fk_acl_role_id` FOREIGN KEY (`acl_role_id`) REFERENCES `acl_role` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.

