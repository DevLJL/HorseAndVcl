unit uPerson.Persistence.UseCase.Interfaces;

interface

uses
  uPerson.Filter.DTO,
  uIndexResult,
  uPerson.Show.DTO,
  uPerson.Input.DTO,
  uFilter,
  uEither;

type
  IPersonPersistenceUseCase = Interface
    ['{923B36FC-13D6-4F26-A4A8-50D6238A09C8}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TPersonFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TPersonShowDTO;
    function StoreAndShow(AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
    function Store(AInput: TPersonInputDTO): Int64;
    function Update(APK: Int64; AInput: TPersonInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
  end;


implementation

end.
