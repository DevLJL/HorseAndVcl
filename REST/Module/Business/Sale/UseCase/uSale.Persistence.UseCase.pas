unit uSale.Persistence.UseCase;

interface

uses
  uSale.Persistence.UseCase.Interfaces,
  uSale.Repository.Interfaces,
  uSale.Input.DTO,
  uSale.Show.DTO,
  uIndexResult,
  uEither,
  uSale.Filter.DTO,
  uFilter;

type
  TSalePersistenceUseCase = class(TInterfacedObject, ISalePersistenceUseCase)
  private
    FRepository: ISaleRepository;
    constructor Create(ARepository: ISaleRepository);
  public
    class function Make(ARepository: ISaleRepository): ISalePersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TSaleFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TSaleShowDTO;
    function StoreAndShow(AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
    function Store(AInput: TSaleInputDTO): Int64;
    function Update(APK: Int64; AInput: TSaleInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uSale,
  XSuperObject,
  uSale.Mapper,
  System.SysUtils,
  uApplication.Exception,
  uAppRest.Types;

{ TSalePersistenceUseCase }

constructor TSalePersistenceUseCase.Create(ARepository: ISaleRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TSalePersistenceUseCase.Show(APK: Int64): TSaleShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LSaleFound: SH<TSale> = FRepository.Show(APK);
  if not Assigned(LSaleFound.Value) then
    Exit;

  // Retornar DTO
  Result := TSaleMapper.EntityToShow(LSaleFound.Value);
end;

function TSalePersistenceUseCase.Store(AInput: TSaleInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TSale> = TSaleMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.BeforeSaveAndValidate(TEntityState.Store);
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TSalePersistenceUseCase.StoreAndShow(AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TSalePersistenceUseCase.Update(APK: Int64; AInput: TSaleInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LSaleToUpdate: SH<TSale> = TSaleMapper.InputToEntity(AInput);
  With LSaleToUpdate.Value do
  begin
    id := APK;
    const LErrors = BeforeSaveAndValidate(TEntityState.Update);
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LSaleToUpdate);
end;

function TSalePersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TSalePersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TSalePersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TSalePersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TSalePersistenceUseCase.Index(AFilterDTO: TSaleFilterDTO): IIndexResult;
begin
  const LFilter = TSaleMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TSalePersistenceUseCase.Make(ARepository: ISaleRepository): ISalePersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
