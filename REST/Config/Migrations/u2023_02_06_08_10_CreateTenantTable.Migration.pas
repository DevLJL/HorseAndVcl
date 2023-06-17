unit u2023_02_06_08_10_CreateTenantTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `tenant` ( '+
                  ' `id` bigint NOT NULL AUTO_INCREMENT, '+
                  ' `name` varchar(255) NOT NULL, '+
                  ' `alias_name` varchar(255) NOT NULL, '+
                  ' `legal_entity_number` varchar(20) NOT NULL, '+
                  ' `icms_taxpayer` tinyint DEFAULT NULL COMMENT ''[0..2] 0-Não contribuinte de icms, 1-Contribuinte de icms, 2-Isento de icms'', '+
                  ' `state_registration` varchar(20) DEFAULT NULL, '+
                  ' `municipal_registration` varchar(20) DEFAULT NULL, '+
                  ' `zipcode` varchar(10) DEFAULT NULL, '+
                  ' `address` varchar(255) NOT NULL, '+
                  ' `address_number` varchar(15) DEFAULT NULL, '+
                  ' `complement` varchar(255) DEFAULT NULL, '+
                  ' `district` varchar(255) NOT NULL, '+
                  ' `city_id` bigint NOT NULL, '+
                  ' `reference_point` varchar(255) DEFAULT NULL, '+
                  ' `phone_1` varchar(14) NOT NULL, '+
                  ' `phone_2` varchar(14) DEFAULT NULL, '+
                  ' `phone_3` varchar(14) DEFAULT NULL, '+
                  ' `company_email` varchar(255) DEFAULT NULL, '+
                  ' `financial_email` varchar(255) DEFAULT NULL, '+
                  ' `internet_page` varchar(255) DEFAULT NULL, '+
                  ' `note` text, '+
                  ' `bank_note` text, '+
                  ' `commercial_note` text, '+
                  ' `send_email_app_default` tinyint(4) DEFAULT NULL, '+
                  ' `send_email_email` varchar(255) DEFAULT NULL, '+
                  ' `send_email_identification` varchar(255) DEFAULT NULL, '+
                  ' `send_email_user` varchar(255) DEFAULT NULL, '+
                  ' `send_email_password` varchar(100) DEFAULT NULL, '+
                  ' `send_email_smtp` varchar(100) DEFAULT NULL, '+
                  ' `send_email_port` varchar(10) DEFAULT NULL, '+
                  ' `send_email_ssl` tinyint(4) DEFAULT NULL, '+
                  ' `send_email_tls` tinyint(4) DEFAULT NULL, '+
                  ' `send_email_email_accountant` varchar(255) DEFAULT NULL, '+
                  ' `send_email_footer_message` text, '+
                  ' `send_email_header_message` text, '+
                  ' PRIMARY KEY (`id`), '+
                  ' KEY `tenant_fk_city_id` (`city_id`), '+
                  ' CONSTRAINT `tenant_fk_city_id` FOREIGN KEY (`city_id`) REFERENCES `city` (`id`) '+
                  ' )  ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;

initialization
  TMigration.&Register;

end.
