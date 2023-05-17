unit uNcm.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uNcm.Show.DTO,
  uNcm.Input.DTO,
  uZLMemTable.Interfaces;

type
  INcmViewModel = Interface(IBaseViewModel)
    ['{8C2DF3A4-800D-45CB-B3C0-FC3D09085ABE}']
    function  FromShowDTO(AInput: TNcmShowDTO): INcmViewModel;
    function  ToInputDTO: TNcmInputDTO;
    function  EmptyDataSets: INcmViewModel;
    function  SetEvents: INcmViewModel;

    function  Ncm: IZLMemTable;
  end;

implementation

end.


