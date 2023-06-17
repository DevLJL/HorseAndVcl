unit uChartOfAccount.SQLBuilder.MySQL;

interface

uses
  uChartOfAccount.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uChartOfAccount.Filter,
  uBase.Entity;

type
  TChartOfAccountSQLBuilderMySQL = class(TInterfacedObject, IChartOfAccountSQLBuilder)
  public
    class function Make: IChartOfAccountSQLBuilder;

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
  uChartOfAccount,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TChartOfAccountSQLBuilderMySQL }

function TChartOfAccountSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM chart_of_account WHERE chart_of_account.id = %s';
begin
  Result := Format(LSQL, [AId.ToString]);
end;

function TChartOfAccountSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
const
  LSQL = 'DELETE FROM chart_of_account WHERE id in (%s)';
begin
  Result := Format(LSQL, [AId]);
end;

function TChartOfAccountSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
const
  LSQL = ' INSERT INTO chart_of_account '+
         '   (name, hierarchy_code, flg_analytical, note, created_at, created_by_acl_user_id) '+
         ' VALUES '+
         '   (%s, %s, %s, %s, %s, %s)';
var
  LChartOfAccount: TChartOfAccount;
begin
  LChartOfAccount := AEntity as TChartOfAccount;

  Result := Format(LSQL, [
    Q(LChartOfAccount.name),
    Q(LChartOfAccount.hierarchy_code),
    Q(LChartOfAccount.flg_analytical),
    Q(LChartOfAccount.note),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LChartOfAccount.created_by_acl_user_id)
  ]);
end;

function TChartOfAccountSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TChartOfAccountSQLBuilderMySQL.Make: IChartOfAccountSQLBuilder;
begin
  Result := Self.Create;
end;

function TChartOfAccountSQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   chart_of_account.*, '+
         '   created_by_acl_user.name as created_by_acl_user_name, '+
         '   updated_by_acl_user.name as updated_by_acl_user_name  '+
         ' FROM '+
         '   chart_of_account '+
         ' LEFT JOIN acl_user created_by_acl_user '+
         '        ON created_by_acl_user.id = chart_of_account.created_by_acl_user_id '+
         ' LEFT JOIN acl_user updated_by_acl_user '+
         '        ON updated_by_acl_user.id = chart_of_account.updated_by_acl_user_id ';
begin
  Result := LSQL;
end;

function TChartOfAccountSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'chart_of_account.id', ddMySql);
end;

function TChartOfAccountSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE chart_of_account.id = ' + AId.ToString;
end;

function TChartOfAccountSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
const
  LSQL = ' UPDATE chart_of_account SET '+
         '   name = %s, '+
         '   hierarchy_code = %s, '+
         '   flg_analytical = %s, '+
         '   note = %s, '+
         '   updated_at = %s, '+
         '   updated_by_acl_user_id = %s '+
         ' WHERE '+
         '   id = %s ';
var
  LChartOfAccount: TChartOfAccount;
begin
  LChartOfAccount := AEntity as TChartOfAccount;

  Result := Format(LSQL, [
    Q(LChartOfAccount.name),
    Q(LChartOfAccount.hierarchy_code),
    Q(LChartOfAccount.flg_analytical),
    Q(LChartOfAccount.note),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LChartOfAccount.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
