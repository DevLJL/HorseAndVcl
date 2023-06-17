unit u2023_02_13_18_00_CreateSizeTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `size` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(255) NOT NULL, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `size_idx_created_at` (`created_at`), '+
                  '   KEY `size_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `size_fk_updated_by_size_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `size_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `size_fk_updated_by_size_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
