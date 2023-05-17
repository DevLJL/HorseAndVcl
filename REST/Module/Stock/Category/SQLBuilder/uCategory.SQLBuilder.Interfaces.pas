unit uCategory.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  ICategorySQLBuilder = interface(IBaseSQLBuilder)
    ['{6424342B-6274-446E-93C5-A4F7041EF30C}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

