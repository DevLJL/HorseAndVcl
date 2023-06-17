unit u2023_06_11_10_17_CreatePriceListTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `price_list` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(255) NOT NULL, '+
                  '   `short_description` varchar(255) DEFAULT NULL, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `price_list_idx_created_at` (`created_at`), '+
                  '   KEY `price_list_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `price_list_fk_updated_by_price_list_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `price_list_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `price_list_fk_updated_by_price_list_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.

