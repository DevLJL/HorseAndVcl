unit uStation.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IStationSQLBuilder = interface(IBaseSQLBuilder)
    ['{A7C2E48F-0C9F-4787-A0B0-EE9E0ED0C1A1}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

