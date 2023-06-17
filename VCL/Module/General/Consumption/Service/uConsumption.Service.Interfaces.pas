unit uConsumption.Service.Interfaces;

interface

uses
  uBase.Service,
  uConsumption.Filter.DTO,
  uIndexResult,
  uConsumption.Show.DTO,
  uConsumption.Input.DTO,
  uEither,
  uConsumptionSale.Filter.DTO,
  uZLMemTable.Interfaces;

type
  IConsumptionService = Interface(IBaseService)
    ['{E6504979-E661-409F-A9DE-9E22FCDF4B21}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TConsumptionFilterDTO = nil): Either<String, IIndexResult>;
    function IndexWithSale(AFilter: TConsumptionSaleFilterDTO = nil): Either<String, IZLMemTable>;
    function Show(AId: Int64): TConsumptionShowDTO;
    function StoreAndShow(AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
  End;

implementation

end.
