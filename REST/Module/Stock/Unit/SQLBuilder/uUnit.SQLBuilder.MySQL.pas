unit uUnit.SQLBuilder.MySQL;

interface

uses
  uFilter,
  uSelectWithFilter,
  uUnit,
  uUnit.SQLBuilder.Interfaces,
  uBase.Entity;

type
  TUnitSQLBuilderMySQL = class(TInterfacedObject, IUnitSQLBuilder)
  public
    class function Make: IUnitSQLBuilder;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  uZLConnection.Types,
  uAppRest.Types,
  uQuotedStr;

{ TUnitSQLBuilderMySQL }

function TUnitSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM unit WHERE unit.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TUnitSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM unit WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TUnitSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO unit '+
               '   (name, description, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s)';
  const LUnit = AEntity as TUnit;

  Result := Format(LSQL, [
    Q(LUnit.name),
    Q(LUnit.description),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LUnit.created_by_acl_user_id)
  ]);
end;

function TUnitSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TUnitSQLBuilderMySQL.Make: IUnitSQLBuilder;
begin
  Result := Self.Create;
end;

function TUnitSQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   unit.*, '+
         '   created_by_acl_user.name as created_by_acl_user_name, '+
         '   updated_by_acl_user.name as updated_by_acl_user_name  '+
         ' FROM '+
         '   unit '+
         ' LEFT JOIN acl_user created_by_acl_user '+
         '        ON created_by_acl_user.id = unit.created_by_acl_user_id '+
         ' LEFT JOIN acl_user updated_by_acl_user '+
         '        ON updated_by_acl_user.id = unit.updated_by_acl_user_id ';
begin
  Result := LSQL;
end;

function TUnitSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'unit.id', ddMySql);
end;

function TUnitSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE unit.id = ' + AId.ToString;
end;

function TUnitSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE unit SET '+
               '   name = %s, '+
               '   description = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LUnit = AEntity as TUnit;

  Result := Format(LSQL, [
    Q(LUnit.name),
    Q(LUnit.description),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LUnit.updated_by_acl_user_id),
    Q(AId)
  ]);
end;


end.

