unit uConsumption.Service.Interfaces;

interface

uses
  uBase.Service,
  uConsumption.Filter.DTO,
  uIndexResult,
  uConsumption.Show.DTO,
  uConsumption.Input.DTO,
  uEither;

type
  IConsumptionService = Interface(IBaseService)
    ['{32133C5C-1CE2-4221-8FBC-5C0B01DD0E0C}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TConsumptionFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TConsumptionShowDTO;
    function StoreAndShow(AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
  End;

implementation

end.
