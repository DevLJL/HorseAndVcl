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
    ['{9C50D5DC-B425-4D70-9B5D-7D9758436A8B}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCashFlowFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCashFlowShowDTO;
    function StoreAndShow(AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
  End;

implementation

end.
