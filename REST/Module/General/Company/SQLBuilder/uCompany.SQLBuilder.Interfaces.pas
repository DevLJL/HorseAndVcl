unit uCompany.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter;

type
  ICompanySQLBuilder = interface(IBaseSQLBuilder)
    ['{56893898-15AF-4D1D-9514-D3F0635D7A88}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

