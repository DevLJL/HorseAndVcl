unit uBank.Persistence.UseCase;

interface

uses
  uBank.Persistence.UseCase.Interfaces,
  uBank.Repository.Interfaces,
  uBank.Input.DTO,
  uBank.Show.DTO,
  uIndexResult,
  uEither,
  uBank.Filter.DTO,
  uFilter;

type
  TBankPersistenceUseCase = class(TInterfacedObject, IBankPersistenceUseCase)
  private
    FRepository: IBankRepository;
    constructor Create(ARepository: IBankRepository);
  public
    class function Make(ARepository: IBankRepository): IBankPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TBankFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TBankShowDTO;
    function StoreAndShow(AInput: TBankInputDTO): Either<String, TBankShowDTO>;
    function Store(AInput: TBankInputDTO): Int64;
    function Update(APK: Int64; AInput: TBankInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TBankInputDTO): Either<String, TBankShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uBank,
  XSuperObject,
  uBank.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TBankPersistenceUseCase }

constructor TBankPersistenceUseCase.Create(ARepository: IBankRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TBankPersistenceUseCase.Show(APK: Int64): TBankShowDTO;
var
  LBankFound: SH<TBank>;
begin
  Result := Nil;

  // Localizar Registro
  LBankFound := FRepository.Show(APK);
  if not Assigned(LBankFound.Value) then
    Exit;

  // Retornar DTO
  Result := TBankMapper.EntityToShow(LBankFound.Value);
end;

function TBankPersistenceUseCase.Store(AInput: TBankInputDTO): Int64;
var
  LEntity: SH<TBank>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TBankMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TBankPersistenceUseCase.StoreAndShow(AInput: TBankInputDTO): Either<String, TBankShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TBankPersistenceUseCase.Update(APK: Int64; AInput: TBankInputDTO): Int64;
var
  LBankToUpdate: SH<TBank>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LBankToUpdate := TBankMapper.InputToEntity(AInput);
  With LBankToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LBankToUpdate);
end;

function TBankPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TBankInputDTO): Either<String, TBankShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TBankPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TBankPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TBankPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TBankPersistenceUseCase.Index(AFilterDTO: TBankFilterDTO): IIndexResult;
begin
  const LFilter = TBankMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TBankPersistenceUseCase.Make(ARepository: IBankRepository): IBankPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
