unit uAclRole.Persistence.UseCase.Interfaces;

interface

uses
  uAclRole.Filter.DTO,
  uIndexResult,
  uAclRole.Show.DTO,
  uAclRole.Input.DTO,
  uFilter,
  uEither;

type
  IAclRolePersistenceUseCase = Interface
    ['{8EBA44CA-79AE-4903-87FE-0713EF453B39}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilterDTO: TAclRoleFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TAclRoleShowDTO;
    function StoreAndShow(AInput: TAclRoleInputDTO): Either<String, TAclRoleShowDTO>;
    function Store(AInput: TAclRoleInputDTO): Int64;
    function Update(APK: Int64; AInput: TAclRoleInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TAclRoleInputDTO): Either<String, TAclRoleShowDTO>;
  end;


implementation

end.
