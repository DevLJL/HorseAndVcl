unit uCostCenter.SQLBuilder.MySQL;

interface

uses
  uCostCenter.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uCostCenter.Filter,
  uBase.Entity;

type
  TCostCenterSQLBuilderMySQL = class(TInterfacedObject, ICostCenterSQLBuilder)
  public
    class function Make: ICostCenterSQLBuilder;

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
  uCostCenter,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TCostCenterSQLBuilderMySQL }

function TCostCenterSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM cost_center WHERE cost_center.id = %s';
begin
  Result := Format(LSQL, [AId.ToString]);
end;

function TCostCenterSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
const
  LSQL = 'DELETE FROM cost_center WHERE id in (%s)';
begin
  Result := Format(LSQL, [AId]);
end;

function TCostCenterSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
const
  LSQL = ' INSERT INTO cost_center '+
         '   (name, created_at, created_by_acl_user_id) '+
         ' VALUES '+
         '   (%s, %s, %s)';
var
  LCostCenter: TCostCenter;
begin
  LCostCenter := AEntity as TCostCenter;

  Result := Format(LSQL, [
    Q(LCostCenter.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LCostCenter.created_by_acl_user_id)
  ]);
end;

function TCostCenterSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TCostCenterSQLBuilderMySQL.Make: ICostCenterSQLBuilder;
begin
  Result := Self.Create;
end;

function TCostCenterSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result :=
    ' CREATE TABLE `cost_center` (                                                                                              '+
    '   `id` bigint NOT NULL AUTO_INCREMENT,                                                                              '+
    '   `name` varchar(255) NOT NULL,                                                                                     '+
    '   `created_at` datetime DEFAULT NULL,                                                                               '+
    '   `updated_at` datetime DEFAULT NULL,                                                                               '+
    '   `created_by_acl_user_id` bigint DEFAULT NULL,                                                                     '+
    '   `updated_by_acl_user_id` bigint DEFAULT NULL,                                                                     '+
    '   PRIMARY KEY (`id`),                                                                                               '+
    '   KEY `cost_center_idx_created_at` (`created_at`),                                                                        '+
    '   KEY `cost_center_fk_created_by_acl_user_id` (`created_by_acl_user_id`),                                                 '+
    '   KEY `cost_center_fk_updated_by_cost_center_id` (`updated_by_acl_user_id`),                                                    '+
    '   CONSTRAINT `cost_center_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
    '   CONSTRAINT `cost_center_fk_updated_by_cost_center_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)     '+
    ' )                                                                                                                   ';
end;

function TCostCenterSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result := '';
end;

function TCostCenterSQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   cost_center.*, '+
         '   created_by_acl_user.name as created_by_acl_user_name, '+
         '   updated_by_acl_user.name as updated_by_acl_user_name  '+
         ' FROM '+
         '   cost_center '+
         ' LEFT JOIN acl_user created_by_acl_user '+
         '        ON created_by_acl_user.id = cost_center.created_by_acl_user_id '+
         ' LEFT JOIN acl_user updated_by_acl_user '+
         '        ON updated_by_acl_user.id = cost_center.updated_by_acl_user_id ';
begin
  Result := LSQL;
end;

function TCostCenterSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'cost_center.id', ddMySql);
end;

function TCostCenterSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE cost_center.id = ' + AId.ToString;
end;

function TCostCenterSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
const
  LSQL = ' UPDATE cost_center SET '+
         '   name = %s, '+
         '   updated_at = %s, '+
         '   updated_by_acl_user_id = %s '+
         ' WHERE '+
         '   id = %s ';
var
  LCostCenter: TCostCenter;
begin
  LCostCenter := AEntity as TCostCenter;

  Result := Format(LSQL, [
    Q(LCostCenter.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LCostCenter.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

