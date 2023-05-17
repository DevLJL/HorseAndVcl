unit uChartOfAccount.Persistence.UseCase;

interface

uses
  uChartOfAccount.Persistence.UseCase.Interfaces,
  uChartOfAccount.Repository.Interfaces,
  uChartOfAccount.Input.DTO,
  uChartOfAccount.Show.DTO,
  uIndexResult,
  uEither,
  uChartOfAccount.Filter.DTO,
  uFilter;

type
  TChartOfAccountPersistenceUseCase = class(TInterfacedObject, IChartOfAccountPersistenceUseCase)
  private
    FRepository: IChartOfAccountRepository;
    constructor Create(ARepository: IChartOfAccountRepository);
  public
    class function Make(ARepository: IChartOfAccountRepository): IChartOfAccountPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TChartOfAccountFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TChartOfAccountShowDTO;
    function StoreAndShow(AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
    function Store(AInput: TChartOfAccountInputDTO): Int64;
    function Update(APK: Int64; AInput: TChartOfAccountInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uChartOfAccount,
  XSuperObject,
  uChartOfAccount.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TChartOfAccountPersistenceUseCase }

constructor TChartOfAccountPersistenceUseCase.Create(ARepository: IChartOfAccountRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TChartOfAccountPersistenceUseCase.Show(APK: Int64): TChartOfAccountShowDTO;
var
  LChartOfAccountFound: SH<TChartOfAccount>;
begin
  Result := Nil;

  // Localizar Registro
  LChartOfAccountFound := FRepository.Show(APK);
  if not Assigned(LChartOfAccountFound.Value) then
    Exit;

  // Retornar DTO
  Result := TChartOfAccountMapper.EntityToShow(LChartOfAccountFound.Value);
end;

function TChartOfAccountPersistenceUseCase.Store(AInput: TChartOfAccountInputDTO): Int64;
var
  LEntity: SH<TChartOfAccount>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TChartOfAccountMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TChartOfAccountPersistenceUseCase.StoreAndShow(AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TChartOfAccountPersistenceUseCase.Update(APK: Int64; AInput: TChartOfAccountInputDTO): Int64;
var
  LChartOfAccountToUpdate: SH<TChartOfAccount>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LChartOfAccountToUpdate := TChartOfAccountMapper.InputToEntity(AInput);
  With LChartOfAccountToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LChartOfAccountToUpdate);
end;

function TChartOfAccountPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TChartOfAccountPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TChartOfAccountPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TChartOfAccountPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TChartOfAccountPersistenceUseCase.Index(AFilterDTO: TChartOfAccountFilterDTO): IIndexResult;
begin
  const LFilter = TChartOfAccountMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TChartOfAccountPersistenceUseCase.Make(ARepository: IChartOfAccountRepository): IChartOfAccountPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
