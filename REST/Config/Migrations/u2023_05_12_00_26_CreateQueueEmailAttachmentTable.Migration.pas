unit u2023_05_12_00_26_CreateQueueEmailAttachmentTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `queue_email_attachment` ( '+
                  ' `id` bigint NOT NULL AUTO_INCREMENT, '+
                  ' `queue_email_id` bigint NOT NULL, '+
                  ' `file_name` varchar(255) NOT NULL, '+
                  ' `base64` text NOT NULL, '+
                  ' PRIMARY KEY (`id`), '+
                  ' KEY `queue_email_attachment_fk_queue_email_id` (`queue_email_id`), '+
                  ' CONSTRAINT `queue_email_attachment_fk_queue_email_id` FOREIGN KEY (`queue_email_id`) REFERENCES `queue_email` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.

