unit uCompany.SQLBuilder.MySQL;

interface

uses
  uCompany.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uCompany.Filter,
  uBase.Entity;

type
  TCompanySQLBuilderMySQL = class(TInterfacedObject, ICompanySQLBuilder)
  public
    class function Make: ICompanySQLBuilder;

    function ScriptCreateTable: String;
    function ScriptSeedTable: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
  end;

implementation

uses
  uZLConnection.Types,
  System.SysUtils,
  uCompany,
  uAppRest.Types,
  uQuotedStr,
  uHlp,
  uSmartPointer,
  System.Classes;

{ TCompanySQLBuilderMySQL }

function TCompanySQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM company WHERE company.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TCompanySQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM company WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TCompanySQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO company '+
               '   (name, alias_name, legal_entity_number, icms_taxpayer, state_registration, municipal_registration, '+
               '    zipcode, address, address_number, complement, district, reference_point, phone_1, phone_2, phone_3, '+
               '    company_email, financial_email, internet_page, note, bank_note, commercial_note, city_id, '+
               '    send_email_app_default, send_email_email, send_email_identification, send_email_user, send_email_password, '+
               '    send_email_smtp, send_email_port, send_email_ssl, send_email_tls, send_email_email_accountant, '+
               '    send_email_footer_message, send_email_header_message) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, '+
               '    %s, %s, %s, %s, %s, %s, %s)';
  const LCompany = AEntity as TCompany;

  Result := Format(LSQL, [
    Q(LCompany.name),
    Q(LCompany.alias_name),
    Q(LCompany.legal_entity_number),
    Q(LCompany.icms_taxpayer),
    Q(LCompany.state_registration),
    Q(LCompany.municipal_registration),
    Q(LCompany.zipcode),
    Q(LCompany.address),
    Q(LCompany.address_number),
    Q(LCompany.complement),
    Q(LCompany.district),
    Q(LCompany.reference_point),
    Q(LCompany.phone_1),
    Q(LCompany.phone_2),
    Q(LCompany.phone_3),
    Q(LCompany.company_email),
    Q(LCompany.financial_email),
    Q(LCompany.internet_page),
    Q(LCompany.note),
    Q(LCompany.bank_note),
    Q(LCompany.commercial_note),
    QN(LCompany.city_id),
    Q(LCompany.send_email_app_default),
    Q(LCompany.send_email_email),
    Q(LCompany.send_email_identification),
    Q(LCompany.send_email_user),
    Q(LCompany.send_email_password),
    Q(LCompany.send_email_smtp),
    Q(LCompany.send_email_port),
    Q(LCompany.send_email_ssl),
    Q(LCompany.send_email_tls),
    Q(LCompany.send_email_email_accountant),
    Q(LCompany.send_email_footer_message),
    Q(LCompany.send_email_header_message)
  ]);
end;

function TCompanySQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TCompanySQLBuilderMySQL.Make: ICompanySQLBuilder;
begin
  Result := Self.Create;
end;

function TCompanySQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result := ' CREATE TABLE `company` ( '+
            ' `id` bigint NOT NULL AUTO_INCREMENT, '+
            ' `name` varchar(255) NOT NULL, '+
            ' `alias_name` varchar(255) NOT NULL, '+
            ' `legal_entity_number` varchar(20) NOT NULL, '+
            ' `icms_taxpayer` tinyint DEFAULT NULL COMMENT ''[0..2] 0-Não contribuinte de icms, 1-Contribuinte de icms, 2-Isento de icms'', '+
            ' `state_registration` varchar(20) DEFAULT NULL, '+
            ' `municipal_registration` varchar(20) DEFAULT NULL, '+
            ' `zipcode` varchar(10) DEFAULT NULL, '+
            ' `address` varchar(255) NOT NULL, '+
            ' `address_number` varchar(15) DEFAULT NULL, '+
            ' `complement` varchar(255) DEFAULT NULL, '+
            ' `district` varchar(255) NOT NULL, '+
            ' `city_id` bigint NOT NULL, '+
            ' `reference_point` varchar(255) DEFAULT NULL, '+
            ' `phone_1` varchar(14) NOT NULL, '+
            ' `phone_2` varchar(14) DEFAULT NULL, '+
            ' `phone_3` varchar(14) DEFAULT NULL, '+
            ' `company_email` varchar(255) DEFAULT NULL, '+
            ' `financial_email` varchar(255) DEFAULT NULL, '+
            ' `internet_page` varchar(255) DEFAULT NULL, '+
            ' `note` text, '+
            ' `bank_note` text, '+
            ' `commercial_note` text, '+
            ' `send_email_app_default` tinyint(4) DEFAULT NULL, '+
            ' `send_email_email` varchar(255) DEFAULT NULL, '+
            ' `send_email_identification` varchar(255) DEFAULT NULL, '+
            ' `send_email_user` varchar(255) DEFAULT NULL, '+
            ' `send_email_password` varchar(100) DEFAULT NULL, '+
            ' `send_email_smtp` varchar(100) DEFAULT NULL, '+
            ' `send_email_port` varchar(10) DEFAULT NULL, '+
            ' `send_email_ssl` tinyint(4) DEFAULT NULL, '+
            ' `send_email_tls` tinyint(4) DEFAULT NULL, '+
            ' `send_email_email_accountant` varchar(255) DEFAULT NULL, '+
            ' `send_email_footer_message` text, '+
            ' `send_email_header_message` text, '+
            ' PRIMARY KEY (`id`), '+
            ' KEY `company_fk_city_id` (`city_id`), '+
            ' CONSTRAINT `company_fk_city_id` FOREIGN KEY (`city_id`) REFERENCES `city` (`id`) '+
            ' )  ';
