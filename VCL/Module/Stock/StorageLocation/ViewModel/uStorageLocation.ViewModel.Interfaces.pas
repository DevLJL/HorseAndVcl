unit uStorageLocation.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uStorageLocation.Show.DTO,
  uStorageLocation.Input.DTO,
  uZLMemTable.Interfaces;

type
  IStorageLocationViewModel = Interface(IBaseViewModel)
    ['{5428BB3D-0086-48BF-B7E7-EAD8D17FD0DB}']
    function  FromShowDTO(AInput: TStorageLocationShowDTO): IStorageLocationViewModel;
    function  ToInputDTO: TStorageLocationInputDTO;
    function  EmptyDataSets: IStorageLocationViewModel;
    function  SetEvents: IStorageLocationViewModel;

    function  StorageLocation: IZLMemTable;
  end;

implementation

end.


