unit uUnit.Persistence.UseCase;

interface

uses
  uUnit.Persistence.UseCase.Interfaces,
  uUnit.Repository.Interfaces,
  uUnit.Input.DTO,
  uUnit.Show.DTO,
  uIndexResult,
  uEither,
  uUnit.Filter.DTO,
  uFilter;

type
  TUnitPersistenceUseCase = class(TInterfacedObject, IUnitPersistenceUseCase)
  private
    FRepository: IUnitRepository;
    constructor Create(ARepository: IUnitRepository);
  public
    class function Make(ARepository: IUnitRepository): IUnitPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TUnitFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TUnitShowDTO;
    function StoreAndShow(AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
    function Store(AInput: TUnitInputDTO): Int64;
    function Update(APK: Int64; AInput: TUnitInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uUnit,
  XSuperObject,
  uUnit.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TUnitPersistenceUseCase }

constructor TUnitPersistenceUseCase.Create(ARepository: IUnitRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TUnitPersistenceUseCase.Show(APK: Int64): TUnitShowDTO;
var
  LUnitFound: SH<TUnit>;
begin
  Result := Nil;

  // Localizar Registro
  LUnitFound := FRepository.Show(APK);
  if not Assigned(LUnitFound.Value) then
    Exit;

  // Retornar DTO
  Result := TUnitMapper.EntityToShow(LUnitFound.Value);
end;

function TUnitPersistenceUseCase.Store(AInput: TUnitInputDTO): Int64;
var
  LEntity: SH<TUnit>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TUnitMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TUnitPersistenceUseCase.StoreAndShow(AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TUnitPersistenceUseCase.Update(APK: Int64; AInput: TUnitInputDTO): Int64;
var
  LUnitToUpdate: SH<TUnit>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LUnitToUpdate := TUnitMapper.InputToEntity(AInput);
  With LUnitToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LUnitToUpdate);
end;

function TUnitPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TUnitPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TUnitPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TUnitPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TUnitPersistenceUseCase.Index(AFilterDTO: TUnitFilterDTO): IIndexResult;
begin
  const LFilter = TUnitMapper.FilterToEntity(AFilterDTO);
  Result := Self.Index(LFilter);
end;

class function TUnitPersistenceUseCase.Make(ARepository: IUnitRepository): IUnitPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
