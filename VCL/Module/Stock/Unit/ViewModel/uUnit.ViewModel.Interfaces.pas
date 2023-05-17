unit uUnit.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uUnit.Show.DTO,
  uUnit.Input.DTO,
  uZLMemTable.Interfaces;

type
  IUnitViewModel = Interface(IBaseViewModel)
    ['{F6D65DBE-5FAD-4C52-8503-60A22EBDD938}']
    function  FromShowDTO(AInput: TUnitShowDTO): IUnitViewModel;
    function  ToInputDTO: TUnitInputDTO;
    function  EmptyDataSets: IUnitViewModel;
    function  SetEvents: IUnitViewModel;

    function  &Unit: IZLMemTable;
  end;

implementation

end.


