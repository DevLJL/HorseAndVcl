unit u2023_06_11_22_54_CreateAdditionalTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `additional` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(255) NOT NULL, '+
                  '   `selection_type` tinyint(4) DEFAULT NULL COMMENT ''[0-single, 1-multiple]'', '+
                  '   `price_calculation_type` tinyint(4) DEFAULT NULL COMMENT ''[0-sum, 1-greater]'', '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `additional_idx_created_at` (`created_at`), '+
                  '   KEY `additional_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `additional_fk_updated_by_additional_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `additional_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `additional_fk_updated_by_additional_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.

