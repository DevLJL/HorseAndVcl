unit u2023_02_13_18_26_CreateProductTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `product` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(255) NOT NULL, '+
                  '   `simplified_name` varchar(30) NOT NULL, '+
                  '   `type` tinyint(4) DEFAULT NULL COMMENT ''[0-product, 1-service]'', '+
                  '   `sku_code` varchar(45) NOT NULL, '+
                  '   `ean_code` varchar(45) DEFAULT NULL, '+
                  '   `manufacturing_code` varchar(45) DEFAULT NULL, '+
                  '   `identification_code` varchar(45) DEFAULT NULL, '+
                  '   `cost` decimal(18,4) DEFAULT NULL, '+
                  '   `marketup` decimal(18,4) DEFAULT NULL, '+
                  '   `price` decimal(18,4) DEFAULT NULL, '+
                  '   `current_quantity` decimal(18,4) DEFAULT NULL, '+
                  '   `minimum_quantity` decimal(18,4) DEFAULT NULL, '+
                  '   `maximum_quantity` decimal(18,4) DEFAULT NULL, '+
                  '   `gross_weight` decimal(18,4) DEFAULT NULL, '+
                  '   `net_weight` decimal(18,4) DEFAULT NULL, '+
                  '   `packing_weight` decimal(18,4) DEFAULT NULL, '+
                  '   `flg_to_move_the_stock` tinyint(4) DEFAULT NULL, '+
                  '   `flg_product_for_scales` tinyint(4) DEFAULT NULL, '+
                  '   `flg_additional` tinyint(4) DEFAULT NULL, '+
                  '   `internal_note` text, '+
                  '   `complement_note` text, '+
                  '   `flg_discontinued` tinyint(4) DEFAULT NULL, '+
                  '   `unit_id` bigint NOT NULL, '+
                  '   `ncm_id` bigint NOT NULL, '+
                  '   `category_id` bigint DEFAULT NULL, '+
                  '   `brand_id` bigint DEFAULT NULL, '+
                  '   `size_id` bigint DEFAULT NULL, '+
                  '   `storage_location_id` bigint DEFAULT NULL, '+
                  '   `genre` tinyint(4) DEFAULT NULL COMMENT ''[0-none, 1-masculine, 2-feminine, 3-unissex]'', '+
                  '   `check_value_before_insert` tinyint(4) DEFAULT NULL COMMENT ''[0-No, 1-Yes, 2-quiz]'', '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `product_idx_created_at` (`created_at`), '+
                  '   KEY `product_fk_unit_id` (`unit_id`), '+
                  '   KEY `product_fk_ncm_id` (`ncm_id`), '+
                  '   KEY `product_fk_category_id` (`category_id`), '+
                  '   KEY `product_fk_brand_id` (`brand_id`), '+
                  '   KEY `product_fk_size_id` (`size_id`), '+
                  '   KEY `product_fk_storage_location_id` (`storage_location_id`), '+
                  '   KEY `product_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `product_fk_updated_by_acl_user_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `product_fk_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`) , '+
                  '   CONSTRAINT `product_fk_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) , '+
                  '   CONSTRAINT `product_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`) , '+
                  '   CONSTRAINT `product_fk_size_id` FOREIGN KEY (`size_id`) REFERENCES `size` (`id`) , '+
                  '   CONSTRAINT `product_fk_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `storage_location` (`id`) , '+
                  '   CONSTRAINT `product_fk_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`) , '+
                  '   CONSTRAINT `product_fk_ncm_id` FOREIGN KEY (`ncm_id`) REFERENCES `ncm` (`id`) , '+
                  '   CONSTRAINT `product_fk_updated_by_acl_user_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)  '+
                  ' )  ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
