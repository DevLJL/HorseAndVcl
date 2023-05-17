unit uAclRole.SQLBuilder.Interfaces;

interface

uses
  uAclRole,
  uFilter,
  uSelectWithFilter,
  uBase.SQLBuilder.Interfaces;

type
  IAclRoleSQLBuilder = interface(IBaseSQLBuilder)
    ['{1459C04C-5F0A-4C0B-9627-4CB03467A1F9}']

    // AclRole
    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

