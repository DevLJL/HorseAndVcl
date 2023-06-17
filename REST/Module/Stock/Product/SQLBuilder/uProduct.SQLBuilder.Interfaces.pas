unit uProduct.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter,
  uProductPriceList;

type
  IProductSQLBuilder = interface(IBaseSQLBuilder)
    ['{B8D9F427-000B-4697-9F74-3115CFB3CA21}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
    function SelectByEanOrSkuCode(AValue: String): String;

    // ProductPriceList
    function SelectProductPriceListsByProductId(AProductId: Int64): String;
    function DeleteProductPriceListsByProductId(AProductId: Int64): String;
    function InsertProductPriceList(AProductPriceList: TProductPriceList): String;
  end;

implementation

end.

