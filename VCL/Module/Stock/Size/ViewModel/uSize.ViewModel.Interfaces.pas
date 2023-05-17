unit uSize.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uSize.Show.DTO,
  uSize.Input.DTO,
  uZLMemTable.Interfaces;

type
  ISizeViewModel = Interface(IBaseViewModel)
    ['{3C5D4ECC-84FA-4531-875A-987531B8BE58}']
    function  FromShowDTO(AInput: TSizeShowDTO): ISizeViewModel;
    function  ToInputDTO: TSizeInputDTO;
    function  EmptyDataSets: ISizeViewModel;
    function  SetEvents: ISizeViewModel;

    function  Size: IZLMemTable;
  end;

implementation

end.


