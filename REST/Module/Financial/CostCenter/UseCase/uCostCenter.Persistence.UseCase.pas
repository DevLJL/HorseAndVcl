unit uCostCenter.Persistence.UseCase;

interface

uses
  uCostCenter.Persistence.UseCase.Interfaces,
  uCostCenter.Repository.Interfaces,
  uCostCenter.Input.DTO,
  uCostCenter.Show.DTO,
  uIndexResult,
  uEither,
  uCostCenter.Filter.DTO,
  uFilter;

type
  TCostCenterPersistenceUseCase = class(TInterfacedObject, ICostCenterPersistenceUseCase)
  private
    FRepository: ICostCenterRepository;
    constructor Create(ARepository: ICostCenterRepository);
  public
    class function Make(ARepository: ICostCenterRepository): ICostCenterPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCostCenterFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCostCenterShowDTO;
    function StoreAndShow(AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
    function Store(AInput: TCostCenterInputDTO): Int64;
    function Update(APK: Int64; AInput: TCostCenterInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uCostCenter,
  XSuperObject,
  uCostCenter.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TCostCenterPersistenceUseCase }

constructor TCostCenterPersistenceUseCase.Create(ARepository: ICostCenterRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TCostCenterPersistenceUseCase.Show(APK: Int64): TCostCenterShowDTO;
var
  LCostCenterFound: SH<TCostCenter>;
begin
  Result := Nil;

  // Localizar Registro
  LCostCenterFound := FRepository.Show(APK);
  if not Assigned(LCostCenterFound.Value) then
    Exit;

  // Retornar DTO
  Result := TCostCenterMapper.EntityToShow(LCostCenterFound.Value);
end;

function TCostCenterPersistenceUseCase.Store(AInput: TCostCenterInputDTO): Int64;
var
  LEntity: SH<TCostCenter>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TCostCenterMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TCostCenterPersistenceUseCase.StoreAndShow(AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCostCenterPersistenceUseCase.Update(APK: Int64; AInput: TCostCenterInputDTO): Int64;
var
  LCostCenterToUpdate: SH<TCostCenter>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LCostCenterToUpdate := TCostCenterMapper.InputToEntity(AInput);
  With LCostCenterToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LCostCenterToUpdate);
end;

function TCostCenterPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCostCenterPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TCostCenterPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TCostCenterPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TCostCenterPersistenceUseCase.Index(AFilterDTO: TCostCenterFilterDTO): IIndexResult;
begin
  const LFilter = TCostCenterMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TCostCenterPersistenceUseCase.Make(ARepository: ICostCenterRepository): ICostCenterPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
