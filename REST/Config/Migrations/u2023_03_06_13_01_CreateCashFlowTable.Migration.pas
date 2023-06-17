unit u2023_03_06_13_01_CreateCashFlowTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `cash_flow` ( '+
                  ' `id` bigint NOT NULL AUTO_INCREMENT, '+
                  ' `station_id` bigint NOT NULL, '+
                  ' `opening_balance_amount` decimal(18,4) DEFAULT NULL, '+
                  ' `final_balance_amount` decimal(18,4) DEFAULT NULL, '+
                  ' `opening_date` datetime NOT NULL, '+
                  ' `closing_date` datetime DEFAULT NULL, '+
                  ' `closing_note` text, '+
                  ' `created_at` datetime DEFAULT NULL, '+
                  ' `updated_at` datetime DEFAULT NULL, '+
                  ' `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  ' `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  ' PRIMARY KEY (`id`), '+
                  ' KEY `cash_flow_idx_created_at` (`created_at`), '+
                  ' KEY `cash_flow_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  ' KEY `cash_flow_fk_updated_by_cash_flow_id` (`updated_by_acl_user_id`), '+
                  ' KEY `cash_flow_fk_station_id` (`station_id`), '+
                  ' CONSTRAINT `cash_flow_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  ' CONSTRAINT `cash_flow_fk_station_id` FOREIGN KEY (`station_id`) REFERENCES `station` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION, '+
                  ' CONSTRAINT `cash_flow_fk_updated_by_cash_flow_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
