unit u2023_02_13_21_57_CreateCostCenterTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `cost_center` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(255) NOT NULL, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `cost_center_idx_created_at` (`created_at`), '+
                  '   KEY `cost_center_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `cost_center_fk_updated_by_cost_center_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `cost_center_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `cost_center_fk_updated_by_cost_center_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
