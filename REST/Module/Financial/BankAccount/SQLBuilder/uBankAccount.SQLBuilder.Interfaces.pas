unit uBankAccount.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IBankAccountSQLBuilder = interface(IBaseSQLBuilder)
    ['{95853A62-3683-4555-9A56-54C1EA882C61}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

