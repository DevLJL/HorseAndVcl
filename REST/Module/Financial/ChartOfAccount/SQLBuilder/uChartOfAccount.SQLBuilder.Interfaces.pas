unit uChartOfAccount.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IChartOfAccountSQLBuilder = interface(IBaseSQLBuilder)
    ['{C042284E-E0E8-4FB5-BBA7-DE645C2CDE7C}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

