unit u2023_05_12_00_25_CreateQueueEmailTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `queue_email` ('+
                  '   `id` bigint NOT NULL AUTO_INCREMENT,'+
                  '   `uuid` char(36) NOT NULL COMMENT ''Identificação'','+
                  '   `reply_to` text COMMENT ''Exemplo de preenchimento: contato1@email.com nome1; contato2@email.com nome2; contato3@email.com nome3;'','+
                  '   `priority` tinyint DEFAULT ''2'' COMMENT ''[0..4] 0-Muito Alta, 1-Alta, 2-Normal, 3-Baixa, 4-Muito Baixa'','+
                  '   `subject` varchar(255) NOT NULL,'+
                  '   `message` text,'+
                  '   `sent` tinyint DEFAULT NULL COMMENT ''[0..2] 0-Não enviado, 1-Enviado, 2-Erro'','+
                  '   `sent_error` text,'+
                  '   `current_retries` tinyint DEFAULT NULL,'+
                  '   `created_at` datetime NOT NULL,'+
                  '   `updated_at` datetime DEFAULT NULL,'+
                  '   PRIMARY KEY (`id`),'+
                  '   UNIQUE KEY `queue_email_unq_uuid` (`uuid`),'+
                  '   KEY `queue_email_idx_sent` (`sent`)'+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.

