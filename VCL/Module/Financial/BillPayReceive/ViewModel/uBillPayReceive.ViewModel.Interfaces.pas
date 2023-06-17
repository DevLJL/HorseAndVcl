unit uBillPayReceive.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uBillPayReceive.Show.DTO,
  uBillPayReceive.Input.DTO,
  uZLMemTable.Interfaces;

type
  IBillPayReceiveViewModel = Interface(IBaseViewModel)
    ['{4CCABE8A-9CB6-4A96-9C79-50B21BC26486}']
    function  FromShowDTO(AInput: TBillPayReceiveShowDTO): IBillPayReceiveViewModel;
    function  ToInputDTO: TBillPayReceiveInputDTO;
    function  EmptyDataSets: IBillPayReceiveViewModel;
    function  SetEvents: IBillPayReceiveViewModel;

    function  BillPayReceive: IZLMemTable;
  end;

implementation

end.


