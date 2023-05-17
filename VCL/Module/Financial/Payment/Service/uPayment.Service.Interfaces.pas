unit uPayment.Service.Interfaces;

interface

uses
  uBase.Service,
  uPayment.Filter.DTO,
  uIndexResult,
  uPayment.Show.DTO,
  uPayment.Input.DTO,
  uEither;

type
  IPaymentService = Interface(IBaseService)
    ['{9C50D5DC-B425-4D70-9B5D-7D9758436A8B}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TPaymentFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TPaymentShowDTO;
    function StoreAndShow(AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
  End;

implementation

end.
