unit uAclRole.SQLBuilder.Interfaces;

interface

uses
  uAclRole,
  uFilter,
  uSelectWithFilter,
  uBase.SQLBuilder.Interfaces;

type
  IAclRoleSQLBuilder = interface(IBaseSQLBuilder)
    ['{4B0E40B0-B045-4707-B47F-3470BD1948CB}']

    // AclRole
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

