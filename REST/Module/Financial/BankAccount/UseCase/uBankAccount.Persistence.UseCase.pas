unit uBankAccount.Persistence.UseCase;

interface

uses
  uBankAccount.Persistence.UseCase.Interfaces,
  uBankAccount.Repository.Interfaces,
  uBankAccount.Input.DTO,
  uBankAccount.Show.DTO,
  uIndexResult,
  uEither,
  uBankAccount.Filter.DTO,
  uFilter;

type
  TBankAccountPersistenceUseCase = class(TInterfacedObject, IBankAccountPersistenceUseCase)
  private
    FRepository: IBankAccountRepository;
    constructor Create(ARepository: IBankAccountRepository);
  public
    class function Make(ARepository: IBankAccountRepository): IBankAccountPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TBankAccountFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TBankAccountShowDTO;
    function StoreAndShow(AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
    function Store(AInput: TBankAccountInputDTO): Int64;
    function Update(APK: Int64; AInput: TBankAccountInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uBankAccount,
  XSuperObject,
  uBankAccount.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TBankAccountPersistenceUseCase }

constructor TBankAccountPersistenceUseCase.Create(ARepository: IBankAccountRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TBankAccountPersistenceUseCase.Show(APK: Int64): TBankAccountShowDTO;
var
  LBankAccountFound: SH<TBankAccount>;
begin
  Result := Nil;

  // Localizar Registro
  LBankAccountFound := FRepository.Show(APK);
  if not Assigned(LBankAccountFound.Value) then
    Exit;

  // Retornar DTO
  Result := TBankAccountMapper.EntityToShow(LBankAccountFound.Value);
end;

function TBankAccountPersistenceUseCase.Store(AInput: TBankAccountInputDTO): Int64;
var
  LEntity: SH<TBankAccount>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TBankAccountMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TBankAccountPersistenceUseCase.StoreAndShow(AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TBankAccountPersistenceUseCase.Update(APK: Int64; AInput: TBankAccountInputDTO): Int64;
var
  LBankAccountToUpdate: SH<TBankAccount>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LBankAccountToUpdate := TBankAccountMapper.InputToEntity(AInput);
  With LBankAccountToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LBankAccountToUpdate);
end;

function TBankAccountPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TBankAccountPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TBankAccountPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TBankAccountPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TBankAccountPersistenceUseCase.Index(AFilterDTO: TBankAccountFilterDTO): IIndexResult;
begin
  const LFilter = TBankAccountMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TBankAccountPersistenceUseCase.Make(ARepository: IBankAccountRepository): IBankAccountPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
