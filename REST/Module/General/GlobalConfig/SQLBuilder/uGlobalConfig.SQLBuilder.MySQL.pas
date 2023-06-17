unit uGlobalConfig.SQLBuilder.MySQL;

interface

uses
  uGlobalConfig.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uGlobalConfig.Filter,
  uBase.Entity;

type
  TGlobalConfigSQLBuilderMySQL = class(TInterfacedObject, IGlobalConfigSQLBuilder)
  public
    class function Make: IGlobalConfigSQLBuilder;

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
  uGlobalConfig,
  uAppRest.Types,
  uQuotedStr,
  uHlp,
  uAclUser.Show.DTO,
  XSuperObject;

{ TGlobalConfigSQLBuilderMySQL }

function TGlobalConfigSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM global_config WHERE global_config.id = %s';
  Result := Format(LSQL, [
    Q(AId.ToString)
  ]);
end;

function TGlobalConfigSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM global_config WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TGlobalConfigSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO global_config '+
               '   (pdv_edit_item_before_register, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s)';
  const LGlobalConfig = AEntity as TGlobalConfig;
  Result := Format(LSQL, [
    Q(LGlobalConfig.pdv_edit_item_before_register),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LGlobalConfig.created_by_acl_user_id)
  ]);
end;

function TGlobalConfigSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TGlobalConfigSQLBuilderMySQL.Make: IGlobalConfigSQLBuilder;
begin
  Result := Self.Create;
end;

function TGlobalConfigSQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   global_config.*, '+
             '   created_by_acl_user.name as created_by_acl_user_name, '+
             '   updated_by_acl_user.name as updated_by_acl_user_name  '+
             ' FROM '+
             '   global_config '+
             ' LEFT JOIN acl_user created_by_acl_user '+
             '        ON created_by_acl_user.id = global_config.created_by_acl_user_id '+
             ' LEFT JOIN acl_user updated_by_acl_user '+
             '        ON updated_by_acl_user.id = global_config.updated_by_acl_user_id ';
end;

function TGlobalConfigSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'global_config.id', ddMySql);
end;

function TGlobalConfigSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE global_config.id = ' + AId.ToString;
end;

function TGlobalConfigSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE global_config SET '+
               '   pdv_edit_item_before_register = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LGlobalConfig = AEntity as TGlobalConfig;
  Result := Format(LSQL, [
    Q(LGlobalConfig.pdv_edit_item_before_register),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LGlobalConfig.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
