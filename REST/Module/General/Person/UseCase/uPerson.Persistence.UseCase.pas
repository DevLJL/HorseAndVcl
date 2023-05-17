unit uPerson.Persistence.UseCase;

interface

uses
  uPerson.Persistence.UseCase.Interfaces,
  uPerson.Repository.Interfaces,
  uPerson.Input.DTO,
  uPerson.Show.DTO,
  uIndexResult,
  uEither,
  uPerson.Filter.DTO,
  uFilter;

type
  TPersonPersistenceUseCase = class(TInterfacedObject, IPersonPersistenceUseCase)
  private
    FRepository: IPersonRepository;
    constructor Create(ARepository: IPersonRepository);
  public
    class function Make(ARepository: IPersonRepository): IPersonPersistenceUseCase;
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

uses
  uSmartPointer,
  uPerson,
  XSuperObject,
  uPerson.Mapper,
  System.SysUtils,
  uApplication.Exception,
  uAppRest.Types;

{ TPersonPersistenceUseCase }

constructor TPersonPersistenceUseCase.Create(ARepository: IPersonRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TPersonPersistenceUseCase.Show(APK: Int64): TPersonShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LPersonFound: SH<TPerson> = FRepository.Show(APK);
  if not Assigned(LPersonFound.Value) then
    Exit;

  // Retornar DTO
  Result := TPersonMapper.EntityToShow(LPersonFound.Value);
end;

function TPersonPersistenceUseCase.Store(AInput: TPersonInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TPerson> = TPersonMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.BeforeSaveAndValidate(TEntityState.Store);
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TPersonPersistenceUseCase.StoreAndShow(AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TPersonPersistenceUseCase.Update(APK: Int64; AInput: TPersonInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LPersonToUpdate: SH<TPerson> = TPersonMapper.InputToEntity(AInput);
  With LPersonToUpdate.Value do
  begin
    id := APK;
    const LErrors = BeforeSaveAndValidate(TEntityState.Update);
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LPersonToUpdate);
end;

function TPersonPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TPersonPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TPersonPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TPersonPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TPersonPersistenceUseCase.Index(AFilterDTO: TPersonFilterDTO): IIndexResult;
begin
  const LFilter = TPersonMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TPersonPersistenceUseCase.Make(ARepository: IPersonRepository): IPersonPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
