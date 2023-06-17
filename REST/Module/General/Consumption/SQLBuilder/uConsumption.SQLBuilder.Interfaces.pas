unit uConsumption.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter;

type
  IConsumptionSQLBuilder = interface(IBaseSQLBuilder)
    ['{84386E9A-60B2-4897-B041-5371C1238E95}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function DeleteByNumbers(AInitial, AFinal: SmallInt): String;
  end;

implementation

end.


