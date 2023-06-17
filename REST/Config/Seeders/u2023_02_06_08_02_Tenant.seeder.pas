unit u2023_02_06_08_02_Tenant.Seeder;

interface

uses
  uBase.Migration,
  uConnMigration,
  uEnv.Rest,
  uZLConnection.Types,
  System.SysUtils,
  uQuotedStr;

type
  TSeeder = class(TBaseMigration)
    class function &Register: TSeeder;
  end;

implementation

function MySQLScript: String;
begin
  const LSQL = ' INSERT INTO tenant '+
               '   (name, alias_name, legal_entity_number, address, district, phone_1, company_email, city_id, '+
               '    send_email_email, send_email_identification, send_email_user, send_email_password, send_email_smtp, '+
               '    send_email_port, send_email_ssl, send_email_tls, send_email_footer_message, send_email_header_message) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)';

  Result := Format(LSQL, [
    Q('MINHA EMPRESA'),
    Q('MINHA EMPRESA'),
    Q('00.000.000/0000-00'),
    Q('LOGRADOURO'),
    Q('BAIRRO'),
    Q('0000000000'),
    Q('leonamjlima88@gmail.com'),
    QN(1),
    Q('leonamjlima88@gmail.com'),
    Q('Leonam J. Lima'),
    Q('leonamjlima88@gmail.com'),
    Q('ovrblmpcacohtdvq'),
    Q('smtp.gmail.com'),
    Q(587),
    Q(0),
    Q(1),
    Q('Rodapé'),
    Q('Cabeçalho')
  ]);
end;

{ TSeeder }
class function TSeeder.&Register: TSeeder;
begin
  case ENV_REST.DriverDB of
    ddMySql: ConnMigration.AddSeeder(Self.UnitName, MySQLScript);
  end;
end;

initialization
  TSeeder.&Register;

end.
