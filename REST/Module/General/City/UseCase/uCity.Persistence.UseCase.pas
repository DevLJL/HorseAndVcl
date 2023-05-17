unit uCity.Persistence.UseCase;

interface

uses
  uCity.Persistence.UseCase.Interfaces,
  uCity.Repository.Interfaces,
  uCity.Input.DTO,
  uCity.Show.DTO,
  uIndexResult,
  uEither,
  uCity.Filter.DTO,
  uFilter;

type
  TCityPersistenceUseCase = class(TInterfacedObject, ICityPersistenceUseCase)
  private
    FRepository: ICityRepository;
    constructor Create(ARepository: ICityRepository);
  public
    class function Make(ARepository: ICityRepository): ICityPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCityFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCityShowDTO;
    function StoreAndShow(AInput: TCityInputDTO): Either<String, TCityShowDTO>;
    function Store(AInput: TCityInputDTO): Int64;
    function Update(APK: Int64; AInput: TCityInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCityInputDTO): Either<String, TCityShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uCity,
  XSuperObject,
  uCity.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TCityPersistenceUseCase }

constructor TCityPersistenceUseCase.Create(ARepository: ICityRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TCityPersistenceUseCase.Show(APK: Int64): TCityShowDTO;
var
  LCityFound: SH<TCity>;
begin
  Result := Nil;

  // Localizar Registro
  LCityFound := FRepository.Show(APK);
  if not Assigned(LCityFound.Value) then
    Exit;

  // Retornar DTO
  Result := TCityMapper.EntityToShow(LCityFound.Value);
end;

function TCityPersistenceUseCase.Store(AInput: TCityInputDTO): Int64;
var
  LEntity: SH<TCity>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TCityMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TCityPersistenceUseCase.StoreAndShow(AInput: TCityInputDTO): Either<String, TCityShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCityPersistenceUseCase.Update(APK: Int64; AInput: TCityInputDTO): Int64;
var
  LCityToUpdate: SH<TCity>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LCityToUpdate := TCityMapper.InputToEntity(AInput);
  With LCityToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LCityToUpdate);
end;

function TCityPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TCityInputDTO): Either<String, TCityShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCityPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TCityPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TCityPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TCityPersistenceUseCase.Index(AFilterDTO: TCityFilterDTO): IIndexResult;
begin
  const LFilter = TCityMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TCityPersistenceUseCase.Make(ARepository: ICityRepository): ICityPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
