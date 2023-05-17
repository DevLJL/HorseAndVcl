unit uUnit.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IUnitSQLBuilder = interface(IBaseSQLBuilder)
    ['{3A02900B-8634-4AEB-93B1-89B6CD3AF304}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

