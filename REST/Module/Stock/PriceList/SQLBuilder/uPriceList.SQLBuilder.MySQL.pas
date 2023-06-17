unit uPriceList.SQLBuilder.MySQL;

interface

uses
  uPriceList.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uPriceList.Filter,
  uBase.Entity;

type
  TPriceListSQLBuilderMySQL = class(TInterfacedObject, IPriceListSQLBuilder)
  public
    class function Make: IPriceListSQLBuilder;

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
  uPriceList,
  uAppRest.Types,
  uQuotedStr,
  uHlp,
  uAclUser.Show.DTO,
  XSuperObject;

{ TPriceListSQLBuilderMySQL }

function TPriceListSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM price_list WHERE price_list.id = %s';
  Result := Format(LSQL, [
    Q(AId.ToString)
  ]);
end;

function TPriceListSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM price_list WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TPriceListSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO price_list '+
               '   (name, short_description, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s)';
  const LPriceList = AEntity as TPriceList;
  Result := Format(LSQL, [
    Q(LPriceList.name),
    Q(LPriceList.short_description),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LPriceList.created_by_acl_user_id)
  ]);
end;

function TPriceListSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TPriceListSQLBuilderMySQL.Make: IPriceListSQLBuilder;
begin
  Result := Self.Create;
end;

function TPriceListSQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   price_list.*, '+
             '   created_by_acl_user.name as created_by_acl_user_name, '+
             '   updated_by_acl_user.name as updated_by_acl_user_name  '+
             ' FROM '+
             '   price_list '+
             ' LEFT JOIN acl_user created_by_acl_user '+
             '        ON created_by_acl_user.id = price_list.created_by_acl_user_id '+
             ' LEFT JOIN acl_user updated_by_acl_user '+
             '        ON updated_by_acl_user.id = price_list.updated_by_acl_user_id ';
end;

function TPriceListSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'price_list.id', ddMySql);
end;

function TPriceListSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE price_list.id = ' + AId.ToString;
end;

function TPriceListSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE price_list SET '+
               '   name = %s, '+
               '   short_description = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LPriceList = AEntity as TPriceList;
  Result := Format(LSQL, [
    Q(LPriceList.name),
    Q(LPriceList.short_description),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LPriceList.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
