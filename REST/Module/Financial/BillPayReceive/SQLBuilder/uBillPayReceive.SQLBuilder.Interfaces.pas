unit uBillPayReceive.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter;

type
  IBillPayReceiveSQLBuilder = interface(IBaseSQLBuilder)
    ['{96483028-3917-43E1-9C99-F3158C8CB23F}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.


