unit uQueueEmail.Persistence.UseCase;

interface

uses
  uQueueEmail.Persistence.UseCase.Interfaces,
  uQueueEmail.Repository.Interfaces,
  uQueueEmail.Input.DTO,
  uQueueEmail.Show.DTO,
  uIndexResult,
  uEither,
  uQueueEmail.Filter.DTO,
  uFilter;

type
  TQueueEmailPersistenceUseCase = class(TInterfacedObject, IQueueEmailPersistenceUseCase)
  private
    FRepository: IQueueEmailRepository;
    constructor Create(ARepository: IQueueEmailRepository);
  public
    class function Make(ARepository: IQueueEmailRepository): IQueueEmailPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TQueueEmailFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TQueueEmailShowDTO;
    function StoreAndShow(AInput: TQueueEmailInputDTO): Either<String, TQueueEmailShowDTO>;
    function Store(AInput: TQueueEmailInputDTO): Int64;
    function Update(APK: Int64; AInput: TQueueEmailInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TQueueEmailInputDTO): Either<String, TQueueEmailShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uQueueEmail,
  XSuperObject,
  uQueueEmail.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TQueueEmailPersistenceUseCase }

constructor TQueueEmailPersistenceUseCase.Create(ARepository: IQueueEmailRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TQueueEmailPersistenceUseCase.Show(APK: Int64): TQueueEmailShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LQueueEmailFound: SH<TQueueEmail> = FRepository.Show(APK);
  if not Assigned(LQueueEmailFound.Value) then
    Exit;

  // Retornar DTO
  Result := TQueueEmailMapper.EntityToShow(LQueueEmailFound.Value);
end;

function TQueueEmailPersistenceUseCase.Store(AInput: TQueueEmailInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TQueueEmail> = TQueueEmailMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TQueueEmailPersistenceUseCase.StoreAndShow(AInput: TQueueEmailInputDTO): Either<String, TQueueEmailShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TQueueEmailPersistenceUseCase.Update(APK: Int64; AInput: TQueueEmailInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LQueueEmailToUpdate: SH<TQueueEmail> = TQueueEmailMapper.InputToEntity(AInput);
  With LQueueEmailToUpdate.Value do
  begin
    id := APK;
    const LErrors = Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LQueueEmailToUpdate);
end;

function TQueueEmailPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TQueueEmailInputDTO): Either<String, TQueueEmailShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TQueueEmailPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TQueueEmailPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TQueueEmailPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TQueueEmailPersistenceUseCase.Index(AFilterDTO: TQueueEmailFilterDTO): IIndexResult;
begin
  const LFilter = TQueueEmailMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TQueueEmailPersistenceUseCase.Make(ARepository: IQueueEmailRepository): IQueueEmailPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
