unit uConsumption.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uConsumption.Show.DTO,
  uConsumption.Input.DTO,
  uZLMemTable.Interfaces;

type
  IConsumptionViewModel = Interface(IBaseViewModel)
    ['{7AB49534-A5F6-43ED-B1F2-1B6EB242425F}']
    function  FromShowDTO(AInput: TConsumptionShowDTO): IConsumptionViewModel;
    function  ToInputDTO: TConsumptionInputDTO;
    function  EmptyDataSets: IConsumptionViewModel;
    function  SetEvents: IConsumptionViewModel;

    function  Consumption: IZLMemTable;
  end;

implementation

end.


