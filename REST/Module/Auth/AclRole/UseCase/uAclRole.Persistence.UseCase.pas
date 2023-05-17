unit uAclRole.Persistence.UseCase;

interface

uses
  uAclRole.Persistence.UseCase.Interfaces,
  uAclRole.Repository.Interfaces,
  uAclRole.Input.DTO,
  uAclRole.Show.DTO,
  uIndexResult,
  uEither,
  uAclRole.Filter.DTO,
  uFilter;

type
  TAclRolePersistenceUseCase = class(TInterfacedObject, IAclRolePersistenceUseCase)
  private
    FRepository: IAclRoleRepository;
    constructor Create(ARepository: IAclRoleRepository);
  public
    class function Make(ARepository: IAclRoleRepository): IAclRolePersistenceUseCase;
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

uses
  uSmartPointer,
  uAclRole,
  XSuperObject,
  uAclRole.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TAclRolePersistenceUseCase }

constructor TAclRolePersistenceUseCase.Create(ARepository: IAclRoleRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TAclRolePersistenceUseCase.Show(APK: Int64): TAclRoleShowDTO;
var
  LAclRoleFound: SH<TAclRole>;
begin
  Result := Nil;

  // Localizar Registro
  LAclRoleFound := FRepository.Show(APK);
  if not Assigned(LAclRoleFound.Value) then
    Exit;

  // Retornar DTO
  Result := TAclRoleMapper.EntityToShow(LAclRoleFound.Value);
end;

function TAclRolePersistenceUseCase.Store(AInput: TAclRoleInputDTO): Int64;
var
  LEntity: SH<TAclRole>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TAclRoleMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TAclRolePersistenceUseCase.StoreAndShow(AInput: TAclRoleInputDTO): Either<String, TAclRoleShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TAclRolePersistenceUseCase.Update(APK: Int64; AInput: TAclRoleInputDTO): Int64;
var
  LAclRoleToUpdate: SH<TAclRole>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LAclRoleToUpdate := TAclRoleMapper.InputToEntity(AInput);
  With LAclRoleToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LAclRoleToUpdate);
end;

function TAclRolePersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TAclRoleInputDTO): Either<String, TAclRoleShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TAclRolePersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TAclRolePersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TAclRolePersistenceUseCase.Index(AFilterDTO: TAclRoleFilterDTO): IIndexResult;
begin
  const LFilter = TAclRoleMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TAclRolePersistenceUseCase.Make(ARepository: IAclRoleRepository): IAclRolePersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
