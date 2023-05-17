unit uCity.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter;

type
  ICitySQLBuilder = interface(IBaseSQLBuilder)
    ['{08F95EB5-9CD2-4B9C-872D-029B36399E12}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

