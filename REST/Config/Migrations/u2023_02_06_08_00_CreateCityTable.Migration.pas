unit u2023_02_06_08_00_CreateCityTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `city` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `name` varchar(100) NOT NULL, '+
                  '   `state` char(2) NOT NULL, '+
                  '   `country` varchar(100) NOT NULL, '+
                  '   `ibge_code` varchar(30) NOT NULL, '+
                  '   `country_ibge_code` varchar(30) NOT NULL, '+
                  '   `identification` varchar(100), '+
                  '   `created_at` datetime, '+
                  '   `updated_at` datetime, '+
                  '   `created_by_acl_user_id` bigint, '+
                  '   `updated_by_acl_user_id` bigint, '+
                  '   PRIMARY KEY (`id`), '+
                  '   KEY `city_idx_created_at` (`created_at`), '+
                  '   KEY `city_idx_state` (`state`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;

initialization
  TMigration.&Register;

end.

