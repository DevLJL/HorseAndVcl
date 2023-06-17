unit u2023_06_04_15_39_CreateGlobalConfigTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `global_config` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `pdv_edit_item_before_register` tinyint DEFAULT ''1'' COMMENT ''[0-False, 1-True] PDV > Editar Item antes de registrar no pedido'','+
                  '   `created_at` datetime DEFAULT NULL, '+
                  '   `updated_at` datetime DEFAULT NULL, '+
                  '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `global_config_idx_created_at` (`created_at`), '+
                  '   KEY `global_config_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
                  '   KEY `global_config_fk_updated_by_global_config_id` (`updated_by_acl_user_id`), '+
                  '   CONSTRAINT `global_config_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
                  '   CONSTRAINT `global_config_fk_updated_by_global_config_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;

initialization
  TMigration.&Register;

end.

