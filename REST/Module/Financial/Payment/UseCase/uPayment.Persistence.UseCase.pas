unit uPayment.Persistence.UseCase;

interface

uses
  uPayment.Persistence.UseCase.Interfaces,
  uPayment.Repository.Interfaces,
  uPayment.Input.DTO,
  uPayment.Show.DTO,
  uIndexResult,
  uEither,
  uPayment.Filter.DTO,
  uFilter;

type
  TPaymentPersistenceUseCase = class(TInterfacedObject, IPaymentPersistenceUseCase)
  private
    FRepository: IPaymentRepository;
    constructor Create(ARepository: IPaymentRepository);
  public
    class function Make(ARepository: IPaymentRepository): IPaymentPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TPaymentFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TPaymentShowDTO;
    function StoreAndShow(AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
    function Store(AInput: TPaymentInputDTO): Int64;
    function Update(APK: Int64; AInput: TPaymentInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uPayment,
  XSuperObject,
  uPayment.Mapper,
  System.SysUtils,
  uApplication.Exception,
  uAppRest.Types;

{ TPaymentPersistenceUseCase }

constructor TPaymentPersistenceUseCase.Create(ARepository: IPaymentRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TPaymentPersistenceUseCase.Show(APK: Int64): TPaymentShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LPaymentFound: SH<TPayment> = FRepository.Show(APK);
  if not Assigned(LPaymentFound.Value) then
    Exit;

  // Retornar DTO
  Result := TPaymentMapper.EntityToShow(LPaymentFound.Value);
end;

function TPaymentPersistenceUseCase.Store(AInput: TPaymentInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LEntity: SH<TPayment> = TPaymentMapper.InputToEntity(AInput);
  const LErrors = LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TPaymentPersistenceUseCase.StoreAndShow(AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TPaymentPersistenceUseCase.Update(APK: Int64; AInput: TPaymentInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LPaymentToUpdate: SH<TPayment> = TPaymentMapper.InputToEntity(AInput);
  With LPaymentToUpdate.Value do
  begin
    id := APK;
    const LErrors = Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LPaymentToUpdate);
end;

function TPaymentPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TPaymentPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TPaymentPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TPaymentPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TPaymentPersistenceUseCase.Index(AFilterDTO: TPaymentFilterDTO): IIndexResult;
begin
  const LFilter = TPaymentMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TPaymentPersistenceUseCase.Make(ARepository: IPaymentRepository): IPaymentPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
