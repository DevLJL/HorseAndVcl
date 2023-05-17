unit uCompany.Persistence.UseCase;

interface

uses
  uCompany.Persistence.UseCase.Interfaces,
  uCompany.Repository.Interfaces,
  uCompany.Input.DTO,
  uCompany.Show.DTO,
  uIndexResult,
  uEither,
  uCompany.Filter.DTO,
  uFilter;

type
  TCompanyPersistenceUseCase = class(TInterfacedObject, ICompanyPersistenceUseCase)
  private
    FRepository: ICompanyRepository;
    constructor Create(ARepository: ICompanyRepository);
  public
    class function Make(ARepository: ICompanyRepository): ICompanyPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCompanyFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCompanyShowDTO;
    function StoreAndShow(AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
    function Store(AInput: TCompanyInputDTO): Int64;
    function Update(APK: Int64; AInput: TCompanyInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uCompany,
  XSuperObject,
  uCompany.Mapper,
  System.SysUtils,
  uApplication.Exception,
  uAppRest.Types;

{ TCompanyPersistenceUseCase }

constructor TCompanyPersistenceUseCase.Create(ARepository: ICompanyRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TCompanyPersistenceUseCase.Show(APK: Int64): TCompanyShowDTO;
var
  LCompanyFound: SH<TCompany>;
begin
  Result := Nil;

  // Localizar Registro
  LCompanyFound := FRepository.Show(APK);
  if not Assigned(LCompanyFound.Value) then
    Exit;

  // Retornar DTO
  Result := TCompanyMapper.EntityToShow(LCompanyFound.Value);
end;

function TCompanyPersistenceUseCase.Store(AInput: TCompanyInputDTO): Int64;
var
  LEntity: SH<TCompany>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TCompanyMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.BeforeSaveAndValidate(TEntityState.Store);
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TCompanyPersistenceUseCase.StoreAndShow(AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCompanyPersistenceUseCase.Update(APK: Int64; AInput: TCompanyInputDTO): Int64;
var
  LCompanyToUpdate: SH<TCompany>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LCompanyToUpdate := TCompanyMapper.InputToEntity(AInput);
  With LCompanyToUpdate.Value do
  begin
    id      := APK;
    LErrors := BeforeSaveAndValidate(TEntityState.Update);
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LCompanyToUpdate);
end;

function TCompanyPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TCompanyPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TCompanyPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TCompanyPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TCompanyPersistenceUseCase.Index(AFilterDTO: TCompanyFilterDTO): IIndexResult;
begin
  const LFilter = TCompanyMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TCompanyPersistenceUseCase.Make(ARepository: ICompanyRepository): ICompanyPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
