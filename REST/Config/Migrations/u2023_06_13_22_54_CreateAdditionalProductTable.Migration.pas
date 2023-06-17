unit u2023_06_13_22_54_CreateAdditionalProductTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `additional_product` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `additional_id` bigint NOT NULL, '+
                  '   `product_id` bigint NOT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `additional_product_fk_additional_id` (`additional_id`), '+
                  '   KEY `additional_product_fk_product_id` (`product_id`), '+
                  '   CONSTRAINT `additional_product_fk_additional_id` FOREIGN KEY (`additional_id`) REFERENCES `additional` (`id`) ON DELETE CASCADE ON UPDATE CASCADE, '+
                  '   CONSTRAINT `additional_product_fk_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) '+
                  ' )  ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;

initialization
  TMigration.&Register;

end.

