unit uStorageLocation.Persistence.UseCase;

interface

uses
  uStorageLocation.Persistence.UseCase.Interfaces,
  uStorageLocation.Repository.Interfaces,
  uStorageLocation.Input.DTO,
  uStorageLocation.Show.DTO,
  uIndexResult,
  uEither,
  uStorageLocation.Filter.DTO,
  uFilter;

type
  TStorageLocationPersistenceUseCase = class(TInterfacedObject, IStorageLocationPersistenceUseCase)
  private
    FRepository: IStorageLocationRepository;
    constructor Create(ARepository: IStorageLocationRepository);
  public
    class function Make(ARepository: IStorageLocationRepository): IStorageLocationPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TStorageLocationFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TStorageLocationShowDTO;
    function StoreAndShow(AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
    function Store(AInput: TStorageLocationInputDTO): Int64;
    function Update(APK: Int64; AInput: TStorageLocationInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uStorageLocation,
  XSuperObject,
  uStorageLocation.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TStorageLocationPersistenceUseCase }

constructor TStorageLocationPersistenceUseCase.Create(ARepository: IStorageLocationRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TStorageLocationPersistenceUseCase.Show(APK: Int64): TStorageLocationShowDTO;
var
  LStorageLocationFound: SH<TStorageLocation>;
begin
  Result := Nil;

  // Localizar Registro
  LStorageLocationFound := FRepository.Show(APK);
  if not Assigned(LStorageLocationFound.Value) then
    Exit;

  // Retornar DTO
  Result := TStorageLocationMapper.EntityToShow(LStorageLocationFound.Value);
end;

function TStorageLocationPersistenceUseCase.Store(AInput: TStorageLocationInputDTO): Int64;
var
  LEntity: SH<TStorageLocation>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TStorageLocationMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TStorageLocationPersistenceUseCase.StoreAndShow(AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TStorageLocationPersistenceUseCase.Update(APK: Int64; AInput: TStorageLocationInputDTO): Int64;
var
  LStorageLocationToUpdate: SH<TStorageLocation>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LStorageLocationToUpdate := TStorageLocationMapper.InputToEntity(AInput);
  With LStorageLocationToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LStorageLocationToUpdate);
end;

function TStorageLocationPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TStorageLocationPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TStorageLocationPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TStorageLocationPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TStorageLocationPersistenceUseCase.Index(AFilterDTO: TStorageLocationFilterDTO): IIndexResult;
begin
  const LFilter = TStorageLocationMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TStorageLocationPersistenceUseCase.Make(ARepository: IStorageLocationRepository): IStorageLocationPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
