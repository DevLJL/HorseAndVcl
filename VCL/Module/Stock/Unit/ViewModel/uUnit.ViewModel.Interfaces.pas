unit uUnit.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uUnit.Show.DTO,
  uUnit.Input.DTO,
  uZLMemTable.Interfaces;

type
  IUnitViewModel = Interface(IBaseViewModel)
    ['{2C812640-819E-4D40-89EA-D15301D4AA35}']
    function  FromShowDTO(AInput: TUnitShowDTO): IUnitViewModel;
    function  ToInputDTO: TUnitInputDTO;
    function  EmptyDataSets: IUnitViewModel;
    function  SetEvents: IUnitViewModel;

    function  &Unit: IZLMemTable;
  end;

implementation

end.


