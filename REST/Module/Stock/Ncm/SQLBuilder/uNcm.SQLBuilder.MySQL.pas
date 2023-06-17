unit uNcm.SQLBuilder.MySQL;

interface

uses
  uFilter,
  uSelectWithFilter,
  uNcm,
  uNcm.SQLBuilder.Interfaces,
  uBase.Entity;

type
  TNcmSQLBuilderMySQL = class(TInterfacedObject, INcmSQLBuilder)
  public
    class function Make: INcmSQLBuilder;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  uZLConnection.Types,
  uAppRest.Types,
  uSmartPointer,
  uQuotedStr;

const
  DECIMAL_PLACES = 4;

{ TNcmSQLBuilderMySQL }

function TNcmSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM ncm WHERE id = %s';
begin
  Result := Format(LSQL, [Q(AId.ToString)]);
end;

function TNcmSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
const
  LSQL = 'DELETE FROM ncm WHERE id in (%s)';
begin
  Result := Format(LSQL, [AId]);
end;

function TNcmSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
const
  LSQL = ' INSERT INTO ncm '+
         '   (name, code, national_rate, imported_rate, state_rate, municipal_rate, '+
         '    cest, additional_information, start_of_validity, end_of_validity, created_at, created_by_acl_user_id) '+
         ' VALUES '+
         '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)';
var
  LNcm: TNcm;
begin
  LNcm := AEntity as TNcm;

  Result := Format(LSQL, [
    Q(LNcm.name),
    Q(LNcm.code),
    Q(LNcm.national_rate, DECIMAL_PLACES),
    Q(LNcm.imported_rate, DECIMAL_PLACES),
    Q(LNcm.state_rate, DECIMAL_PLACES),
    Q(LNcm.municipal_rate, DECIMAL_PLACES),
    Q(LNcm.cest),
    Q(LNcm.additional_information),
    Q(LNcm.start_of_validity, TDBDriver.dbMYSQL),
    Q(LNcm.end_of_validity, TDBDriver.dbMYSQL),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LNcm.created_by_acl_user_id)
  ]);
end;

function TNcmSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TNcmSQLBuilderMySQL.Make: INcmSQLBuilder;
begin
  Result := Self.Create;
end;

function TNcmSQLBuilderMySQL.RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
const
  LSQL = 'SELECT %s FROM ncm WHERE %s = %s AND ncm.id <> %s';
begin
  Result := Format(LSQL, [
    AColumName,
    AColumName,
    Q(AColumnValue),
    AId.ToString
  ]);
end;

function TNcmSQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   ncm.*, '+
         '   created_by_acl_user.name as created_by_acl_user_name, '+
         '   updated_by_acl_user.name as updated_by_acl_user_name '+
         ' FROM '+
         '   ncm '+
         ' LEFT JOIN acl_user created_by_acl_user '+
         '        ON created_by_acl_user.id = ncm.created_by_acl_user_id '+
         ' LEFT JOIN acl_user updated_by_acl_user '+
         '        ON updated_by_acl_user.id = ncm.updated_by_acl_user_id ';
begin
  Result := LSQL;
end;

function TNcmSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'ncm.id', ddMySql);
end;

function TNcmSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE ncm.id = ' + AId.ToString;
end;

function TNcmSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
const
  LSQL = ' UPDATE ncm SET '+
         '   name = %s, '+
         '   code = %s, '+
         '   national_rate = %s, '+
         '   imported_rate = %s, '+
         '   state_rate = %s, '+
         '   municipal_rate = %s, '+
         '   cest = %s, '+
         '   additional_information = %s, '+
         '   start_of_validity = %s, '+
         '   end_of_validity = %s, '+
         '   updated_at = %s, '+
         '   updated_by_acl_user_id = %s '+
         ' WHERE '+
         '   id = %s';
var
  LNcm: TNcm;
begin
  LNcm := AEntity as TNcm;

  Result := Format(LSQL, [
    Q(LNcm.name),
    Q(LNcm.code),
    Q(LNcm.national_rate, DECIMAL_PLACES),
    Q(LNcm.imported_rate, DECIMAL_PLACES),
    Q(LNcm.state_rate, DECIMAL_PLACES),
    Q(LNcm.municipal_rate, DECIMAL_PLACES),
    Q(LNcm.cest),
    Q(LNcm.additional_information),
    Q(LNcm.start_of_validity, TDBDriver.dbMYSQL),
    Q(LNcm.end_of_validity, TDBDriver.dbMYSQL),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LNcm.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

