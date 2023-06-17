unit uStation.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uStation.Show.DTO,
  uStation.Input.DTO,
  uZLMemTable.Interfaces;

type
  IStationViewModel = Interface(IBaseViewModel)
    ['{72AEA021-8F40-4A3A-8A09-B09B0EEF4619}']
    function  FromShowDTO(AInput: TStationShowDTO): IStationViewModel;
    function  ToInputDTO: TStationInputDTO;
    function  EmptyDataSets: IStationViewModel;
    function  SetEvents: IStationViewModel;

    function  Station: IZLMemTable;
  end;

implementation

end.


