unit uPriceList.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IPriceListSQLBuilder = interface(IBaseSQLBuilder)
    ['{B163F80E-3A78-4FA9-B458-0261184FA010}']

    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

