unit uStorageLocation.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uStorageLocation.Show.DTO,
  uStorageLocation.Input.DTO,
  uZLMemTable.Interfaces;

type
  IStorageLocationViewModel = Interface(IBaseViewModel)
    ['{B3409560-44CE-41E7-B496-0E01FA95E245}']
    function  FromShowDTO(AInput: TStorageLocationShowDTO): IStorageLocationViewModel;
    function  ToInputDTO: TStorageLocationInputDTO;
    function  EmptyDataSets: IStorageLocationViewModel;
    function  SetEvents: IStorageLocationViewModel;

    function  StorageLocation: IZLMemTable;
  end;

implementation

end.


