unit u2023_02_16_14_33_CreateSalePaymentTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `sale_payment` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `sale_id` bigint NOT NULL, '+
                  '   `collection_uuid` char(36) NOT NULL, '+
                  '   `payment_id` bigint NOT NULL, '+
                  '   `bank_account_id` bigint NOT NULL, '+
                  '   `amount` decimal(18,4) NOT NULL, '+
                  '   `note` text, '+
                  '   `due_date` DATE NOT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `sale_payment_fk_sale_id` (`sale_id`), '+
                  '   KEY `sale_payment_fk_payment_id` (`payment_id`), ' +
                  '   KEY `sale_payment_fk_bank_account_id` (`bank_account_id`), ' +
                  '   CONSTRAINT `sale_payment_fk_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `bank_account` (`id`), ' +
                  '   CONSTRAINT `sale_payment_fk_sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
                  ' )  ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
