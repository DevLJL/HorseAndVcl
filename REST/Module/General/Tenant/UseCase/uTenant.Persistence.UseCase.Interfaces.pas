unit uTenant.Persistence.UseCase.Interfaces;

interface

uses
  uTenant.Filter.DTO,
  uIndexResult,
  uTenant.Show.DTO,
  uTenant.Input.DTO,
  uFilter,
  uEither;

type
  ITenantPersistenceUseCase = Interface
    ['{59BDAC25-861F-450D-9AE3-7A409A1BB9B0}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TTenantFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TTenantShowDTO;
    function StoreAndShow(AInput: TTenantInputDTO): Either<String, TTenantShowDTO>;
    function Store(AInput: TTenantInputDTO): Int64;
    function Update(APK: Int64; AInput: TTenantInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TTenantInputDTO): Either<String, TTenantShowDTO>;
  end;


implementation

end.
