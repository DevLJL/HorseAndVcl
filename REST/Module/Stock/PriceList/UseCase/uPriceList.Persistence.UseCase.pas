unit uPriceList.Persistence.UseCase;

interface

uses
  uPriceList.Persistence.UseCase.Interfaces,
  uPriceList.Repository.Interfaces,
  uPriceList.Input.DTO,
  uPriceList.Show.DTO,
  uIndexResult,
  uEither,
  uPriceList.Filter.DTO,
  uFilter;

type
  TPriceListPersistenceUseCase = class(TInterfacedObject, IPriceListPersistenceUseCase)
  private
    FRepository: IPriceListRepository;
    constructor Create(ARepository: IPriceListRepository);
  public
    class function Make(ARepository: IPriceListRepository): IPriceListPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TPriceListFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TPriceListShowDTO;
    function StoreAndShow(AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
    function Store(AInput: TPriceListInputDTO): Int64;
    function Update(APK: Int64; AInput: TPriceListInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uPriceList,
  XSuperObject,
  uPriceList.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TPriceListPersistenceUseCase }

constructor TPriceListPersistenceUseCase.Create(ARepository: IPriceListRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TPriceListPersistenceUseCase.Show(APK: Int64): TPriceListShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LPriceListFound: SH<TPriceList> = FRepository.Show(APK);
  if not Assigned(LPriceListFound.Value) then
    Exit;

  // Retornar DTO
  Result := TPriceListMapper.EntityToShow(LPriceListFound.Value);
end;

function TPriceListPersistenceUseCase.Store(AInput: TPriceListInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TPriceList> = TPriceListMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TPriceListPersistenceUseCase.StoreAndShow(AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TPriceListPersistenceUseCase.Update(APK: Int64; AInput: TPriceListInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LPriceListToUpdate: SH<TPriceList> = TPriceListMapper.InputToEntity(AInput);
  With LPriceListToUpdate.Value do
  begin
    id := APK;
    const LErrors = Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LPriceListToUpdate);
end;

function TPriceListPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TPriceListPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TPriceListPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TPriceListPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TPriceListPersistenceUseCase.Index(AFilterDTO: TPriceListFilterDTO): IIndexResult;
begin
  const LFilter = TPriceListMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TPriceListPersistenceUseCase.Make(ARepository: IPriceListRepository): IPriceListPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
