unit uPosPrinter.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IPosPrinterSQLBuilder = interface(IBaseSQLBuilder)
    ['{9027D070-89E2-4F55-A578-2C37087DFCF1}']

    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

