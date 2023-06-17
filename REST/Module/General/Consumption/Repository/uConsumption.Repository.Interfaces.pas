unit uConsumption.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uConsumption,
  uZLMemTable.Interfaces,
  uConsumptionSale.Filter;

type
  IConsumptionRepository = interface(IBaseRepository)
    ['{A45706B2-D387-4130-9EAC-C8E38ABEC379}']
    function Show(AId: Int64): TConsumption;
    function DeleteByNumbers(AInitial, AFinal: SmallInt): IConsumptionRepository;
    function IndexWithSale(AFilter: IConsumptionSaleFilter): IZLMemTable;
  end;

implementation

end.



