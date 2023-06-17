unit uConsumptionSale.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uZLMemTable.Interfaces;

type
  IConsumptionSaleViewModel = Interface(IBaseViewModel)
    ['{3C1AEC9A-4110-4286-894F-E37229CEFE24}']
    function  EmptyDataSets: IConsumptionSaleViewModel;
    function  SetEvents: IConsumptionSaleViewModel;
    function  ConsumptionSale: IZLMemTable;
  end;

implementation

end.


