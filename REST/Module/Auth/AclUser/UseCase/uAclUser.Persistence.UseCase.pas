unit uAclUser.Persistence.UseCase;

interface

uses
  uAclUser.Persistence.UseCase.Interfaces,
  uAclUser.Repository.Interfaces,
  uAclUser.Input.DTO,
  uAclUser.Show.DTO,
  uIndexResult,
  uEither,
  uAclUser.Filter.DTO,
  uFilter;

type
  TAclUserPersistenceUseCase = class(TInterfacedObject, IAclUserPersistenceUseCase)
  private
    FRepository: IAclUserRepository;
    constructor Create(ARepository: IAclUserRepository);
  public
    class function Make(ARepository: IAclUserRepository): IAclUserPersistenceUseCase;
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

uses
  uSmartPointer,
  uAclUser,
  XSuperObject,
  uAclUser.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TAclUserPersistenceUseCase }

constructor TAclUserPersistenceUseCase.Create(ARepository: IAclUserRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TAclUserPersistenceUseCase.Show(APK: Int64): TAclUserShowDTO;
var
  LAclUserFound: SH<TAclUser>;
begin
  Result := Nil;

  // Localizar Registro
  LAclUserFound := FRepository.Show(APK);
  if not Assigned(LAclUserFound.Value) then
    Exit;

  // Retornar DTO
  Result := TAclUserMapper.EntityToShow(LAclUserFound.Value);
end;

function TAclUserPersistenceUseCase.Store(AInput: TAclUserInputDTO): Int64;
var
  LEntity: SH<TAclUser>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TAclUserMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TAclUserPersistenceUseCase.StoreAndShow(AInput: TAclUserInputDTO): Either<String, TAclUserShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TAclUserPersistenceUseCase.Update(APK: Int64; AInput: TAclUserInputDTO): Int64;
var
  LAclUserToUpdate: SH<TAclUser>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LAclUserToUpdate := TAclUserMapper.InputToEntity(AInput);
  With LAclUserToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LAclUserToUpdate);
end;

function TAclUserPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TAclUserInputDTO): Either<String, TAclUserShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TAclUserPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TAclUserPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TAclUserPersistenceUseCase.Index(AFilterDTO: TAclUserFilterDTO): IIndexResult;
begin
  const LFilter = TAclUserMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TAclUserPersistenceUseCase.Make(ARepository: IAclUserRepository): IAclUserPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
