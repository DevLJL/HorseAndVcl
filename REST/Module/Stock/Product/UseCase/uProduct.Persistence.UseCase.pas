unit uProduct.Persistence.UseCase;

interface

uses
  uProduct.Persistence.UseCase.Interfaces,
  uProduct.Repository.Interfaces,
  uProduct.Input.DTO,
  uProduct.Show.DTO,
  uIndexResult,
  uEither,
  uProduct.Filter.DTO,
  uFilter;

type
  TProductPersistenceUseCase = class(TInterfacedObject, IProductPersistenceUseCase)
  private
    FRepository: IProductRepository;
    constructor Create(ARepository: IProductRepository);
  public
    class function Make(ARepository: IProductRepository): IProductPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TProductFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TProductShowDTO;
    function StoreAndShow(AInput: TProductInputDTO): Either<String, TProductShowDTO>;
    function Store(AInput: TProductInputDTO): Int64;
    function Update(APK: Int64; AInput: TProductInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TProductInputDTO): Either<String, TProductShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uProduct,
  XSuperObject,
  uProduct.Mapper,
  System.SysUtils,
  uApplication.Exception,
  uAppRest.Types;

{ TProductPersistenceUseCase }

constructor TProductPersistenceUseCase.Create(ARepository: IProductRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TProductPersistenceUseCase.Show(APK: Int64): TProductShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LProductFound: SH<TProduct> = FRepository.Show(APK);
  if not Assigned(LProductFound.Value) then
    Exit;

  // Retornar DTO
  Result := TProductMapper.EntityToShow(LProductFound.Value);
end;

function TProductPersistenceUseCase.Store(AInput: TProductInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TProduct> = TProductMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.BeforeSaveAndValidate(TEntityState.Store);
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TProductPersistenceUseCase.StoreAndShow(AInput: TProductInputDTO): Either<String, TProductShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TProductPersistenceUseCase.Update(APK: Int64; AInput: TProductInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LProductToUpdate: SH<TProduct> = TProductMapper.InputToEntity(AInput);
  With LProductToUpdate.Value do
  begin
    id := APK;
    const LErrors = BeforeSaveAndValidate(TEntityState.Update);
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LProductToUpdate);
end;

function TProductPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TProductInputDTO): Either<String, TProductShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TProductPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TProductPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TProductPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TProductPersistenceUseCase.Index(AFilterDTO: TProductFilterDTO): IIndexResult;
begin
  const LFilter = TProductMapper.FilterToEntity(AFilterDTO);
  Result := Self.Index(LFilter);
end;

class function TProductPersistenceUseCase.Make(ARepository: IProductRepository): IProductPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
