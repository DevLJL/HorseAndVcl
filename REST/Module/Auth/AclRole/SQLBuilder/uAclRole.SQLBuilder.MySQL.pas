unit uAclRole.SQLBuilder.MySQL;

interface

uses
  uAclRole.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uAclRole.Filter,
  uBase.Entity;

type
  TAclRoleSQLBuilderMySQL = class(TInterfacedObject, IAclRoleSQLBuilder)
  public
    class function Make: IAclRoleSQLBuilder;

    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
  end;

implementation

uses
  uZLConnection.Types,
  System.SysUtils,
  uAclRole,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TAclRoleSQLBuilderMySQL }

function TAclRoleSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM acl_role WHERE acl_role.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TAclRoleSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM acl_role WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TAclRoleSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO acl_role '+
               '   (name, created_at, general_search_method) '+
               ' VALUES '+
               '   (%s, %s, %s)';
  const LAclRole = AEntity as TAclRole;
  Result := Format(LSQL, [
    Q(LAclRole.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(Ord(LAclRole.general_search_method))
  ]);
end;

function TAclRoleSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TAclRoleSQLBuilderMySQL.Make: IAclRoleSQLBuilder;
begin
  Result := Self.Create;
end;

function TAclRoleSQLBuilderMySQL.SelectAll: String;
begin
  Result := ' SELECT '+
            '   acl_role.* '+
            ' FROM '+
            '   acl_role ';
end;

function TAclRoleSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'acl_role.id', ddMySql);
end;

function TAclRoleSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE acl_role.id = ' + AId.ToString;
end;

function TAclRoleSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE acl_role SET '+
               '   name = %s, '+
               '   updated_at = %s, '+
               '   general_search_method = %s '+
               ' WHERE '+
               '   id = %s ';
  const LAclRole = AEntity as TAclRole;
  Result := Format(LSQL, [
    Q(LAclRole.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(Ord(LAclRole.general_search_method)),
    Q(AId)
  ]);
end;

end.
