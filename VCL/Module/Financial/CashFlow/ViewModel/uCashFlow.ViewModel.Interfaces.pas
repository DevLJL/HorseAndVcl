unit uCashFlow.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uCashFlow.Show.DTO,
  uCashFlow.Input.DTO,
  uZLMemTable.Interfaces;

type
  ICashFlowViewModel = Interface(IBaseViewModel)
    ['{DFFE2945-2496-4373-B50B-4ED3D293B2A0}']
    function  FromShowDTO(AInput: TCashFlowShowDTO): ICashFlowViewModel;
    function  ToInputDTO: TCashFlowInputDTO;
    function  EmptyDataSets: ICashFlowViewModel;
    function  SetEvents: ICashFlowViewModel;

    function  CashFlow: IZLMemTable;
    function  CashFlowTransactions: IZLMemTable;
  end;

  ICashFlowTransactionsViewModel = Interface
    ['{A22A23BD-BBAD-461F-9BDB-E46E3CE68CF3}']
    function  CashFlowTransactions: IZLMemTable;
    function  SetEvents: ICashFlowTransactionsViewModel;
  End;

implementation

end.
