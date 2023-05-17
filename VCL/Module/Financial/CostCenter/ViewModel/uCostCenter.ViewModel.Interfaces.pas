unit uCostCenter.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uCostCenter.Show.DTO,
  uCostCenter.Input.DTO,
  uZLMemTable.Interfaces;

type
  ICostCenterViewModel = Interface(IBaseViewModel)
    ['{7AB49534-A5F6-43ED-B1F2-1B6EB242425F}']
    function  FromShowDTO(AInput: TCostCenterShowDTO): ICostCenterViewModel;
    function  ToInputDTO: TCostCenterInputDTO;
    function  EmptyDataSets: ICostCenterViewModel;
    function  SetEvents: ICostCenterViewModel;

    function  CostCenter: IZLMemTable;
  end;

implementation

end.


