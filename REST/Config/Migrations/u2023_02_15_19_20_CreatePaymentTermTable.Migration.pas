unit u2023_02_15_19_20_CreatePaymentTermTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `payment_term` ( '+
                  ' `id` bigint NOT NULL AUTO_INCREMENT, '+
                  ' `payment_id` bigint NOT NULL, '+
                  ' `description` varchar(255) DEFAULT NULL, '+
                  ' `number_of_installments` smallint DEFAULT NULL, '+
                  ' `interval_between_installments` smallint DEFAULT NULL, '+
                  ' `first_in` smallint DEFAULT NULL, '+
                  ' PRIMARY KEY (`id`), '+
                  ' KEY `payment_term_fk_payment_id` (`payment_id`), '+
                  ' CONSTRAINT `payment_term_fk_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
