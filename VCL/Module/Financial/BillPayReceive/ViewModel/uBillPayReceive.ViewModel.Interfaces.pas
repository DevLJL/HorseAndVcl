unit uBillPayReceive.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uBillPayReceive.Show.DTO,
  uBillPayReceive.Input.DTO,
  uZLMemTable.Interfaces;

type
  IBillPayReceiveViewModel = Interface(IBaseViewModel)
    ['{7AB49534-A5F6-43ED-B1F2-1B6EB242425F}']
    function  FromShowDTO(AInput: TBillPayReceiveShowDTO): IBillPayReceiveViewModel;
    function  ToInputDTO: TBillPayReceiveInputDTO;
    function  EmptyDataSets: IBillPayReceiveViewModel;
    function  SetEvents: IBillPayReceiveViewModel;

    function  BillPayReceive: IZLMemTable;
  end;

implementation

end.


