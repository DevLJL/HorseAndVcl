unit uPerson.Service.Interfaces;

interface

uses
  uBase.Service,
  uPerson.Filter.DTO,
  uIndexResult,
  uPerson.Show.DTO,
  uPerson.Input.DTO,
  uEither;

type
  IPersonService = Interface(IBaseService)
    ['{B3B61644-0766-4A60-AF4F-60C5F6C53001}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TPersonFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TPersonShowDTO;
    function StoreAndShow(AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
  End;

implementation

end.
