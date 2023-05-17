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
    ['{EEF01028-D576-4DBD-8354-FF56CB7B78AA}']
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
