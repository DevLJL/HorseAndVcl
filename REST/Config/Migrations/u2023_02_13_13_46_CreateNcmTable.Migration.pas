unit u2023_02_13_13_46_CreateNcmTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `ncm` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(255) NOT NULL, '+
                  '   `code` varchar(8) NOT NULL, '+
                  '   `national_rate` decimal(18,4) DEFAULT NULL, '+
                  '   `imported_rate` decimal(18,4) DEFAULT NULL, '+
                  '   `state_rate` decimal(18,4) DEFAULT NULL, '+
                  '   `municipal_rate` decimal(18,4) DEFAULT NULL, '+
                  '   `cest` varchar(45) DEFAULT NULL, '+
                  '   `additional_information` text, '+
                  '   `start_of_validity` date DEFAULT NULL, '+
                  '   `end_of_validity` date DEFAULT NULL, '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `ncm_idx_created_at` (`created_at`), '+
                  '   KEY `ncm_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `ncm_fk_updated_by_acl_user_id` (`updated_by_acl_user_id`), '+
                  '   KEY `ncm_idx_cest` (`cest`), '+
                  '   CONSTRAINT `ncm_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `ncm_fk_updated_by_acl_user_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.


