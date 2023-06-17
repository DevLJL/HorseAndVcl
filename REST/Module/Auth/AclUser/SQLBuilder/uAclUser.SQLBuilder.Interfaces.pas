unit uAclUser.SQLBuilder.Interfaces;

interface

uses
  uAclUser,
  uFilter,
  uSelectWithFilter,
  uBase.SQLBuilder.Interfaces,
  uBase.Entity;

type
  IAclUserSQLBuilder = interface(IBaseSQLBuilder)
    ['{1D94D95C-4C7F-46B1-B1F5-564A167CFDC3}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function ShowByLoginAndPassword(ALogin, APassword: String): String;
  end;

implementation

end.

