unit u2023_02_21_07_48_CreateBillPayReceiveTable.Migration;

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

var
  Migration: TMigration;

implementation

{ TMigration }
class function TMigration.&Register: TMigration;
const
  LMYSQL_SCRIPT = ' CREATE TABLE `bill_pay_receive` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `batch` varchar(36) NOT NULL, '+
                  '   `type` tinyint(4) DEFAULT NULL COMMENT ''[0..1] 0-Débito, 1-Crédito'', '+
                  '   `short_description` varchar(100) NOT NULL, '+
                  '   `person_id` bigint DEFAULT NULL, '+
                  '   `chart_of_account_id` bigint DEFAULT NULL, '+
                  '   `cost_center_id` bigint DEFAULT NULL, '+
                  '   `bank_account_id` bigint NOT NULL, '+
                  '   `payment_id` bigint NOT NULL, '+
                  '   `due_date` date NOT NULL, '+
                  '   `installment_quantity` tinyint(4) NOT NULL, '+
                  '   `installment_number` tinyint(4) NOT NULL, '+
                  '   `amount` decimal(18,4) NOT NULL, '+
                  '   `discount` decimal(18,4) DEFAULT NULL, '+
                  '   `interest_and_fine` decimal(18,4) DEFAULT NULL, '+
                  '   `net_amount` decimal(18,4) NOT NULL, '+
                  '   `status` tinyint(4) NOT NULL COMMENT ''[0..2] 0-Pendente, 1-Aprovada, 2-Cancelada'', '+
                  '   `payment_date` date DEFAULT NULL, '+
                  '   `note` text, '+
                  '   `sale_id` bigint DEFAULT NULL, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `bill_pay_receive_idx_created_at` (`created_at`), '+
                  '   KEY `bill_pay_receive_idx_batch` (`batch`), '+
                  '   KEY `bill_pay_receive_idx_type` (`type`), '+
                  '   KEY `bill_pay_receive_idx_due_date` (`due_date`), '+
                  '   KEY `bill_pay_receive_idx_status` (`status`), '+
                  '   KEY `bill_pay_receive_idx_payment_date` (`payment_date`), '+
                  '   KEY `bill_pay_receive_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `bill_pay_receive_fk_updated_by_acl_role_id` (`updated_by_acl_user_id`), '+
                  '   KEY `bill_pay_receive_fk_person_id` (`person_id`), '+
                  '   KEY `bill_pay_receive_fk_chart_of_account_id` (`chart_of_account_id`), '+
                  '   KEY `bill_pay_receive_fk_cost_center_id` (`cost_center_id`), '+
                  '   KEY `bill_pay_receive_fk_bank_account_id` (`bank_account_id`), '+
                  '   KEY `bill_pay_receive_fk_payment_id` (`payment_id`), '+
                  '   KEY `bill_pay_receive_fk_sale_id` (`sale_id`), '+
                  '   CONSTRAINT `bill_pay_receive_fk_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `bank_account` (`id`) , '+
                  '   CONSTRAINT `bill_pay_receive_fk_chart_of_account_id` FOREIGN KEY (`chart_of_account_id`) REFERENCES `chart_of_account` (`id`) , '+
                  '   CONSTRAINT `bill_pay_receive_fk_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `cost_center` (`id`) , '+
                  '   CONSTRAINT `bill_pay_receive_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`) , '+
                  '   CONSTRAINT `bill_pay_receive_fk_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`id`) , '+
                  '   CONSTRAINT `bill_pay_receive_fk_person_id` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`) , '+
                  '   CONSTRAINT `bill_pay_receive_fk_sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sale` (`id`) , '+
                  '   CONSTRAINT `bill_pay_receive_fk_updated_by_acl_role_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)  '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.

