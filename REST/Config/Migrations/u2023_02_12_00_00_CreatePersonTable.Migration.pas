unit u2023_02_12_00_00_CreatePersonTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `person` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(255) NOT NULL, '+
                  '   `alias_name` varchar(255) NOT NULL, '+
                  '   `legal_entity_number` varchar(20) DEFAULT NULL, '+
                  '   `icms_taxpayer` tinyint DEFAULT NULL COMMENT ''[0..2] 0-Não contribuinte de icms, 1-Contribuinte de icms, 2-Isento de icms'', '+
                  '   `state_registration` varchar(20) DEFAULT NULL, '+
                  '   `municipal_registration` varchar(20) DEFAULT NULL, '+
                  '   `zipcode` varchar(10) DEFAULT NULL, '+
                  '   `address` varchar(255) DEFAULT NULL, '+
                  '   `address_number` varchar(15) DEFAULT NULL, '+
                  '   `complement` varchar(255) DEFAULT NULL, '+
                  '   `district` varchar(255) DEFAULT NULL, '+
                  '   `city_id` bigint DEFAULT NULL, '+
                  '   `reference_point` varchar(255) DEFAULT NULL, '+
                  '   `phone_1` varchar(14) DEFAULT NULL, '+
                  '   `phone_2` varchar(14) DEFAULT NULL, '+
                  '   `phone_3` varchar(14) DEFAULT NULL, '+
                  '   `company_email` varchar(255) DEFAULT NULL, '+
                  '   `financial_email` varchar(255) DEFAULT NULL, '+
                  '   `internet_page` varchar(255) DEFAULT NULL, '+
                  '   `note` text, '+
                  '   `bank_note` text, '+
                  '   `commercial_note` text, '+
                  '   `flg_customer` tinyint DEFAULT NULL, '+
                  '   `flg_seller` tinyint DEFAULT NULL, '+
                  '   `flg_supplier` tinyint DEFAULT NULL, '+
                  '   `flg_carrier` tinyint DEFAULT NULL, '+
                  '   `flg_technician` tinyint DEFAULT NULL, '+
                  '   `flg_employee` tinyint DEFAULT NULL, '+
                  '   `flg_other` tinyint DEFAULT NULL, '+
                  '   `flg_final_customer` tinyint DEFAULT NULL, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `person_idx_created_at` (`created_at`), '+
                  '   KEY `person_fk_city_id` (`city_id`), '+
                  '   KEY `person_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `person_fk_updated_by_acl_role_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `person_fk_city_id` FOREIGN KEY (`city_id`) REFERENCES `city` (`id`), '+
                  '   CONSTRAINT `person_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `person_fk_updated_by_acl_role_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.

