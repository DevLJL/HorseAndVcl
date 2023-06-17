unit u2023_02_16_14_30_CreateSaleCheckTable.Migration;

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
  LMYSQL_SCRIPT = ' CREATE TABLE `sale_check` ( '+
                  '   `id` bigint NOT NULL AUTO_INCREMENT, '+
                  '   `created_at` datetime NOT NULL, '+
                  '   PRIMARY KEY (`id`) '+
                  ' ) ';
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddMigration(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;


initialization
  TMigration.&Register;

end.
