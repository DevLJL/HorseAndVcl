unit uCostCenter.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  ICostCenterSQLBuilder = interface(IBaseSQLBuilder)
    ['{68D7F091-F8D7-4119-BE9D-BADA9169D88F}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

