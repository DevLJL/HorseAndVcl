unit uCategory.Persistence.UseCase;

interface

uses
  uCategory.Persistence.UseCase.Interfaces,
  uCategory.Repository.Interfaces,
  uCategory.Input.DTO,
  uCategory.Show.DTO,
  uIndexResult,
  uEither,
  uCategory.Filter.DTO,
  uFilter;

type
  TCategoryPersistenceUseCase = class(TInterfacedObject, ICategoryPersistenceUseCase)
  private
    FRepository: ICategoryRepository;
    constructor Create(ARepository: ICategoryRepository);
  public
    class function Make(ARepository: ICategoryRepository): ICategoryPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCategoryFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCategoryShowDTO;
    function StoreAndShow(AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
    function Store(AInput: TCategoryInputDTO): Int64;
    function Update(APK: Int64; AInput: TCategoryInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uCategory,
  XSuperObject,
  uCategory.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TCategoryPersistenceUseCase }

constructor TCategoryPersistenceUseCase.Create(ARepository: ICategoryRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TCategoryPersistenceUseCase.Show(APK: Int64): TCategoryShowDTO;
var
  LCategoryFound: SH<TCategory>;
begin
  Result := Nil;

  // Localizar Registro
  LCategoryFound := FRepository.Show(APK);
  if not Assigned(LCategoryFound.Value) then
    Exit;

  // Retornar DTO
  Result := TCategoryMapper.EntityToShow(LCategoryFound.Value);
end;

function TCategoryPersistenceUseCase.Store(AInput: TCategoryInputDTO): Int64;
var
  LEntity: SH<TCategory>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TCategoryMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TCategoryPersistenceUseCase.StoreAndShow(AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCategoryPersistenceUseCase.Update(APK: Int64; AInput: TCategoryInputDTO): Int64;
var
  LCategoryToUpdate: SH<TCategory>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LCategoryToUpdate := TCategoryMapper.InputToEntity(AInput);
  With LCategoryToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LCategoryToUpdate);
end;

function TCategoryPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCategoryPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TCategoryPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TCategoryPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TCategoryPersistenceUseCase.Index(AFilterDTO: TCategoryFilterDTO): IIndexResult;
begin
  const LFilter = TCategoryMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TCategoryPersistenceUseCase.Make(ARepository: ICategoryRepository): ICategoryPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
