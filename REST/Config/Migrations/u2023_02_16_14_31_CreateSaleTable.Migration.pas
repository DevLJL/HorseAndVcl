unit u2023_02_16_14_31_CreateSaleTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `sale` ( '+
                  ' `id` bigint NOT NULL AUTO_INCREMENT, '+
                  ' `person_id` bigint DEFAULT NULL, '+
                  ' `seller_id` bigint NOT NULL, '+
                  ' `carrier_id` bigint DEFAULT NULL, '+
                  ' `note` text, '+
                  ' `internal_note` text, '+
                  ' `status` tinyint DEFAULT NULL COMMENT ''[0-Pendente, 1-Concluido, 2-Cancelado]'', '+
                  ' `delivery_status` tinyint DEFAULT NULL COMMENT ''[0-Novo, 1-Recusado, 2-Agendado, 3-Preparando, 4-Em Transito, 5-Entregue, 6-Cancelado]'', '+
                  ' `type` tinyint DEFAULT NULL COMMENT ''[0-Normal, 1-Consumo, 2-Entrega]'', '+
                  ' `flg_payment_requested` tinyint DEFAULT NULL, '+
                  ' `sum_sale_item_total` decimal(15,8) DEFAULT NULL, '+
                  ' `discount` decimal(15,8) DEFAULT NULL, '+
                  ' `increase` decimal(15,8) DEFAULT NULL, '+
                  ' `freight` decimal(15,8) DEFAULT NULL, '+
                  ' `service_charge` decimal(15,8) DEFAULT NULL, '+
                  ' `cover_charge` decimal(15,8) DEFAULT NULL, '+
                  ' `total` decimal(15,8) DEFAULT NULL, '+
                  ' `money_received` decimal(15,8) DEFAULT NULL, '+
                  ' `money_change` decimal(15,8) DEFAULT NULL, '+
                  ' `amount_of_people` tinyint DEFAULT NULL, '+
                  ' `informed_legal_entity_number` varchar(20) DEFAULT NULL, '+
                  ' `consumption_number` bigint DEFAULT NULL, '+
                  ' `sale_check_id` bigint NOT NULL, '+
                  ' `sale_check_name` varchar(255) DEFAULT NULL, '+
                  ' `created_at` datetime DEFAULT NULL, '+
                  ' `updated_at` datetime DEFAULT NULL, '+
                  ' `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  ' `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  ' PRIMARY KEY (`id`), '+
                  ' KEY `sale_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  ' KEY `sale_fk_updated_by_sale_id` (`updated_by_acl_user_id`), '+
                  ' KEY `sale_fk_person_id` (`person_id`), '+
                  ' KEY `sale_fk_seller_id` (`seller_id`), '+
                  ' KEY `sale_fk_carrier_id` (`carrier_id`), '+
                  ' KEY `sale_idx_status` (`status`) /*!80000 INVISIBLE */, '+
                  ' KEY `sale_idx_delivery_status` (`delivery_status`) /*!80000 INVISIBLE */, '+
                  ' KEY `sale_idx_type` (`type`) /*!80000 INVISIBLE */, '+
                  ' KEY `sale_idx_flg_payment_requested` (`flg_payment_requested`), '+
                  ' KEY `sale_idx_consumption_number` (`consumption_number`), '+
                  ' KEY `sale_idx_sale_check_id` (`sale_check_id`), '+
                  ' KEY `sale_idx_created_at` (`created_at`), '+
                  ' CONSTRAINT `sale_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  ' CONSTRAINT `sale_fk_updated_by_sale_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`),    '+
                  ' CONSTRAINT `sale_fk_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `person` (`id`), '+
                  ' CONSTRAINT `sale_fk_person_id` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`), '+
                  ' CONSTRAINT `sale_fk_seller_id` FOREIGN KEY (`seller_id`) REFERENCES `person` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
