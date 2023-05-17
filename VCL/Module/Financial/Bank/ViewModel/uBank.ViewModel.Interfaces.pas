unit uBank.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uBank.Show.DTO,
  uBank.Input.DTO,
  uZLMemTable.Interfaces;

type
  IBankViewModel = Interface(IBaseViewModel)
    ['{7AB49534-A5F6-43ED-B1F2-1B6EB242425F}']
    function  FromShowDTO(AInput: TBankShowDTO): IBankViewModel;
    function  ToInputDTO: TBankInputDTO;
    function  EmptyDataSets: IBankViewModel;
    function  SetEvents: IBankViewModel;

    function  Bank: IZLMemTable;
  end;

implementation

end.


