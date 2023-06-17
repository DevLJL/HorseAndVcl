unit uSize.SQLBuilder.MySQL;

interface

uses
  uSize.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uSize.Filter,
  uBase.Entity;

type
  TSizeSQLBuilderMySQL = class(TInterfacedObject, ISizeSQLBuilder)
  public
    class function Make: ISizeSQLBuilder;

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
  uSize,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TSizeSQLBuilderMySQL }

function TSizeSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM size WHERE size.id = %s';
begin
  Result := Format(LSQL, [AId.ToString]);
end;

function TSizeSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
const
  LSQL = 'DELETE FROM size WHERE id in (%s)';
begin
  Result := Format(LSQL, [AId]);
end;

function TSizeSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
const
  LSQL = ' INSERT INTO size '+
         '   (name, created_at, created_by_acl_user_id) '+
         ' VALUES '+
         '   (%s, %s, %s)';
var
  LSize: TSize;
begin
  LSize := AEntity as TSize;

  Result := Format(LSQL, [
    Q(LSize.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LSize.created_by_acl_user_id)
  ]);
end;

function TSizeSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TSizeSQLBuilderMySQL.Make: ISizeSQLBuilder;
begin
  Result := Self.Create;
end;

function TSizeSQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   size.*, '+
         '   created_by_acl_user.name as created_by_acl_user_name, '+
         '   updated_by_acl_user.name as updated_by_acl_user_name  '+
         ' FROM '+
         '   size '+
         ' LEFT JOIN acl_user created_by_acl_user '+
         '        ON created_by_acl_user.id = size.created_by_acl_user_id '+
         ' LEFT JOIN acl_user updated_by_acl_user '+
         '        ON updated_by_acl_user.id = size.updated_by_acl_user_id ';
begin
  Result := LSQL;
end;

function TSizeSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'size.id', ddMySql);
end;

function TSizeSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE size.id = ' + AId.ToString;
end;

function TSizeSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
const
  LSQL = ' UPDATE size SET '+
         '   name = %s, '+
         '   updated_at = %s, '+
         '   updated_by_acl_user_id = %s '+
         ' WHERE '+
         '   id = %s ';
var
  LSize: TSize;
begin
  LSize := AEntity as TSize;

  Result := Format(LSQL, [
    Q(LSize.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LSize.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

