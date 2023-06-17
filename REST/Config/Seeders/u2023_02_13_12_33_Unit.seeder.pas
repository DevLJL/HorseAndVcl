unit u2023_02_13_12_33_Unit.Seeder;

interface

uses
  uBase.Migration,
  uConnMigration,
  uEnv.Rest,
  uZLConnection.Types;

type
  TSeeder = class(TBaseMigration)
    class function &Register: TSeeder;
  end;

implementation

{ TSeeder }
class function TSeeder.&Register: TSeeder;
const
  LMYSQL_SCRIPT = ' insert into unit (name, description) values (''UN'', ''Unidade'');    '+
                  ' insert into unit (name, description) values (''PC'', ''Peça'');       '+
                  ' insert into unit (name, description) values (''LT'', ''Litro'');      '+
                  ' insert into unit (name, description) values (''KG'', ''Quilograma''); ';

begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddSeeder(Self.UnitName, LMYSQL_SCRIPT);
  end;
end;

initialization
  TSeeder.&Register;

end.
