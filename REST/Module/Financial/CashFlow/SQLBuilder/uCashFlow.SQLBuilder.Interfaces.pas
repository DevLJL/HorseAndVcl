unit uCashFlow.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uCashFlowTransaction;

type
  ICashFlowSQLBuilder = interface(IBaseSQLBuilder)
    ['{EF54429D-5BFE-4EDF-B5CB-ADF86B846003}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function StationInUse(AStationId: Int64; ADiffCashFlowId: Int64 = 0): String;

    function ScriptCashFlowTransactionTable: String;
    function SelectCashFlowTransactionsByCashFlowId(ACashFlowId: Int64): String;
    function DeleteCashFlowTransactionsByCashFlowId(ACashFlowId: Int64): String;
    function InsertCashFlowTransaction(ACashFlowTransaction: TCashFlowTransaction): String;
  end;

implementation

end.


