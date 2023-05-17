unit uCashFlow.Persistence.UseCase.Interfaces;

interface

uses
  uCashFlow.Filter.DTO,
  uIndexResult,
  uCashFlow.Show.DTO,
  uCashFlow.Input.DTO,
  uFilter,
  uEither;

type
  ICashFlowPersistenceUseCase = Interface
    ['{4636F89A-2098-4CC3-9319-32B85ABAA9CD}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCashFlowFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCashFlowShowDTO;
    function StoreAndShow(AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
    function Store(AInput: TCashFlowInputDTO): Int64;
    function Update(APK: Int64; AInput: TCashFlowInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
  end;


implementation

end.
