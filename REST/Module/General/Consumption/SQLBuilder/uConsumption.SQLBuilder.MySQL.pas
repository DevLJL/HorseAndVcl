unit uConsumption.SQLBuilder.MySQL;

interface

uses
  uConsumption.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uConsumption.Filter,
  uBase.Entity;

type
  TConsumptionSQLBuilderMySQL = class(TInterfacedObject, IConsumptionSQLBuilder)
  public
    class function Make: IConsumptionSQLBuilder;

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
    function DeleteByNumbers(AInitial, AFinal: SmallInt): String;
  end;

implementation

uses
  uZLConnection.Types,
  System.SysUtils,
  uConsumption,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TConsumptionSQLBuilderMySQL }

function TConsumptionSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM consumption WHERE consumption.id = %s';
begin
  Result := Format(LSQL, [AId.ToString]);
end;

function TConsumptionSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
const
  LSQL = 'DELETE FROM consumption WHERE id in (%s)';
begin
  Result := Format(LSQL, [AId]);
end;

function TConsumptionSQLBuilderMySQL.DeleteByNumbers(AInitial, AFinal: SmallInt): String;
const
  LSQL = 'DELETE FROM consumption WHERE number >= %s and number <= %s';
begin
  Result := Format(LSQL, [
    Q(AInitial.ToString),
    Q(AFinal.ToString)
  ]);
end;

function TConsumptionSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
const
  LSQL = ' INSERT INTO consumption '+
         '   (number, flg_active, created_at, created_by_acl_user_id) '+
         ' VALUES '+
         '   (%s, %s, %s, %s)';
var
  LConsumption: TConsumption;
begin
  LConsumption := AEntity as TConsumption;

  Result := Format(LSQL, [
    Q(LConsumption.number),
    Q(LConsumption.flg_active),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LConsumption.created_by_acl_user_id)
  ]);
end;

function TConsumptionSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TConsumptionSQLBuilderMySQL.Make: IConsumptionSQLBuilder;
begin
  Result := Self.Create;
end;

function TConsumptionSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result :=
    ' CREATE TABLE `consumption` (                                                                                                '+
    '   `id` bigint NOT NULL AUTO_INCREMENT,                                                                                      '+
    '   `number` bigint NOT NULL,                                                                                                 '+
    '   `flg_active` tinyint(4) DEFAULT NULL,                                                                                      '+
    '   `created_at` datetime DEFAULT NULL,                                                                                       '+
    '   `updated_at` datetime DEFAULT NULL,                                                                                       '+
    '   `created_by_acl_user_id` bigint DEFAULT NULL,                                                                             '+
    '   `updated_by_acl_user_id` bigint DEFAULT NULL,                                                                             '+
    '   PRIMARY KEY (`id`),                                                                                                       '+
    '   KEY `consumption_idx_created_at` (`created_at`), '+
    '   KEY `consumption_fk_created_by_acl_user_id` (`created_by_acl_user_id`),                                                   '+
    '   KEY `consumption_fk_updated_by_consumption_id` (`updated_by_acl_user_id`),                                                '+
    '   CONSTRAINT `consumption_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`),   '+
    '   CONSTRAINT `consumption_fk_updated_by_consumption_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`) '+
    ' )                                                                                                                           ';
end;

function TConsumptionSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result := '';
end;

function TConsumptionSQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   consumption.*, '+
         '   created_by_acl_user.name as created_by_acl_user_name, '+
         '   updated_by_acl_user.name as updated_by_acl_user_name  '+
         ' FROM '+
         '   consumption '+
         ' LEFT JOIN acl_user created_by_acl_user '+
         '        ON created_by_acl_user.id = consumption.created_by_acl_user_id '+
         ' LEFT JOIN acl_user updated_by_acl_user '+
         '        ON updated_by_acl_user.id = consumption.updated_by_acl_user_id ';
begin
  Result := LSQL;
end;

function TConsumptionSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'consumption.id', ddMySql);
end;

function TConsumptionSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE consumption.id = ' + AId.ToString;
end;

function TConsumptionSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
const
  LSQL = ' UPDATE consumption SET '+
         '   number = %s, '+
         '   flg_active = %s, '+
         '   updated_at = %s, '+
         '   updated_by_acl_user_id = %s '+
         ' WHERE '+
         '   id = %s ';
var
  LConsumption: TConsumption;
begin
  LConsumption := AEntity as TConsumption;

  Result := Format(LSQL, [
    Q(LConsumption.number),
    Q(LConsumption.flg_active),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LConsumption.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
