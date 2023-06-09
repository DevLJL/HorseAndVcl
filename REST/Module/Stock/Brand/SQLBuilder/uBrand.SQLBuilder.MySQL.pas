unit uBrand.SQLBuilder.MySQL;

interface

uses
  uBrand.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uBrand.Filter,
  uBase.Entity;

type
  TBrandSQLBuilderMySQL = class(TInterfacedObject, IBrandSQLBuilder)
  public
    class function Make: IBrandSQLBuilder;

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
  uBrand,
  uAppRest.Types,
  uQuotedStr,
  uHlp,
  uAclUser.Show.DTO,
  XSuperObject;

{ TBrandSQLBuilderMySQL }

function TBrandSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM brand WHERE brand.id = %s';
  Result := Format(LSQL, [
    Q(AId.ToString)
  ]);
end;

function TBrandSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM brand WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TBrandSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO brand '+
               '   (name, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s)';
  const LBrand = AEntity as TBrand;
  Result := Format(LSQL, [
    Q(LBrand.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LBrand.created_by_acl_user_id)
  ]);
end;

function TBrandSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TBrandSQLBuilderMySQL.Make: IBrandSQLBuilder;
begin
  Result := Self.Create;
end;

function TBrandSQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   brand.*, '+
             '   created_by_acl_user.name as created_by_acl_user_name, '+
             '   updated_by_acl_user.name as updated_by_acl_user_name  '+
             ' FROM '+
             '   brand '+
             ' LEFT JOIN acl_user created_by_acl_user '+
             '        ON created_by_acl_user.id = brand.created_by_acl_user_id '+
             ' LEFT JOIN acl_user updated_by_acl_user '+
             '        ON updated_by_acl_user.id = brand.updated_by_acl_user_id ';
end;

function TBrandSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'brand.id', ddMySql);
end;

function TBrandSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE brand.id = ' + AId.ToString;
end;

function TBrandSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE brand SET '+
               '   name = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LBrand = AEntity as TBrand;
  Result := Format(LSQL, [
    Q(LBrand.name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LBrand.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
