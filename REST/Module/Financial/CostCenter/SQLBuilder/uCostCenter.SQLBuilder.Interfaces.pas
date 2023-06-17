unit uCostCenter.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  ICostCenterSQLBuilder = interface(IBaseSQLBuilder)
    ['{1E1F9798-DEC4-4E13-A81B-92674A5080BA}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

