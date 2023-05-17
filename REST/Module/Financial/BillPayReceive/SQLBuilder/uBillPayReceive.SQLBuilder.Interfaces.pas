unit uBillPayReceive.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter;

type
  IBillPayReceiveSQLBuilder = interface(IBaseSQLBuilder)
    ['{5F61055B-59F6-4D0C-94E9-B8056B51FAD4}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.


