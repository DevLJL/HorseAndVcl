unit uProduct.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IProductSQLBuilder = interface(IBaseSQLBuilder)
    ['{F1E4C28B-C447-428A-8F90-5F71F5084AC9}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
    function SelectByEanOrSkuCode(AValue: String): String;
  end;

implementation

end.

