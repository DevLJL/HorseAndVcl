unit uStorageLocation.SQLBuilder.MySQL;

interface

uses
  uStorageLocation.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uStorageLocation.Filter,
  uBase.Entity;

type
  TStorageLocationSQLBuilderMySQL = class(TInterfacedObject, IStorageLocationSQLBuilder)
  public
    class function Make: IStorageLocationSQLBuilder;

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
  uStorageLocation,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TStorageLocationSQLBuilderMySQL }

function TStorageLocationSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM storage_location WHERE storage_location.id = %s';
begin
  Result := Format(LSQL, [AId.ToString]);
end;

function TStorageLocationSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
const
  LSQL = 'DELETE FROM storage_location WHERE id in (%s)';
begin
  Result := Format(LSQL, [AId]);
end;

function TStorageLocationSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
const
  LSQL = ' INSERT INTO storage_location '+
         '   (name, created_at, created_by_acl_user_id) '+
         ' VALUES '+
         '   (%s, %s, %s)';
var
  LStorageLocation: TStorageLocation;
begin
  LStorageLocation := AEntity as TStorageLocation;

  Result := Format(LSQL, [
    Q(LStorageLocation.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LStorageLocation.created_by_acl_user_id)
  ]);
end;

function TStorageLocationSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TStorageLocationSQLBuilderMySQL.Make: IStorageLocationSQLBuilder;
begin
  Result := Self.Create;
end;

function TStorageLocationSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result :=
    ' CREATE TABLE `storage_location` (                                                                                              '+
    '   `id` bigint NOT NULL AUTO_INCREMENT,                                                                              '+
    '   `name` varchar(255) NOT NULL,                                                                                     '+
    '   `created_at` datetime DEFAULT NULL,                                                                               '+
    '   `updated_at` datetime DEFAULT NULL,                                                                               '+
    '   `created_by_acl_user_id` bigint DEFAULT NULL,                                                                     '+
    '   `updated_by_acl_user_id` bigint DEFAULT NULL,                                                                     '+
    '   PRIMARY KEY (`id`),                                                                                               '+
    '   KEY `storage_location_idx_created_at` (`created_at`),                                                                        '+
    '   KEY `storage_location_fk_created_by_acl_user_id` (`created_by_acl_user_id`),                                                 '+
    '   KEY `storage_location_fk_updated_by_storage_location_id` (`updated_by_acl_user_id`),                                                    '+
    '   CONSTRAINT `storage_location_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
    '   CONSTRAINT `storage_location_fk_updated_by_storage_location_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)     '+
    ' )                                                                                                                   ';
end;

function TStorageLocationSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result := '';
end;

function TStorageLocationSQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   storage_location.*, '+
         '   created_by_acl_user.name as created_by_acl_user_name, '+
         '   updated_by_acl_user.name as updated_by_acl_user_name  '+
         ' FROM '+
         '   storage_location '+
         ' LEFT JOIN acl_user created_by_acl_user '+
         '        ON created_by_acl_user.id = storage_location.created_by_acl_user_id '+
         ' LEFT JOIN acl_user updated_by_acl_user '+
         '        ON updated_by_acl_user.id = storage_location.updated_by_acl_user_id ';
begin
  Result := LSQL;
end;

function TStorageLocationSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'storage_location.id', ddMySql);
end;

function TStorageLocationSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE storage_location.id = ' + AId.ToString;
end;

function TStorageLocationSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
const
  LSQL = ' UPDATE storage_location SET '+
         '   name = %s, '+
         '   updated_at = %s, '+
         '   updated_by_acl_user_id = %s '+
         ' WHERE '+
         '   id = %s ';
var
  LStorageLocation: TStorageLocation;
begin
  LStorageLocation := AEntity as TStorageLocation;

  Result := Format(LSQL, [
    Q(LStorageLocation.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LStorageLocation.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
