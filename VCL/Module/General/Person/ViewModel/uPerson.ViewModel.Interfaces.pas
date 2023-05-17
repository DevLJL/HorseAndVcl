unit uPerson.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uPerson.Show.DTO,
  uPerson.Input.DTO,
  uZLMemTable.Interfaces;

type
  IPersonViewModel = Interface(IBaseViewModel)
    ['{DFFE2945-2496-4373-B50B-4ED3D293B2A0}']
    function  FromShowDTO(AInput: TPersonShowDTO): IPersonViewModel;
    function  ToInputDTO: TPersonInputDTO;
    function  EmptyDataSets: IPersonViewModel;
    function  SetEvents: IPersonViewModel;

    function  Person: IZLMemTable;
    function  PersonContacts: IZLMemTable;
  end;

  IPersonContactsViewModel = Interface
    ['{A22A23BD-BBAD-461F-9BDB-E46E3CE68CF3}']
    function  PersonContacts: IZLMemTable;
    function  SetEvents: IPersonContactsViewModel;
  End;

implementation

end.

