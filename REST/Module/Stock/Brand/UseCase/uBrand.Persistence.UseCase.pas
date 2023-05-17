unit uBrand.Persistence.UseCase;

interface

uses
  uBrand.Persistence.UseCase.Interfaces,
  uBrand.Repository.Interfaces,
  uBrand.Input.DTO,
  uBrand.Show.DTO,
  uIndexResult,
  uEither,
  uBrand.Filter.DTO,
  uFilter;

type
  TBrandPersistenceUseCase = class(TInterfacedObject, IBrandPersistenceUseCase)
  private
    FRepository: IBrandRepository;
    constructor Create(ARepository: IBrandRepository);
  public
    class function Make(ARepository: IBrandRepository): IBrandPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TBrandFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TBrandShowDTO;
    function StoreAndShow(AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
    function Store(AInput: TBrandInputDTO): Int64;
    function Update(APK: Int64; AInput: TBrandInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uBrand,
  XSuperObject,
  uBrand.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TBrandPersistenceUseCase }

constructor TBrandPersistenceUseCase.Create(ARepository: IBrandRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TBrandPersistenceUseCase.Show(APK: Int64): TBrandShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LBrandFound: SH<TBrand> = FRepository.Show(APK);
  if not Assigned(LBrandFound.Value) then
    Exit;

  // Retornar DTO
  Result := TBrandMapper.EntityToShow(LBrandFound.Value);
end;

function TBrandPersistenceUseCase.Store(AInput: TBrandInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TBrand> = TBrandMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TBrandPersistenceUseCase.StoreAndShow(AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TBrandPersistenceUseCase.Update(APK: Int64; AInput: TBrandInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LBrandToUpdate: SH<TBrand> = TBrandMapper.InputToEntity(AInput);
  With LBrandToUpdate.Value do
  begin
    id := APK;
    const LErrors = Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LBrandToUpdate);
end;

function TBrandPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TBrandPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TBrandPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TBrandPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TBrandPersistenceUseCase.Index(AFilterDTO: TBrandFilterDTO): IIndexResult;
begin
  const LFilter = TBrandMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TBrandPersistenceUseCase.Make(ARepository: IBrandRepository): IBrandPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
