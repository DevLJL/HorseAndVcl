unit uSize.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  ISizeSQLBuilder = interface(IBaseSQLBuilder)
    ['{842BB107-B2EB-4593-BC87-ED16419EE815}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

