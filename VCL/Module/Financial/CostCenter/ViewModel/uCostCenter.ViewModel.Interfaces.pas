unit uCostCenter.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uCostCenter.Show.DTO,
  uCostCenter.Input.DTO,
  uZLMemTable.Interfaces;

type
  ICostCenterViewModel = Interface(IBaseViewModel)
    ['{BB384CFF-0449-470B-AF9B-609CA7B4A7D5}']
    function  FromShowDTO(AInput: TCostCenterShowDTO): ICostCenterViewModel;
    function  ToInputDTO: TCostCenterInputDTO;
    function  EmptyDataSets: ICostCenterViewModel;
    function  SetEvents: ICostCenterViewModel;

    function  CostCenter: IZLMemTable;
  end;

implementation

end.


