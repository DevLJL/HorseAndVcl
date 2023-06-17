unit uPerson.SQLBuilder.MySQL;

interface

uses
  uFilter,
  uSelectWithFilter,
  uPerson,
  uPerson.SQLBuilder.Interfaces,
  uBase.Entity,
  uPersonContact;

type
  TPersonSQLBuilderMySQL = class(TInterfacedObject, IPersonSQLBuilder)
  public
    class function Make: IPersonSQLBuilder;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;

    // PersonContact
    function SelectPersonContactsByPersonId(APersonId: Int64): String;
    function DeletePersonContactsByPersonId(APersonId: Int64): String;
    function InsertPersonContact(APersonContact: TPersonContact): String;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  uZLConnection.Types,
  uAppRest.Types,
  uHlp,
  uQuotedStr;

{ TPersonSQLBuilderMySQL }

function TPersonSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM person WHERE person.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TPersonSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM person WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TPersonSQLBuilderMySQL.DeletePersonContactsByPersonId(APersonId: Int64): String;
begin
  const LSQL = 'DELETE FROM person_contact WHERE person_contact.person_id = %s';
  Result := Format(LSQL, [APersonId.ToString]);
end;

function TPersonSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO person '+
               '   (name, alias_name, legal_entity_number, icms_taxpayer, state_registration, '+
               '    municipal_registration, zipcode, address, address_number, complement, district, '+
               '    reference_point, phone_1, phone_2, phone_3, company_email, financial_email, internet_page, '+
               '    note, bank_note, commercial_note, flg_customer, flg_seller, flg_supplier, flg_carrier, flg_technician, '+
               '    flg_employee, flg_other, flg_final_customer, city_id, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, '+
               '    %s, %s, %s, %s, %s, %s)';
  const LPerson = AEntity as TPerson;

  Result := Format(LSQL, [
    Q(LPerson.name),
    Q(LPerson.alias_name),
    Q(LPerson.legal_entity_number),
    Q(Ord(LPerson.icms_taxpayer)),
    Q(LPerson.state_registration),
    Q(LPerson.municipal_registration),
    Q(LPerson.zipcode),
    Q(LPerson.address),
    Q(LPerson.address_number),
    Q(LPerson.complement),
    Q(LPerson.district),
    Q(LPerson.reference_point),
    Q(LPerson.phone_1),
    Q(LPerson.phone_2),
    Q(LPerson.phone_3),
    Q(LPerson.company_email),
    Q(LPerson.financial_email),
    Q(LPerson.internet_page),
    Q(LPerson.note),
    Q(LPerson.bank_note),
    Q(LPerson.commercial_note),
    Q(LPerson.flg_customer),
    Q(LPerson.flg_seller),
    Q(LPerson.flg_supplier),
    Q(LPerson.flg_carrier),
    Q(LPerson.flg_technician),
    Q(LPerson.flg_employee),
    Q(LPerson.flg_other),
    Q(LPerson.flg_final_customer),
    QN(LPerson.city_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LPerson.created_by_acl_user_id)
  ]);
end;

function TPersonSQLBuilderMySQL.InsertPersonContact(APersonContact: TPersonContact): String;
begin
  const LSQL = ' INSERT INTO person_contact '+
               '   (person_id, name, legal_entity_number, type, note, phone, email) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s) ';
  Result := Format(LSQL, [
    Q(APersonContact.person_id),
    Q(APersonContact.name),
    Q(APersonContact.legal_entity_number),
    Q(APersonContact.&type),
    Q(APersonContact.note),
    Q(APersonContact.phone),
    Q(APersonContact.email)
  ]);
end;

function TPersonSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TPersonSQLBuilderMySQL.Make: IPersonSQLBuilder;
begin
  Result := Self.Create;
end;

function TPersonSQLBuilderMySQL.RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
const
  LSQL = 'SELECT %s FROM person WHERE %s = %s AND person.id <> %s';
begin
  Result := Format(LSQL, [
    AColumName,
    AColumName,
    Q(AColumnValue),
    AId.ToString
  ]);
end;

function TPersonSQLBuilderMySQL.SelectAll: String;
begin
  Result := ' SELECT '+
            '   person.*, '+
            '   city.name as city_name, ' +
            '   city.state as city_state, ' +
            '   city.country as city_country, ' +
            '   city.ibge_code as city_ibge_code, ' +
            '   city.country_ibge_code as city_country_ibge_code, ' +
            '   created_by_acl_user.name as created_by_acl_user_name, ' +
            '   updated_by_acl_user.name as updated_by_acl_user_name ' +
            ' FROM '+
            '   person '+
            ' LEFT JOIN city '+
            '        ON city.id = person.city_id ' +
            ' LEFT JOIN acl_user created_by_acl_user'+
            '        ON created_by_acl_user.id = person.created_by_acl_user_id ' +
            ' LEFT JOIN acl_user updated_by_acl_user'+
            '        ON updated_by_acl_user.id = person.updated_by_acl_user_id ';
end;

function TPersonSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'person.id', ddMySql);
end;

function TPersonSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE person.id = ' + AId.ToString;
end;

function TPersonSQLBuilderMySQL.SelectPersonContactsByPersonId(APersonId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   person_contact.* '+
               ' FROM '+
               '   person_contact '+
               ' WHERE '+
               '   person_contact.person_id = %s '+
               ' ORDER BY '+
               '   person_contact.id';
  Result := Format(lSQL, [APersonId.ToString]);
end;

function TPersonSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE person SET '+
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
               '   flg_customer = %s, '+
               '   flg_seller = %s, '+
               '   flg_supplier = %s, '+
               '   flg_carrier = %s, '+
               '   flg_technician = %s, '+
               '   flg_employee = %s, '+
               '   flg_other = %s, '+
               '   flg_final_customer = %s, '+
               '   city_id = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LPerson = AEntity as TPerson;

  Result := Format(LSQL, [
    Q(LPerson.name),
    Q(LPerson.alias_name),
    Q(LPerson.legal_entity_number),
    Q(Ord(LPerson.icms_taxpayer)),
    Q(LPerson.state_registration),
    Q(LPerson.municipal_registration),
    Q(LPerson.zipcode),
    Q(LPerson.address),
    Q(LPerson.address_number),
    Q(LPerson.complement),
    Q(LPerson.district),
    Q(LPerson.reference_point),
    Q(LPerson.phone_1),
    Q(LPerson.phone_2),
    Q(LPerson.phone_3),
    Q(LPerson.company_email),
    Q(LPerson.financial_email),
    Q(LPerson.internet_page),
    Q(LPerson.note),
    Q(LPerson.bank_note),
    Q(LPerson.commercial_note),
    Q(LPerson.flg_customer),
    Q(LPerson.flg_seller),
    Q(LPerson.flg_supplier),
    Q(LPerson.flg_carrier),
    Q(LPerson.flg_technician),
    Q(LPerson.flg_employee),
    Q(LPerson.flg_other),
    Q(LPerson.flg_final_customer),
    QN(LPerson.city_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LPerson.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

