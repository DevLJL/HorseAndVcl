unit uBrand.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IBrandSQLBuilder = interface(IBaseSQLBuilder)
    ['{CDFD9114-DE01-40B4-A894-F88E7AED1BF3}']

    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

