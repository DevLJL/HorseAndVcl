unit uBank.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uBank.Show.DTO,
  uBank.Input.DTO,
  uZLMemTable.Interfaces;

type
  IBankViewModel = Interface(IBaseViewModel)
    ['{C516B9E4-F443-49AC-80C8-779247290F4A}']
    function  FromShowDTO(AInput: TBankShowDTO): IBankViewModel;
    function  ToInputDTO: TBankInputDTO;
    function  EmptyDataSets: IBankViewModel;
    function  SetEvents: IBankViewModel;

    function  Bank: IZLMemTable;
  end;

implementation

end.


