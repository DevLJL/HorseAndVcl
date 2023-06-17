unit uAdditional.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter,
  uAdditionalProduct;

type
  IAdditionalSQLBuilder = interface(IBaseSQLBuilder)
    ['{AD872C6D-F87F-4A5E-B81C-A1453AA0BEB0}']

    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;

    // AdditionalProduct
    function SelectAdditionalProductsByAdditionalId(AAdditionalId: Int64): String;
    function DeleteAdditionalProductsByAdditionalId(AAdditionalId: Int64): String;
    function InsertAdditionalProduct(AAdditionalProduct: TAdditionalProduct): String;
  end;

implementation

end.

