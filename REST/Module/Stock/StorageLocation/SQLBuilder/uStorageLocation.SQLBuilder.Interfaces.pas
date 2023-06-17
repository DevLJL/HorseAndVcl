unit uStorageLocation.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IStorageLocationSQLBuilder = interface(IBaseSQLBuilder)
    ['{8500866D-FC90-430C-AFD3-E15B6A72A7C8}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

