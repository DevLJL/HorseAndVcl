unit uCashFlow.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uCashFlow.Show.DTO,
  uCashFlow.Input.DTO,
  uZLMemTable.Interfaces;

type
  ICashFlowViewModel = Interface(IBaseViewModel)
    ['{F9B51FC5-9116-428A-A223-B888B7DC56FE}']
    function  FromShowDTO(AInput: TCashFlowShowDTO): ICashFlowViewModel;
    function  ToInputDTO: TCashFlowInputDTO;
    function  EmptyDataSets: ICashFlowViewModel;
    function  SetEvents: ICashFlowViewModel;

    function  CashFlow: IZLMemTable;
    function  CashFlowTransactions: IZLMemTable;
  end;

  ICashFlowTransactionsViewModel = Interface
    ['{8FB4AB1F-15E4-49C0-BED6-2AC51D151E09}']
    function  CashFlowTransactions: IZLMemTable;
    function  SetEvents: ICashFlowTransactionsViewModel;
  End;

implementation

end.
