unit uBankAccount.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uBankAccount.Show.DTO,
  uBankAccount.Input.DTO,
  uZLMemTable.Interfaces;

type
  IBankAccountViewModel = Interface(IBaseViewModel)
    ['{7AB49534-A5F6-43ED-B1F2-1B6EB242425F}']
    function  FromShowDTO(AInput: TBankAccountShowDTO): IBankAccountViewModel;
    function  ToInputDTO: TBankAccountInputDTO;
    function  EmptyDataSets: IBankAccountViewModel;
    function  SetEvents: IBankAccountViewModel;

    function  BankAccount: IZLMemTable;
  end;

implementation

end.


