unit uConsumption.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uConsumption.Show.DTO,
  uConsumption.Input.DTO,
  uZLMemTable.Interfaces;

type
  IConsumptionViewModel = Interface(IBaseViewModel)
    ['{CC80A375-3B93-474E-BF65-203FC818AA09}']
    function  FromShowDTO(AInput: TConsumptionShowDTO): IConsumptionViewModel;
    function  ToInputDTO: TConsumptionInputDTO;
    function  EmptyDataSets: IConsumptionViewModel;
    function  SetEvents: IConsumptionViewModel;

    function  Consumption: IZLMemTable;
  end;

implementation

end.


