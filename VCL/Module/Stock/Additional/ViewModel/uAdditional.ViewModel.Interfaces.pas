unit uAdditional.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uAdditional.Show.DTO,
  uAdditional.Input.DTO,
  uZLMemTable.Interfaces;

type
  IAdditionalViewModel = Interface(IBaseViewModel)
    ['{968DCE99-5958-4BE6-88D5-74FD166337E9}']
    function  FromShowDTO(AInput: TAdditionalShowDTO): IAdditionalViewModel;
    function  ToInputDTO: TAdditionalInputDTO;
    function  EmptyDataSets: IAdditionalViewModel;
    function  SetEvents: IAdditionalViewModel;

    function  Additional: IZLMemTable;
    function  AdditionalProducts: IZLMemTable;
  end;

  IAdditionalProductsViewModel = Interface
    ['{2F2376E3-BA32-45F1-90C5-F5A3C948E926}']
    function  AdditionalProducts: IZLMemTable;
    function  SetEvents: IAdditionalProductsViewModel;
  End;

implementation

end.


