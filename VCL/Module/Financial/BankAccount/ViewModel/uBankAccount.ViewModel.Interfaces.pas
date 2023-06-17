unit uBankAccount.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uBankAccount.Show.DTO,
  uBankAccount.Input.DTO,
  uZLMemTable.Interfaces;

type
  IBankAccountViewModel = Interface(IBaseViewModel)
    ['{FC2095B3-D6F8-4581-B9B5-4DA94DB90791}']
    function  FromShowDTO(AInput: TBankAccountShowDTO): IBankAccountViewModel;
    function  ToInputDTO: TBankAccountInputDTO;
    function  EmptyDataSets: IBankAccountViewModel;
    function  SetEvents: IBankAccountViewModel;

    function  BankAccount: IZLMemTable;
  end;

implementation

end.


