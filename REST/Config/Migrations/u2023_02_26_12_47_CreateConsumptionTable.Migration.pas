unit u2023_02_26_12_47_CreateConsumptionTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `consumption` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `number` bigint NOT NULL, '+
                  '   `flg_active` tinyint(4) DEFAULT NULL, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `consumption_idx_created_at` (`created_at`), '+
                  '   KEY `consumption_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `consumption_fk_updated_by_consumption_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `consumption_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `consumption_fk_updated_by_consumption_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
