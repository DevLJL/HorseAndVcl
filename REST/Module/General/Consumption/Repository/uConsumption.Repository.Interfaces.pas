unit uConsumption.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uConsumption,
  uZLMemTable.Interfaces,
  uConsumptionSale.Filter;

type
  IConsumptionRepository = interface(IBaseRepository)
    ['{22AEE554-0317-47A0-8C46-3F3356AA851A}']
    function Show(AId: Int64): TConsumption;
    function DeleteByNumbers(AInitial, AFinal: SmallInt): IConsumptionRepository;
    function IndexWithSale(AFilter: IConsumptionSaleFilter): IZLMemTable;
  end;

implementation

end.



