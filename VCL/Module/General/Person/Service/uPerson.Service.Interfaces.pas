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
    ['{9C50D5DC-B425-4D70-9B5D-7D9758436A8B}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TPersonFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TPersonShowDTO;
    function StoreAndShow(AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
  End;

implementation

end.
