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
    function ScriptCreateTable: String;
    function ScriptSeedTable: String;
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

function TUnitSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result :=
    ' CREATE TABLE `unit` (                                                                                               '+
    '   `id` bigint NOT NULL AUTO_INCREMENT,                                                                              '+
    '   `name` varchar(10) NOT NULL,                                                                                      '+
    '   `description` varchar(100) NOT NULL,                                                                              '+
    '   `created_at` datetime DEFAULT NULL,                                                                               '+
    '   `updated_at` datetime DEFAULT NULL,                                                                               '+
    '   `created_by_acl_user_id` bigint DEFAULT NULL,                                                                     '+
    '   `updated_by_acl_user_id` bigint DEFAULT NULL,                                                                     '+
    '   PRIMARY KEY (`id`),                                                                                               '+
    '   KEY `unit_idx_created_at` (`created_at`), '+
    '   KEY `unit_fk_created_by_acl_user_id` (`created_by_acl_user_id`),                                                  '+
    '   KEY `unit_fk_updated_by_unit_id` (`updated_by_acl_user_id`),                                                      '+
    '   CONSTRAINT `unit_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`),  '+
    '   CONSTRAINT `unit_fk_updated_by_unit_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)       '+
    ' )                                                                                                                   ';
end;

function TUnitSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result :=
    ' insert into unit (name, description) values (''UN'', ''Unidade'');    '+
    ' insert into unit (name, description) values (''PC'', ''Peça'');       '+
    ' insert into unit (name, description) values (''LT'', ''Litro'');      '+
    ' insert into unit (name, description) values (''KG'', ''Quilograma''); ';
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

