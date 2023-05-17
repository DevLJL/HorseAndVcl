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
    ['{20EA2F29-0BC5-4934-A0A1-408F86513656}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function ShowByLoginAndPassword(ALogin, APassword: String): String;
  end;

implementation

end.

