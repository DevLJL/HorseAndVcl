unit uTenant.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter;

type
  ITenantSQLBuilder = interface(IBaseSQLBuilder)
    ['{E422AC34-DD82-4C98-89D6-834730040F28}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

