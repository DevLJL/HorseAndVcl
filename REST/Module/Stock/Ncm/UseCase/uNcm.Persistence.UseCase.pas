unit uNcm.Persistence.UseCase;

interface

uses
  uNcm.Persistence.UseCase.Interfaces,
  uNcm.Repository.Interfaces,
  uNcm.Input.DTO,
  uNcm.Show.DTO,
  uIndexResult,
  uEither,
  uNcm.Filter.DTO,
  uFilter;

type
  TNcmPersistenceUseCase = class(TInterfacedObject, INcmPersistenceUseCase)
  private
    FRepository: INcmRepository;
    constructor Create(ARepository: INcmRepository);
  public
    class function Make(ARepository: INcmRepository): INcmPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TNcmFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TNcmShowDTO;
    function StoreAndShow(AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
    function Store(AInput: TNcmInputDTO): Int64;
    function Update(APK: Int64; AInput: TNcmInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uNcm,
  XSuperObject,
  uNcm.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TNcmPersistenceUseCase }

constructor TNcmPersistenceUseCase.Create(ARepository: INcmRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TNcmPersistenceUseCase.Show(APK: Int64): TNcmShowDTO;
var
  LNcmFound: SH<TNcm>;
begin
  Result := Nil;

  // Localizar Registro
  LNcmFound := FRepository.Show(APK);
  if not Assigned(LNcmFound.Value) then
    Exit;

  // Retornar DTO
  Result := TNcmMapper.EntityToShow(LNcmFound.Value);
end;

function TNcmPersistenceUseCase.Store(AInput: TNcmInputDTO): Int64;
var
  LEntity: SH<TNcm>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TNcmMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TNcmPersistenceUseCase.StoreAndShow(AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TNcmPersistenceUseCase.Update(APK: Int64; AInput: TNcmInputDTO): Int64;
var
  LNcmToUpdate: SH<TNcm>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LNcmToUpdate := TNcmMapper.InputToEntity(AInput);
  With LNcmToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LNcmToUpdate);
end;

function TNcmPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TNcmPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TNcmPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TNcmPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TNcmPersistenceUseCase.Index(AFilterDTO: TNcmFilterDTO): IIndexResult;
begin
  const LFilter = TNcmMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TNcmPersistenceUseCase.Make(ARepository: INcmRepository): INcmPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
