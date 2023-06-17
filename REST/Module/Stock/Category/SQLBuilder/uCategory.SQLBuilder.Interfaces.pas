unit uCategory.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  ICategorySQLBuilder = interface(IBaseSQLBuilder)
    ['{0C4398AE-FDDB-45F4-AE65-D830D6A71C37}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

