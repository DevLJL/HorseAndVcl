unit uUnit.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IUnitSQLBuilder = interface(IBaseSQLBuilder)
    ['{5F924ED3-0D07-459E-9790-B917E8BED7C2}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

