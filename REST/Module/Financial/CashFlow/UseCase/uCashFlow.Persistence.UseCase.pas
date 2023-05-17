unit uCashFlow.Persistence.UseCase;

interface

uses
  uCashFlow.Persistence.UseCase.Interfaces,
  uCashFlow.Repository.Interfaces,
  uCashFlow.Input.DTO,
  uCashFlow.Show.DTO,
  uIndexResult,
  uEither,
  uCashFlow.Filter.DTO,
  uFilter;

type
  TCashFlowPersistenceUseCase = class(TInterfacedObject, ICashFlowPersistenceUseCase)
  private
    FRepository: ICashFlowRepository;
    constructor Create(ARepository: ICashFlowRepository);
  public
    class function Make(ARepository: ICashFlowRepository): ICashFlowPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCashFlowFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCashFlowShowDTO;
    function StoreAndShow(AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
    function Store(AInput: TCashFlowInputDTO): Int64;
    function Update(APK: Int64; AInput: TCashFlowInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uCashFlow,
  XSuperObject,
  uCashFlow.Mapper,
  System.SysUtils,
  uApplication.Exception,
  uAppRest.Types;

{ TCashFlowPersistenceUseCase }

constructor TCashFlowPersistenceUseCase.Create(ARepository: ICashFlowRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TCashFlowPersistenceUseCase.Show(APK: Int64): TCashFlowShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LCashFlowFound: SH<TCashFlow> = FRepository.Show(APK);
  if not Assigned(LCashFlowFound.Value) then
    Exit;

  // Retornar DTO
  Result := TCashFlowMapper.EntityToShow(LCashFlowFound.Value);
end;

function TCashFlowPersistenceUseCase.Store(AInput: TCashFlowInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TCashFlow> = TCashFlowMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TCashFlowPersistenceUseCase.StoreAndShow(AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCashFlowPersistenceUseCase.Update(APK: Int64; AInput: TCashFlowInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LCashFlowToUpdate: SH<TCashFlow> = TCashFlowMapper.InputToEntity(AInput);
  With LCashFlowToUpdate.Value do
  begin
    id := APK;
    const LErrors = Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LCashFlowToUpdate);
end;

function TCashFlowPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCashFlowPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TCashFlowPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TCashFlowPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TCashFlowPersistenceUseCase.Index(AFilterDTO: TCashFlowFilterDTO): IIndexResult;
begin
  const LFilter = TCashFlowMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TCashFlowPersistenceUseCase.Make(ARepository: ICashFlowRepository): ICashFlowPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
