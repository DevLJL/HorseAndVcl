unit uBrand.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IBrandSQLBuilder = interface(IBaseSQLBuilder)
    ['{01AC99C9-A17E-4164-9B49-4703C8B69915}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

