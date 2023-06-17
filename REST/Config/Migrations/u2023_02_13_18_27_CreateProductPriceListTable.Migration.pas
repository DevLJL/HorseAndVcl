unit u2023_02_13_18_27_CreateProductPriceListTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `product_price_list` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `product_id` bigint NOT NULL, '+
                  '   `price_list_id` bigint NOT NULL, '+
                  '   `price` decimal(18,4) DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   UNIQUE KEY `product_price_list_unq_product_id_price_list_id` (`product_id`,`price_list_id`), '+
                  '   KEY `product_price_list_fk_product_id` (`product_id`), '+
                  '   KEY `product_price_list_fk_price_list_id` (`price_list_id`), '+
                  '   CONSTRAINT `product_price_list_fk_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `price_list` (`id`), '+
                  '   CONSTRAINT `product_price_list_fk_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
                  ' )  ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;

initialization
  TMigration.&Register;

end.

