
unit uConsumption.Persistence.UseCase;

interface

uses
  uConsumption.Persistence.UseCase.Interfaces,
  uConsumption.Repository.Interfaces,
  uConsumption.Input.DTO,
  uConsumption.Show.DTO,
  uIndexResult,
  uEither,
  uConsumption.Filter.DTO,
  uFilter,
  uConsumptionSale.Filter.DTO,
  uZLMemTable.Interfaces;

type
  TConsumptionPersistenceUseCase = class(TInterfacedObject, IConsumptionPersistenceUseCase)
  private
    FRepository: IConsumptionRepository;
    constructor Create(ARepository: IConsumptionRepository);
  public
    class function Make(ARepository: IConsumptionRepository): IConsumptionPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TConsumptionFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function IndexWithSale(AFilterSaleDTO: TConsumptionSaleFilterDTO): IZLMemTable overload;
    function Show(APK: Int64): TConsumptionShowDTO;
    function StoreAndShow(AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
    function Store(AInput: TConsumptionInputDTO): Int64;
    function Update(APK: Int64; AInput: TConsumptionInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uConsumption,
  XSuperObject,
  uConsumption.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TConsumptionPersistenceUseCase }

constructor TConsumptionPersistenceUseCase.Create(ARepository: IConsumptionRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TConsumptionPersistenceUseCase.Show(APK: Int64): TConsumptionShowDTO;
var
  LConsumptionFound: SH<TConsumption>;
begin
  Result := Nil;

  // Localizar Registro
  LConsumptionFound := FRepository.Show(APK);
  if not Assigned(LConsumptionFound.Value) then
    Exit;

  // Retornar DTO
  Result := TConsumptionMapper.EntityToShow(LConsumptionFound.Value);
end;

function TConsumptionPersistenceUseCase.Store(AInput: TConsumptionInputDTO): Int64;
var
  LEntity: SH<TConsumption>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TConsumptionMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TConsumptionPersistenceUseCase.StoreAndShow(AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TConsumptionPersistenceUseCase.Update(APK: Int64; AInput: TConsumptionInputDTO): Int64;
var
  LConsumptionToUpdate: SH<TConsumption>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LConsumptionToUpdate := TConsumptionMapper.InputToEntity(AInput);
  With LConsumptionToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LConsumptionToUpdate);
end;

function TConsumptionPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TConsumptionPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TConsumptionPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TConsumptionPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TConsumptionPersistenceUseCase.IndexWithSale(AFilterSaleDTO: TConsumptionSaleFilterDTO): IZLMemTable;
begin
  const LFilter = TConsumptionMapper.FilterSaleToEntity(AFilterSaleDTO);
  Result := FRepository.IndexWithSale(LFilter);
end;

function TConsumptionPersistenceUseCase.Index(AFilterDTO: TConsumptionFilterDTO): IIndexResult;
begin
  const LFilter = TConsumptionMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TConsumptionPersistenceUseCase.Make(ARepository: IConsumptionRepository): IConsumptionPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
