unit uCity.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter;

type
  ICitySQLBuilder = interface(IBaseSQLBuilder)
    ['{C8AC8741-ADA0-4013-B23F-B1DEE973A6D1}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

