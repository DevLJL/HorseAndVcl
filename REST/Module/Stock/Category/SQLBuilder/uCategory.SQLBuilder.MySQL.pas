unit uCategory.SQLBuilder.MySQL;

interface

uses
  uCategory.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uCategory.Filter,
  uBase.Entity;

type
  TCategorySQLBuilderMySQL = class(TInterfacedObject, ICategorySQLBuilder)
  public
    class function Make: ICategorySQLBuilder;

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
  uCategory,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TCategorySQLBuilderMySQL }

function TCategorySQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM category WHERE category.id = %s';
begin
  Result := Format(LSQL, [AId.ToString]);
end;

function TCategorySQLBuilderMySQL.DeleteByIdRange(AId: String): String;
const
  LSQL = 'DELETE FROM category WHERE id in (%s)';
begin
  Result := Format(LSQL, [AId]);
end;

function TCategorySQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
const
  LSQL = ' INSERT INTO category '+
         '   (name, created_at, created_by_acl_user_id) '+
         ' VALUES '+
         '   (%s, %s, %s)';
var
  LCategory: TCategory;
begin
  LCategory := AEntity as TCategory;

  Result := Format(LSQL, [
    Q(LCategory.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LCategory.created_by_acl_user_id)
  ]);
end;

function TCategorySQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TCategorySQLBuilderMySQL.Make: ICategorySQLBuilder;
begin
  Result := Self.Create;
end;

function TCategorySQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result :=
    ' CREATE TABLE `category` (                                                                                              '+
    '   `id` bigint NOT NULL AUTO_INCREMENT,                                                                              '+
    '   `name` varchar(255) NOT NULL,                                                                                     '+
    '   `created_at` datetime DEFAULT NULL,                                                                               '+
    '   `updated_at` datetime DEFAULT NULL,                                                                               '+
    '   `created_by_acl_user_id` bigint DEFAULT NULL,                                                                     '+
    '   `updated_by_acl_user_id` bigint DEFAULT NULL,                                                                     '+
    '   PRIMARY KEY (`id`),                                                                                               '+
    '   KEY `category_idx_created_at` (`created_at`),                                                                        '+
    '   KEY `category_fk_created_by_acl_user_id` (`created_by_acl_user_id`),                                                 '+
    '   KEY `category_fk_updated_by_category_id` (`updated_by_acl_user_id`),                                                    '+
    '   CONSTRAINT `category_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
    '   CONSTRAINT `category_fk_updated_by_category_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)     '+
    ' )                                                                                                                   ';
end;

function TCategorySQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result := '';
end;

function TCategorySQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   category.*, '+
         '   created_by_acl_user.name as created_by_acl_user_name, '+
         '   updated_by_acl_user.name as updated_by_acl_user_name  '+
         ' FROM '+
         '   category '+
         ' LEFT JOIN acl_user created_by_acl_user '+
         '        ON created_by_acl_user.id = category.created_by_acl_user_id '+
         ' LEFT JOIN acl_user updated_by_acl_user '+
         '        ON updated_by_acl_user.id = category.updated_by_acl_user_id ';
begin
  Result := LSQL;
end;

function TCategorySQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'category.id', ddMySql);
end;

function TCategorySQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE category.id = ' + AId.ToString;
end;

function TCategorySQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
const
  LSQL = ' UPDATE category SET '+
         '   name = %s, '+
         '   updated_at = %s, '+
         '   updated_by_acl_user_id = %s '+
         ' WHERE '+
         '   id = %s ';
var
  LCategory: TCategory;
begin
  LCategory := AEntity as TCategory;

  Result := Format(LSQL, [
    Q(LCategory.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LCategory.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
