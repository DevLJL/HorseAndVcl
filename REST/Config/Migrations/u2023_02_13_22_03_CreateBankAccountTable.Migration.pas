unit u2023_02_13_22_03_CreateBankAccountTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `bank_account` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(255) NOT NULL, '+
                  '   `bank_id` bigint NOT NULL, '+
                  '   `note` text, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `bank_account_idx_created_at` (`created_at`), '+
                  '   KEY `bank_account_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `bank_account_fk_updated_by_acl_role_id` (`updated_by_acl_user_id`), '+
                  '   KEY `bank_account_fk_bank_id` (`bank_id`), '+
                  '   CONSTRAINT `bank_account_fk_bank_id` FOREIGN KEY (`bank_id`) REFERENCES `bank` (`id`), '+
                  '   CONSTRAINT `bank_account_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `bank_account_fk_updated_by_acl_role_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)  '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.


