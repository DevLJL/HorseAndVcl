unit uSize.Persistence.UseCase;

interface

uses
  uSize.Persistence.UseCase.Interfaces,
  uSize.Repository.Interfaces,
  uSize.Input.DTO,
  uSize.Show.DTO,
  uIndexResult,
  uEither,
  uSize.Filter.DTO,
  uFilter;

type
  TSizePersistenceUseCase = class(TInterfacedObject, ISizePersistenceUseCase)
  private
    FRepository: ISizeRepository;
    constructor Create(ARepository: ISizeRepository);
  public
    class function Make(ARepository: ISizeRepository): ISizePersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TSizeFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TSizeShowDTO;
    function StoreAndShow(AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
    function Store(AInput: TSizeInputDTO): Int64;
    function Update(APK: Int64; AInput: TSizeInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uSize,
  XSuperObject,
  uSize.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TSizePersistenceUseCase }

constructor TSizePersistenceUseCase.Create(ARepository: ISizeRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TSizePersistenceUseCase.Show(APK: Int64): TSizeShowDTO;
var
  LSizeFound: SH<TSize>;
begin
  Result := Nil;

  // Localizar Registro
  LSizeFound := FRepository.Show(APK);
  if not Assigned(LSizeFound.Value) then
    Exit;

  // Retornar DTO
  Result := TSizeMapper.EntityToShow(LSizeFound.Value);
end;

function TSizePersistenceUseCase.Store(AInput: TSizeInputDTO): Int64;
var
  LEntity: SH<TSize>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TSizeMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TSizePersistenceUseCase.StoreAndShow(AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TSizePersistenceUseCase.Update(APK: Int64; AInput: TSizeInputDTO): Int64;
var
  LSizeToUpdate: SH<TSize>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LSizeToUpdate := TSizeMapper.InputToEntity(AInput);
  With LSizeToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LSizeToUpdate);
end;

function TSizePersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TSizePersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TSizePersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TSizePersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TSizePersistenceUseCase.Index(AFilterDTO: TSizeFilterDTO): IIndexResult;
begin
  const LFilter = TSizeMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TSizePersistenceUseCase.Make(ARepository: ISizeRepository): ISizePersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
