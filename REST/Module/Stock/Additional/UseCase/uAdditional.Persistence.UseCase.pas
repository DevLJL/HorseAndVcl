unit uAdditional.Persistence.UseCase;

interface

uses
  uAdditional.Persistence.UseCase.Interfaces,
  uAdditional.Repository.Interfaces,
  uAdditional.Input.DTO,
  uAdditional.Show.DTO,
  uIndexResult,
  uEither,
  uAdditional.Filter.DTO,
  uFilter;

type
  TAdditionalPersistenceUseCase = class(TInterfacedObject, IAdditionalPersistenceUseCase)
  private
    FRepository: IAdditionalRepository;
    constructor Create(ARepository: IAdditionalRepository);
  public
    class function Make(ARepository: IAdditionalRepository): IAdditionalPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TAdditionalFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TAdditionalShowDTO;
    function StoreAndShow(AInput: TAdditionalInputDTO): Either<String, TAdditionalShowDTO>;
    function Store(AInput: TAdditionalInputDTO): Int64;
    function Update(APK: Int64; AInput: TAdditionalInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TAdditionalInputDTO): Either<String, TAdditionalShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uAdditional,
  XSuperObject,
  uAdditional.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TAdditionalPersistenceUseCase }

constructor TAdditionalPersistenceUseCase.Create(ARepository: IAdditionalRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TAdditionalPersistenceUseCase.Show(APK: Int64): TAdditionalShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LAdditionalFound: SH<TAdditional> = FRepository.Show(APK);
  if not Assigned(LAdditionalFound.Value) then
    Exit;

  // Retornar DTO
  Result := TAdditionalMapper.EntityToShow(LAdditionalFound.Value);
end;

function TAdditionalPersistenceUseCase.Store(AInput: TAdditionalInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TAdditional> = TAdditionalMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TAdditionalPersistenceUseCase.StoreAndShow(AInput: TAdditionalInputDTO): Either<String, TAdditionalShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TAdditionalPersistenceUseCase.Update(APK: Int64; AInput: TAdditionalInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LAdditionalToUpdate: SH<TAdditional> = TAdditionalMapper.InputToEntity(AInput);
  With LAdditionalToUpdate.Value do
  begin
    id := APK;
    const LErrors = Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LAdditionalToUpdate);
end;

function TAdditionalPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TAdditionalInputDTO): Either<String, TAdditionalShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TAdditionalPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TAdditionalPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TAdditionalPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TAdditionalPersistenceUseCase.Index(AFilterDTO: TAdditionalFilterDTO): IIndexResult;
begin
  const LFilter = TAdditionalMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TAdditionalPersistenceUseCase.Make(ARepository: IAdditionalRepository): IAdditionalPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
