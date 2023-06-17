unit uPosPrinter.Persistence.UseCase;

interface

uses
  uPosPrinter.Persistence.UseCase.Interfaces,
  uPosPrinter.Repository.Interfaces,
  uPosPrinter.Input.DTO,
  uPosPrinter.Show.DTO,
  uIndexResult,
  uEither,
  uPosPrinter.Filter.DTO,
  uFilter;

type
  TPosPrinterPersistenceUseCase = class(TInterfacedObject, IPosPrinterPersistenceUseCase)
  private
    FRepository: IPosPrinterRepository;
    constructor Create(ARepository: IPosPrinterRepository);
  public
    class function Make(ARepository: IPosPrinterRepository): IPosPrinterPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TPosPrinterFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TPosPrinterShowDTO;
    function StoreAndShow(AInput: TPosPrinterInputDTO): Either<String, TPosPrinterShowDTO>;
    function Store(AInput: TPosPrinterInputDTO): Int64;
    function Update(APK: Int64; AInput: TPosPrinterInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TPosPrinterInputDTO): Either<String, TPosPrinterShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uPosPrinter,
  XSuperObject,
  uPosPrinter.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TPosPrinterPersistenceUseCase }

constructor TPosPrinterPersistenceUseCase.Create(ARepository: IPosPrinterRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TPosPrinterPersistenceUseCase.Show(APK: Int64): TPosPrinterShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LPosPrinterFound: SH<TPosPrinter> = FRepository.Show(APK);
  if not Assigned(LPosPrinterFound.Value) then
    Exit;

  // Retornar DTO
  Result := TPosPrinterMapper.EntityToShow(LPosPrinterFound.Value);
end;

function TPosPrinterPersistenceUseCase.Store(AInput: TPosPrinterInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TPosPrinter> = TPosPrinterMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TPosPrinterPersistenceUseCase.StoreAndShow(AInput: TPosPrinterInputDTO): Either<String, TPosPrinterShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TPosPrinterPersistenceUseCase.Update(APK: Int64; AInput: TPosPrinterInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LPosPrinterToUpdate: SH<TPosPrinter> = TPosPrinterMapper.InputToEntity(AInput);
  With LPosPrinterToUpdate.Value do
  begin
    id := APK;
    const LErrors = Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LPosPrinterToUpdate);
end;

function TPosPrinterPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TPosPrinterInputDTO): Either<String, TPosPrinterShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TPosPrinterPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TPosPrinterPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TPosPrinterPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TPosPrinterPersistenceUseCase.Index(AFilterDTO: TPosPrinterFilterDTO): IIndexResult;
begin
  const LFilter = TPosPrinterMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TPosPrinterPersistenceUseCase.Make(ARepository: IPosPrinterRepository): IPosPrinterPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
