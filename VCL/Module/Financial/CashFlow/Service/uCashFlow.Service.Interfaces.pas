unit uCashFlow.Service.Interfaces;

interface

uses
  uBase.Service,
  uCashFlow.Filter.DTO,
  uIndexResult,
  uCashFlow.Show.DTO,
  uCashFlow.Input.DTO,
  uEither;

type
  ICashFlowService = Interface(IBaseService)
    ['{7884E94B-7EF9-46E2-9973-43042A266F3D}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCashFlowFilterDTO = nil): Either<String, IIndexResult>;
    function IsOpenedByStationId(AStationId: Int64): Boolean;
    function Show(AId: Int64): TCashFlowShowDTO;
    function StoreAndShow(AInput: TCashFlowInputDTO; AReturnShowDTO: Boolean = true): Either<String, TCashFlowShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
  End;

implementation

end.
