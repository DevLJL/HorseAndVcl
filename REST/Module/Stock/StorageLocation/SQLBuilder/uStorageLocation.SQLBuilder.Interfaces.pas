unit uStorageLocation.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IStorageLocationSQLBuilder = interface(IBaseSQLBuilder)
    ['{7175F19D-6BFB-4A67-8203-5229F1E038AD}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

