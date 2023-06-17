unit uTenant.SQLBuilder.MySQL;

interface

uses
  uTenant.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uTenant.Filter,
  uBase.Entity;

type
  TTenantSQLBuilderMySQL = class(TInterfacedObject, ITenantSQLBuilder)
  public
    class function Make: ITenantSQLBuilder;

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
  uTenant,
  uAppRest.Types,
  uQuotedStr,
  uHlp,
  uSmartPointer,
  System.Classes;

{ TTenantSQLBuilderMySQL }

function TTenantSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM tenant WHERE tenant.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TTenantSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM tenant WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TTenantSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO tenant '+
               '   (name, alias_name, legal_entity_number, icms_taxpayer, state_registration, municipal_registration, '+
               '    zipcode, address, address_number, complement, district, reference_point, phone_1, phone_2, phone_3, '+
               '    company_email, financial_email, internet_page, note, bank_note, commercial_note, city_id, '+
               '    send_email_app_default, send_email_email, send_email_identification, send_email_user, send_email_password, '+
               '    send_email_smtp, send_email_port, send_email_ssl, send_email_tls, send_email_email_accountant, '+
               '    send_email_footer_message, send_email_header_message) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, '+
               '    %s, %s, %s, %s, %s, %s, %s)';
  const LTenant = AEntity as TTenant;

  Result := Format(LSQL, [
    Q(LTenant.name),
    Q(LTenant.alias_name),
    Q(LTenant.legal_entity_number),
    Q(LTenant.icms_taxpayer),
    Q(LTenant.state_registration),
    Q(LTenant.municipal_registration),
    Q(LTenant.zipcode),
    Q(LTenant.address),
    Q(LTenant.address_number),
    Q(LTenant.complement),
    Q(LTenant.district),
    Q(LTenant.reference_point),
    Q(LTenant.phone_1),
    Q(LTenant.phone_2),
    Q(LTenant.phone_3),
    Q(LTenant.company_email),
    Q(LTenant.financial_email),
    Q(LTenant.internet_page),
    Q(LTenant.note),
    Q(LTenant.bank_note),
    Q(LTenant.commercial_note),
    QN(LTenant.city_id),
    Q(LTenant.send_email_app_default),
    Q(LTenant.send_email_email),
    Q(LTenant.send_email_identification),
    Q(LTenant.send_email_user),
    Q(LTenant.send_email_password),
    Q(LTenant.send_email_smtp),
    Q(LTenant.send_email_port),
    Q(LTenant.send_email_ssl),
    Q(LTenant.send_email_tls),
    Q(LTenant.send_email_email_accountant),
    Q(LTenant.send_email_footer_message),
    Q(LTenant.send_email_header_message)
  ]);
end;

function TTenantSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TTenantSQLBuilderMySQL.Make: ITenantSQLBuilder;
begin
  Result := Self.Create;
end;

function TTenantSQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   tenant.*, '+
             '   city.name as city_name, '+
             '   city.state as city_state, '+
             '   city.ibge_code as city_ibge_code '+
             ' FROM '+
             '   tenant '+
             ' LEFT JOIN city '+
             '        ON city.id = tenant.city_id ';
end;

function TTenantSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'tenant.id', ddMySql);
end;

function TTenantSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE tenant.id = ' + AId.ToString;
end;

function TTenantSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE tenant SET '+
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
  const LTenant = AEntity as TTenant;

  Result := Format(LSQL, [
    Q(LTenant.name),
    Q(LTenant.alias_name),
    Q(LTenant.legal_entity_number),
    Q(LTenant.icms_taxpayer),
    Q(LTenant.state_registration),
    Q(LTenant.municipal_registration),
    Q(LTenant.zipcode),
    Q(LTenant.address),
    Q(LTenant.address_number),
    Q(LTenant.complement),
    Q(LTenant.district),
    Q(LTenant.reference_point),
    Q(LTenant.phone_1),
    Q(LTenant.phone_2),
    Q(LTenant.phone_3),
    Q(LTenant.company_email),
    Q(LTenant.financial_email),
    Q(LTenant.internet_page),
    Q(LTenant.note),
    Q(LTenant.bank_note),
    Q(LTenant.commercial_note),
    QN(LTenant.city_id),
    Q(LTenant.send_email_app_default),
    Q(LTenant.send_email_email),
    Q(LTenant.send_email_identification),
    Q(LTenant.send_email_user),
    Q(LTenant.send_email_password),
    Q(LTenant.send_email_smtp),
    Q(LTenant.send_email_port),
    Q(LTenant.send_email_ssl),
    Q(LTenant.send_email_tls),
    Q(LTenant.send_email_email_accountant),
    Q(LTenant.send_email_footer_message),
    Q(LTenant.send_email_header_message),
    Q(AId)
  ]);
end;

end.

