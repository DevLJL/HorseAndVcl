unit uStation.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uStation.Show.DTO,
  uStation.Input.DTO,
  uZLMemTable.Interfaces;

type
  IStationViewModel = Interface(IBaseViewModel)
    ['{7AB49534-A5F6-43ED-B1F2-1B6EB242425F}']
    function  FromShowDTO(AInput: TStationShowDTO): IStationViewModel;
    function  ToInputDTO: TStationInputDTO;
    function  EmptyDataSets: IStationViewModel;
    function  SetEvents: IStationViewModel;

    function  Station: IZLMemTable;
  end;

implementation

end.


