unit u2023_02_15_19_20_CreatePaymentTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `payment` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(100) NOT NULL, '+
                  '   `flg_post_as_received` tinyint(4) DEFAULT NULL, '+
                  '   `flg_active` tinyint(4) DEFAULT NULL, '+
                  '   `flg_active_at_pos` tinyint(4) DEFAULT NULL, '+
                  '   `bank_account_default_id` bigint NOT NULL, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `payment_idx_created_at` (`created_at`), '+
                  '   KEY `payment_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `payment_fk_updated_by_acl_role_id` (`updated_by_acl_user_id`), '+
                  '   KEY `payment_fk_bank_account_default_id` (`bank_account_default_id`), '+
                  '   CONSTRAINT `payment_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `payment_fk_updated_by_acl_role_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `payment_fk_bank_account_default_id` FOREIGN KEY (`bank_account_default_id`) REFERENCES `bank_account` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
