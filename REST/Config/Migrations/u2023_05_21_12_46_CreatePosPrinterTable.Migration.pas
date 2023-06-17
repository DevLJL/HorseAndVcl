unit u2023_05_21_12_46_CreatePosPrinterTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `pos_printer` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(100) NOT NULL, '+
                  '   `model` tinyint(4) NOT NULL COMMENT ''[0..15] [0=ppmTexto, 1=ppmEscPosEpson, 2=ppmEscBematech, '+
                  '    3=ppmEscDaruma, 4=ppmEscVox, 5=ppmEscDiebold, 6=ppmEscEpsonP2, 7=ppmCustomPos, 8=ppmEscPosStar, '+
                  '    9=ppmEscZJiang, 10=ppmEscGPrinter, 11=ppmEscDatecs, 12=ppmEscSunmi, 13=ppmExterno, 14=ppmCanvas, 99=None]'', '+
                  '   `port` varchar(100) NOT NULL, '+
                  '   `columns` tinyint(4) NOT NULL, '+
                  '   `space_between_lines` tinyint(4) DEFAULT NULL, '+
                  '   `buffer` tinyint(4) DEFAULT NULL, '+
                  '   `font_size` tinyint(4) DEFAULT NULL, '+
                  '   `blank_lines_to_end` tinyint(4) DEFAULT NULL, '+
                  '   `flg_port_control` tinyint(4) DEFAULT NULL, '+
                  '   `flg_translate_tags` tinyint(4) DEFAULT NULL, '+
                  '   `flg_ignore_tags` tinyint(4) DEFAULT NULL, '+
                  '   `flg_paper_cut` tinyint(4) DEFAULT NULL, '+
                  '   `flg_partial_paper_cut` tinyint(4) DEFAULT NULL, '+
                  '   `flg_send_cut_written_command` tinyint(4) DEFAULT NULL, '+
                  '   `page_code` tinyint(4) DEFAULT NULL COMMENT ''[0..6] [0=pcNone, 1=pc437, 2=pc850, 3=pc852, 4=pc860, 5=pcUTF8, 6=pc1252]'', '+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `pos_printer_idx_created_at` (`created_at`), '+
                  '   KEY `pos_printer_idx_model` (`model`), '+
                  '   KEY `pos_printer_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `pos_printer_fk_updated_by_acl_role_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `pos_printer_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `pos_printer_fk_updated_by_acl_role_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
