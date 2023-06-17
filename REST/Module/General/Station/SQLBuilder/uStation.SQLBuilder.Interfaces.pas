unit uStation.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IStationSQLBuilder = interface(IBaseSQLBuilder)
    ['{A9C0FD4F-EAEE-4A49-8366-C0F9442A85F1}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

