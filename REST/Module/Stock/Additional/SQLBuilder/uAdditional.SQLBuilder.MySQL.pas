unit uAdditional.SQLBuilder.MySQL;

interface

uses
  uAdditional.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uAdditional.Filter,
  uBase.Entity,
  uAdditionalProduct;

type
  TAdditionalSQLBuilderMySQL = class(TInterfacedObject, IAdditionalSQLBuilder)
  public
    class function Make: IAdditionalSQLBuilder;

    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;

    // AdditionalProduct
    function SelectAdditionalProductsByAdditionalId(AAdditionalId: Int64): String;
    function DeleteAdditionalProductsByAdditionalId(AAdditionalId: Int64): String;
    function InsertAdditionalProduct(AAdditionalProduct: TAdditionalProduct): String;
  end;

implementation

uses
  uZLConnection.Types,
  System.SysUtils,
  uAdditional,
  uAppRest.Types,
  uQuotedStr,
  uHlp,
  uAclUser.Show.DTO,
  XSuperObject;

{ TAdditionalSQLBuilderMySQL }

function TAdditionalSQLBuilderMySQL.DeleteAdditionalProductsByAdditionalId(AAdditionalId: Int64): String;
begin
  const LSQL = 'DELETE FROM additional_product WHERE additional_product.additional_id = %s';
  Result := Format(LSQL, [AAdditionalId.ToString]);
end;

function TAdditionalSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM additional WHERE additional.id = %s';
  Result := Format(LSQL, [
    Q(AId.ToString)
  ]);
end;

function TAdditionalSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM additional WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TAdditionalSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO additional '+
               '   (name, selection_type, price_calculation_type, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s)';
  const LAdditional = AEntity as TAdditional;
  Result := Format(LSQL, [
    Q(LAdditional.name),
    Q(Ord(LAdditional.selection_type)),
    Q(Ord(LAdditional.price_calculation_type)),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LAdditional.created_by_acl_user_id)
  ]);
end;

function TAdditionalSQLBuilderMySQL.InsertAdditionalProduct(AAdditionalProduct: TAdditionalProduct): String;
begin
  const LSQL = ' INSERT INTO additional_product '+
               '   (additional_id, product_id) '+
               ' VALUES '+
               '   (%s, %s) ';
  Result := Format(LSQL, [
    Q(AAdditionalProduct.additional_id),
    Q(AAdditionalProduct.product_id)
  ]);
end;

function TAdditionalSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TAdditionalSQLBuilderMySQL.Make: IAdditionalSQLBuilder;
begin
  Result := Self.Create;
end;

function TAdditionalSQLBuilderMySQL.SelectAdditionalProductsByAdditionalId(AAdditionalId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   additional_product.*, '+
               '   product.name as product_name '+
               ' FROM '+
               '   additional_product '+
               ' INNER JOIN product '+
               '         ON product.id = additional_product.product_id '+
               ' WHERE '+
               '   additional_product.additional_id = %s '+
               ' ORDER BY '+
               '   additional_product.id';
  Result := Format(lSQL, [AAdditionalId.ToString]);
end;

function TAdditionalSQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   additional.*, '+
             '   created_by_acl_user.name as created_by_acl_user_name, '+
             '   updated_by_acl_user.name as updated_by_acl_user_name  '+
             ' FROM '+
             '   additional '+
             ' LEFT JOIN acl_user created_by_acl_user '+
             '        ON created_by_acl_user.id = additional.created_by_acl_user_id '+
             ' LEFT JOIN acl_user updated_by_acl_user '+
             '        ON updated_by_acl_user.id = additional.updated_by_acl_user_id ';
end;

function TAdditionalSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'additional.id', ddMySql);
end;

function TAdditionalSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE additional.id = ' + AId.ToString;
end;

function TAdditionalSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE additional SET '+
               '   name = %s, '+
               '   selection_type = %s, '+
               '   price_calculation_type = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LAdditional = AEntity as TAdditional;
  Result := Format(LSQL, [
    Q(LAdditional.name),
    Q(Ord(LAdditional.selection_type)),
    Q(Ord(LAdditional.price_calculation_type)),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LAdditional.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
