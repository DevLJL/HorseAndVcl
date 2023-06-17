unit u2023_02_13_22_30_CreateChartOfAccountTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `chart_of_account` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(100) NOT NULL, '+
                  '   `hierarchy_code` varchar(100) NOT NULL, '+
                  '   `flg_analytical` tinyint(4) DEFAULT NULL, '+
                  '   `note` text, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `chart_of_account_idx_created_at` (`created_at`), '+
                  '   KEY `chart_of_account_idx_flg_analytical` (`flg_analytical`), '+
                  '   KEY `chart_of_account_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `chart_of_account_fk_updated_by_acl_role_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `chart_of_account_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `chart_of_account_fk_updated_by_acl_role_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)  '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
