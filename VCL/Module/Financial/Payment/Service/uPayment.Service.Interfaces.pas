unit uPayment.Service.Interfaces;

interface

uses
  uBase.Service,
  uPayment.Filter.DTO,
  uIndexResult,
  uPayment.Show.DTO,
  uPayment.Input.DTO,
  uEither,
  uZLMemTable.Interfaces;

type
  IPaymentService = Interface(IBaseService)
    ['{013C990B-4555-4D7A-A588-AD7DB975F59A}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TPaymentFilterDTO = nil): Either<String, IIndexResult>;
    function ListPaymentTerms(AId: Int64): IZLMemTable;
    function Show(AId: Int64): TPaymentShowDTO;
    function StoreAndShow(AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
  End;

implementation

end.
