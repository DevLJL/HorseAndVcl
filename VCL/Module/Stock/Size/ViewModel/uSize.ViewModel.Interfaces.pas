unit uSize.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uSize.Show.DTO,
  uSize.Input.DTO,
  uZLMemTable.Interfaces;

type
  ISizeViewModel = Interface(IBaseViewModel)
    ['{7AEC24EA-E5B6-4DD3-9393-CF40D50E3A05}']
    function  FromShowDTO(AInput: TSizeShowDTO): ISizeViewModel;
    function  ToInputDTO: TSizeInputDTO;
    function  EmptyDataSets: ISizeViewModel;
    function  SetEvents: ISizeViewModel;

    function  Size: IZLMemTable;
  end;

implementation

end.


