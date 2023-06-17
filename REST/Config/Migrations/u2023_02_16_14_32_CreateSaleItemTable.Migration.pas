unit u2023_02_16_14_32_CreateSaleItemTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `sale_item` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `sale_id` bigint NOT NULL, '+
                  '   `product_id` bigint NOT NULL, '+
                  '   `quantity` decimal(18,4) DEFAULT NULL, '+
                  '   `price` decimal(18,4) DEFAULT NULL, '+
                  '   `unit_discount` decimal(18,4) DEFAULT NULL, '+
                  '   `total` decimal(18,4) DEFAULT NULL, '+
                  '   `seller_id` bigint NOT NULL, '+
                  '   `note` text, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `sale_item_fk_sale_id` (`sale_id`), '+
                  '   KEY `sale_item_fk_product_id` (`product_id`), ' +
                  '   CONSTRAINT `sale_item_fk_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`), ' +
                  '   CONSTRAINT `sale_item_fk_sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
                  ' )  ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
