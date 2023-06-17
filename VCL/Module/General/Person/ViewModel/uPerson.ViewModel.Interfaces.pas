unit uPerson.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uPerson.Show.DTO,
  uPerson.Input.DTO,
  uZLMemTable.Interfaces;

type
  IPersonViewModel = Interface(IBaseViewModel)
    ['{742447B6-41FF-467F-91C5-E091E220C4E4}']
    function  FromShowDTO(AInput: TPersonShowDTO): IPersonViewModel;
    function  ToInputDTO: TPersonInputDTO;
    function  EmptyDataSets: IPersonViewModel;
    function  SetEvents: IPersonViewModel;

    function  Person: IZLMemTable;
    function  PersonContacts: IZLMemTable;
  end;

  IPersonContactsViewModel = Interface
    ['{42EC4CD9-8D6D-457B-BCD6-79BE287E781B}']
    function  PersonContacts: IZLMemTable;
    function  SetEvents: IPersonContactsViewModel;
  End;

implementation

end.

