unit uCashFlow.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uCashFlowTransaction;

type
  ICashFlowSQLBuilder = interface(IBaseSQLBuilder)
    ['{4341A8E1-217D-4BB3-80E9-FA182AA56868}']

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


