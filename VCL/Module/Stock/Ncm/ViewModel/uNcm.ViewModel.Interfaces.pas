unit uNcm.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uNcm.Show.DTO,
  uNcm.Input.DTO,
  uZLMemTable.Interfaces;

type
  INcmViewModel = Interface(IBaseViewModel)
    ['{D571AFC3-AA1E-4BB6-AA69-0EA5334EF601}']
    function  FromShowDTO(AInput: TNcmShowDTO): INcmViewModel;
    function  ToInputDTO: TNcmInputDTO;
    function  EmptyDataSets: INcmViewModel;
    function  SetEvents: INcmViewModel;

    function  Ncm: IZLMemTable;
  end;

implementation

end.


