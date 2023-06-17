unit uTenant.Persistence.UseCase;

interface

uses
  uTenant.Persistence.UseCase.Interfaces,
  uTenant.Repository.Interfaces,
  uTenant.Input.DTO,
  uTenant.Show.DTO,
  uIndexResult,
  uEither,
  uTenant.Filter.DTO,
  uFilter;

type
  TTenantPersistenceUseCase = class(TInterfacedObject, ITenantPersistenceUseCase)
  private
    FRepository: ITenantRepository;
    constructor Create(ARepository: ITenantRepository);
  public
    class function Make(ARepository: ITenantRepository): ITenantPersistenceUseCase;
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

uses
  uSmartPointer,
  uTenant,
  XSuperObject,
  uTenant.Mapper,
  System.SysUtils,
  uApplication.Exception,
  uAppRest.Types;

{ TTenantPersistenceUseCase }

constructor TTenantPersistenceUseCase.Create(ARepository: ITenantRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TTenantPersistenceUseCase.Show(APK: Int64): TTenantShowDTO;
var
  LTenantFound: SH<TTenant>;
begin
  Result := Nil;

  // Localizar Registro
  LTenantFound := FRepository.Show(APK);
  if not Assigned(LTenantFound.Value) then
    Exit;

  // Retornar DTO
  Result := TTenantMapper.EntityToShow(LTenantFound.Value);
end;

function TTenantPersistenceUseCase.Store(AInput: TTenantInputDTO): Int64;
var
  LEntity: SH<TTenant>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TTenantMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.BeforeSaveAndValidate(TEntityState.Store);
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TTenantPersistenceUseCase.StoreAndShow(AInput: TTenantInputDTO): Either<String, TTenantShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TTenantPersistenceUseCase.Update(APK: Int64; AInput: TTenantInputDTO): Int64;
var
  LTenantToUpdate: SH<TTenant>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LTenantToUpdate := TTenantMapper.InputToEntity(AInput);
  With LTenantToUpdate.Value do
  begin
    id      := APK;
    LErrors := BeforeSaveAndValidate(TEntityState.Update);
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LTenantToUpdate);
end;

function TTenantPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TTenantInputDTO): Either<String, TTenantShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TTenantPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TTenantPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TTenantPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TTenantPersistenceUseCase.Index(AFilterDTO: TTenantFilterDTO): IIndexResult;
begin
  const LFilter = TTenantMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TTenantPersistenceUseCase.Make(ARepository: ITenantRepository): ITenantPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
