unit uTenant.Service.Interfaces;

interface

uses
  uBase.Service,
  uTenant.Filter.DTO,
  uIndexResult,
  uTenant.Show.DTO,
  uTenant.Input.DTO,
  uEither;

type
  ITenantService = Interface(IBaseService)
    ['{32859457-D89C-4F27-A817-71C682F36C9E}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TTenantFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64 = 1): TTenantShowDTO;
    function StoreAndShow(AInput: TTenantInputDTO): Either<String, TTenantShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TTenantInputDTO): Either<String, TTenantShowDTO>;
  End;

implementation

end.
