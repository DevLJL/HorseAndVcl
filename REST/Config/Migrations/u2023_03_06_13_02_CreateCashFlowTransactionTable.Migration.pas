unit u2023_03_06_13_02_CreateCashFlowTransactionTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `cash_flow_transaction` ( '+
                  ' `id` bigint NOT NULL AUTO_INCREMENT, '+
                  ' `cash_flow_id` bigint NOT NULL, '+
                  ' `flg_manual_transaction` tinyint DEFAULT NULL, '+
                  ' `transaction_date` datetime NOT NULL, '+
                  ' `history` varchar(80) NOT NULL, '+
                  ' `type` tinyint DEFAULT NULL COMMENT ''[0-Debito, 1-Credito]'', '+
                  ' `amount` decimal(18,4) DEFAULT NULL, '+
                  ' `payment_id` bigint NOT NULL, '+
                  ' `note` text, '+
                  ' `sale_id` bigint DEFAULT NULL, '+
                  ' `person_id` bigint DEFAULT NULL, '+
                  ' PRIMARY KEY (`id`), '+
                  ' KEY `cash_flow_transaction_fk_cash_flow_id` (`cash_flow_id`), '+
                  ' KEY `cash_flow_transaction_fk_payment_id` (`payment_id`), '+
                  ' KEY `cash_flow_transaction_fk_sale_id` (`sale_id`), '+
                  ' KEY `cash_flow_transaction_fk_person_id` (`person_id`), '+
                  ' CONSTRAINT `cash_flow_transaction_fk_cash_flow_id` FOREIGN KEY (`cash_flow_id`) REFERENCES `cash_flow` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, '+
                  ' CONSTRAINT `cash_flow_transaction_fk_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`id`), '+
                  ' CONSTRAINT `cash_flow_transaction_fk_person_id` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`), '+
                  ' CONSTRAINT `cash_flow_transaction_fk_sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sale` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
