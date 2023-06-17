unit u2023_02_12_00_01_CreatePersonContactTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `person_contact` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `person_id` bigint NOT NULL, '+
                  '   `name` varchar(100) DEFAULT NULL, '+
                  '   `legal_entity_number` varchar(20) DEFAULT NULL, '+
                  '   `type` varchar(100) DEFAULT NULL, '+
                  '   `note` text, '+
                  '   `phone` varchar(40) DEFAULT NULL, '+
                  '   `email` varchar(255) DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `person_contact_fk_person_id` (`person_id`), '+
                  '   CONSTRAINT `person_contact_fk_person_id` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
                  ' )  ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;

initialization
  TMigration.&Register;

end.

