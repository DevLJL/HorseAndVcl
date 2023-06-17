unit uProduct.SQLBuilder.MySQL;

interface

uses
  uFilter,
  uSelectWithFilter,
  uProduct,
  uProduct.SQLBuilder.Interfaces,
  uBase.Entity,
  uProductPriceList;

type
  TProductSQLBuilderMySQL = class(TInterfacedObject, IProductSQLBuilder)
  public
    class function Make: IProductSQLBuilder;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
    function SelectByEanOrSkuCode(AValue: String): String;

    // ProductPriceList
    function SelectProductPriceListsByProductId(AProductId: Int64): String;
    function DeleteProductPriceListsByProductId(AProductId: Int64): String;
    function InsertProductPriceList(AProductPriceList: TProductPriceList): String;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  uZLConnection.Types,
  uAppRest.Types,
  uHlp,
  uQuotedStr,
  uSmartPointer,
  System.Generics.Collections;

const
  DECIMAL_PLACES = 4;


{ TProductSQLBuilderMySQL }

function TProductSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM product WHERE product.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TProductSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM product WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TProductSQLBuilderMySQL.DeleteProductPriceListsByProductId(AProductId: Int64): String;
begin
  const LSQL = 'DELETE FROM product_price_list WHERE product_id = %s';
  Result := Format(LSQL, [Q(AProductId)]);
end;

function TProductSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO product '+
               '   (name, simplified_name, type, sku_code, ean_code, manufacturing_code, '+
               '    identification_code, cost, marketup, price, current_quantity, minimum_quantity, '+
               '    maximum_quantity, gross_weight, net_weight, packing_weight, flg_to_move_the_stock, '+
               '    flg_product_for_scales, flg_additional, internal_note, complement_note, flg_discontinued, genre, check_value_before_insert, '+
               '    unit_id, ncm_id, category_id, brand_id, size_id, storage_location_id, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)';
  const LProduct = AEntity as TProduct;

  Result := Format(LSQL, [
    Q(LProduct.name),
    Q(LProduct.simplified_name),
    Q(Ord(LProduct.&type)),
    Q(LProduct.sku_code),
    Q(LProduct.ean_code),
    Q(LProduct.manufacturing_code),
    Q(LProduct.identification_code),
    Q(LProduct.cost, DECIMAL_PLACES),
    Q(LProduct.marketup, DECIMAL_PLACES),
    Q(LProduct.price, DECIMAL_PLACES),
    Q(LProduct.current_quantity, DECIMAL_PLACES),
    Q(LProduct.minimum_quantity, DECIMAL_PLACES),
    Q(LProduct.maximum_quantity, DECIMAL_PLACES),
    Q(LProduct.gross_weight, DECIMAL_PLACES),
    Q(LProduct.net_weight, DECIMAL_PLACES),
    Q(LProduct.packing_weight, DECIMAL_PLACES),
    Q(LProduct.flg_to_move_the_stock),
    Q(LProduct.flg_product_for_scales),
    Q(LProduct.flg_additional),
    Q(LProduct.internal_note),
    Q(LProduct.complement_note),
    Q(LProduct.flg_discontinued),
    Q(Ord(LProduct.genre)),
    Q(Ord(LProduct.check_value_before_insert)),
    QN(LProduct.unit_id),
    QN(LProduct.ncm_id),
    QN(LProduct.category_id),
    QN(LProduct.brand_id),
    QN(LProduct.size_id),
    QN(LProduct.storage_location_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LProduct.created_by_acl_user_id)
  ]);
end;

function TProductSQLBuilderMySQL.InsertProductPriceList(AProductPriceList: TProductPriceList): String;
begin
  const LSQL = ' INSERT INTO product_price_list '+
               '   (product_id, price_list_id, price) '+
               ' VALUES '+
               '   (%s, %s, %s)';
  Result := Format(LSQL, [
    Q(AProductPriceList.product_id),
    Q(AProductPriceList.price_list_id),
    Q(AProductPriceList.price, DECIMAL_PLACES)
  ]);
end;

function TProductSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TProductSQLBuilderMySQL.Make: IProductSQLBuilder;
begin
  Result := Self.Create;
end;

function TProductSQLBuilderMySQL.RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
begin
  const LSQL = 'SELECT %s FROM product WHERE %s = %s AND product.id <> %s';
  Result := Format(LSQL, [
    AColumName,
    AColumName,
    Q(AColumnValue),
    AId.ToString
  ]);
end;

function TProductSQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   product.*, '+
         '   unit.name as unit_name, '+
         '   ncm.code as ncm_code, '+
         '   ncm.name as ncm_name, '+
         '   category.name as category_name, '+
         '   brand.name as brand_name, '+
         '   size.name as size_name, '+
         '   storage_location.name as storage_location_name, '+
         '   created_by_acl_user.name as created_by_acl_user_name, '+
         '   updated_by_acl_user.name as updated_by_acl_user_name '+
         ' FROM '+
         '   product '+
         ' INNER JOIN unit '+
         '         ON unit.id = product.unit_id '+
         ' INNER JOIN ncm '+
         '         ON ncm.id = product.ncm_id '+
         '  LEFT JOIN category '+
         '         ON category.id = product.category_id '+
         '  LEFT JOIN brand '+
         '         ON brand.id = product.brand_id '+
         '  LEFT JOIN size '+
         '         ON size.id = product.size_id '+
         '  LEFT JOIN storage_location '+
         '         ON storage_location.id = product.storage_location_id '+
         '  LEFT JOIN acl_user created_by_acl_user '+
         '         ON created_by_acl_user.id = product.created_by_acl_user_id '+
         '  LEFT JOIN acl_user updated_by_acl_user '+
         '         ON updated_by_acl_user.id = product.updated_by_acl_user_id ';
begin
  Result := LSQL;
end;

function TProductSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'product.id', ddMySql);
end;

function TProductSQLBuilderMySQL.SelectByEanOrSkuCode(AValue: String): String;
begin
  Result := SelectAll + ' WHERE (product.ean_code = ' + Q(AValue.Trim) + ' OR product.sku_code = ' + Q(AValue.Trim) + ')';
end;

function TProductSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE product.id = ' + AId.ToString;
end;

function TProductSQLBuilderMySQL.SelectProductPriceListsByProductId(AProductId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   product_price_list.*, '+
               '   price_list.name as price_list_name '+
               ' FROM '+
               '   product_price_list '+
               ' INNER JOIN price_list '+
               '         ON price_list.id = product_price_list.price_list_id '+
               ' WHERE '+
               '   product_price_list.product_id = %s '+
               ' ORDER BY '+
               '   product_price_list.id';
  Result := Format(LSQL, [Q(AProductId)]);
end;

function TProductSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE product SET '+
               '   name = %s, '+
               '   simplified_name = %s, '+
               '   type = %s, '+
               '   sku_code = %s, '+
               '   ean_code = %s, '+
               '   manufacturing_code = %s, '+
               '   identification_code = %s, '+
               '   cost = %s, '+
               '   marketup = %s, '+
               '   price = %s, '+
               '   current_quantity = %s, '+
               '   minimum_quantity = %s, '+
               '   maximum_quantity = %s, '+
               '   gross_weight = %s, '+
               '   net_weight = %s, '+
               '   packing_weight = %s, '+
               '   flg_to_move_the_stock = %s, '+
               '   flg_product_for_scales = %s, '+
               '   flg_additional = %s, '+
               '   internal_note = %s, '+
               '   complement_note = %s, '+
               '   flg_discontinued = %s, '+
               '   genre = %s, '+
               '   check_value_before_insert = %s, '+
               '   unit_id = %s, '+
               '   ncm_id = %s, '+
               '   category_id = %s, '+
               '   brand_id = %s, '+
               '   size_id = %s, '+
               '   storage_location_id = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LProduct = AEntity as TProduct;

  Result := Format(LSQL, [
    Q(LProduct.name),
    Q(LProduct.simplified_name),
    Q(Ord(LProduct.&type)),
    Q(LProduct.sku_code),
    Q(LProduct.ean_code),
    Q(LProduct.manufacturing_code),
    Q(LProduct.identification_code),
    Q(LProduct.cost, DECIMAL_PLACES),
    Q(LProduct.marketup, DECIMAL_PLACES),
    Q(LProduct.price, DECIMAL_PLACES),
    Q(LProduct.current_quantity, DECIMAL_PLACES),
    Q(LProduct.minimum_quantity, DECIMAL_PLACES),
    Q(LProduct.maximum_quantity, DECIMAL_PLACES),
    Q(LProduct.gross_weight, DECIMAL_PLACES),
    Q(LProduct.net_weight, DECIMAL_PLACES),
    Q(LProduct.packing_weight, DECIMAL_PLACES),
    Q(LProduct.flg_to_move_the_stock),
    Q(LProduct.flg_product_for_scales),
    Q(LProduct.flg_additional),
    Q(LProduct.internal_note),
    Q(LProduct.complement_note),
    Q(LProduct.flg_discontinued),
    Q(Ord(LProduct.genre)),
    Q(Ord(LProduct.check_value_before_insert)),
    QN(LProduct.unit_id),
    QN(LProduct.ncm_id),
    QN(LProduct.category_id),
    QN(LProduct.brand_id),
    QN(LProduct.size_id),
    QN(LProduct.storage_location_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LProduct.updated_by_acl_user_id),
    Q(LProduct.id)
  ]);
end;

end.

