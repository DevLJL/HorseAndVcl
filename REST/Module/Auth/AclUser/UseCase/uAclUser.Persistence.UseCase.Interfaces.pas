unit uAclUser.Persistence.UseCase.Interfaces;

interface

uses
  uAclUser.Filter.DTO,
  uIndexResult,
  uAclUser.Show.DTO,
  uAclUser.Input.DTO,
  uFilter,
  uEither;

type
  IAclUserPersistenceUseCase = Interface
    ['{F678F475-F3C6-446C-B575-FB2CA2988EE4}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilterDTO: TAclUserFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TAclUserShowDTO;
    function StoreAndShow(AInput: TAclUserInputDTO): Either<String, TAclUserShowDTO>;
    function Store(AInput: TAclUserInputDTO): Int64;
    function Update(APK: Int64; AInput: TAclUserInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TAclUserInputDTO): Either<String, TAclUserShowDTO>;
  end;


implementation

end.
