unit uConsumption.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter;

type
  IConsumptionSQLBuilder = interface(IBaseSQLBuilder)
    ['{2C354AB3-1D34-42BE-A627-016D7F4716DF}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function DeleteByNumbers(AInitial, AFinal: SmallInt): String;
  end;

implementation

end.


