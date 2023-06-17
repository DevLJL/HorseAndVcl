unit uBankAccount.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IBankAccountSQLBuilder = interface(IBaseSQLBuilder)
    ['{4DB30553-4AA4-40F1-9AE0-69859475B033}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

