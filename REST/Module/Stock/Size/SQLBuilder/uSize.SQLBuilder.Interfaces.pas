unit uSize.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  ISizeSQLBuilder = interface(IBaseSQLBuilder)
    ['{8423BA18-FC26-4514-BDDF-DB8CAAF627F1}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

