unit uChartOfAccount.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IChartOfAccountSQLBuilder = interface(IBaseSQLBuilder)
    ['{A1AB41C2-1B1D-4F35-8599-874CE8AD63C2}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