end;

function TCompanySQLBuilderMySQL.ScriptSeedTable: String;
begin
  const LSQL = ' INSERT INTO company '+
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
    Q('xxxxxxxxxxxx@gmail.com'),
    QN(1),
    Q('xxxxxxxxxxxx88@gmail.com'),
    Q('Leonam J. Lima'),
    Q('xxxxxxxxxx88@gmail.com'),
    Q('xxxxxxxxxxxx'),
    Q('smtp.gmail.com'),
    Q(587),
    Q(0),
    Q(1),
    Q('Rodapé'),
    Q('Cabeçalho')
  ]);
end;

function TCompanySQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   company.*, '+
             '   city.name as city_name, '+
             '   city.state as city_state, '+
             '   city.ibge_code as city_ibge_code '+
             ' FROM '+
             '   company '+
             ' LEFT JOIN city '+
             '        ON city.id = company.city_id ';
end;

function TCompanySQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'company.id', ddMySql);
end;

function TCompanySQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE company.id = ' + AId.ToString;
end;

function TCompanySQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE company SET '+
               '   name = %s, '+
               '   alias_name = %s, '+
               '   legal_entity_number = %s, '+
               '   icms_taxpayer = %s, '+
               '   state_registration = %s, '+
               '   municipal_registration = %s, '+
               '   zipcode = %s, '+
               '   address = %s, '+
               '   address_number = %s, '+
               '   complement = %s, '+
               '   district = %s, '+
               '   reference_point = %s, '+
               '   phone_1 = %s, '+
               '   phone_2 = %s, '+
               '   phone_3 = %s, '+
               '   company_email = %s, '+
               '   financial_email = %s, '+
               '   internet_page = %s, '+
               '   note = %s, '+
               '   bank_note = %s, '+
               '   commercial_note = %s, '+
               '   city_id = %s, '+
               '   send_email_app_default = %s, '+
               '   send_email_email = %s, '+
               '   send_email_identification = %s, '+
               '   send_email_user = %s, '+
               '   send_email_password = %s, '+
               '   send_email_smtp = %s, '+
               '   send_email_port = %s, '+
               '   send_email_ssl = %s, '+
               '   send_email_tls = %s, '+
               '   send_email_email_accountant = %s, '+
               '   send_email_footer_message = %s, '+
               '   send_email_header_message = %s '+
               ' WHERE '+
               '   id = %s ';
  const LCompany = AEntity as TCompany;

  Result := Format(LSQL, [
    Q(LCompany.name),
    Q(LCompany.alias_name),
    Q(LCompany.legal_entity_number),
    Q(LCompany.icms_taxpayer),
    Q(LCompany.state_registration),
    Q(LCompany.municipal_registration),
    Q(LCompany.zipcode),
    Q(LCompany.address),
    Q(LCompany.address_number),
    Q(LCompany.complement),
    Q(LCompany.district),
    Q(LCompany.reference_point),
    Q(LCompany.phone_1),
    Q(LCompany.phone_2),
    Q(LCompany.phone_3),
    Q(LCompany.company_email),
    Q(LCompany.financial_email),
    Q(LCompany.internet_page),
    Q(LCompany.note),
    Q(LCompany.bank_note),
    Q(LCompany.commercial_note),
    QN(LCompany.city_id),
    Q(LCompany.send_email_app_default),
    Q(LCompany.send_email_email),
    Q(LCompany.send_email_identification),
    Q(LCompany.send_email_user),
    Q(LCompany.send_email_password),
    Q(LCompany.send_email_smtp),
    Q(LCompany.send_email_port),
    Q(LCompany.send_email_ssl),
    Q(LCompany.send_email_tls),
    Q(LCompany.send_email_email_accountant),
    Q(LCompany.send_email_footer_message),
    Q(LCompany.send_email_header_message),
    Q(AId)
  ]);
end;

end.

