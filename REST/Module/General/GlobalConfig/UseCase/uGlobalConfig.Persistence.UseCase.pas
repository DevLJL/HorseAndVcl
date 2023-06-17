unit uGlobalConfig.Persistence.UseCase;

interface

uses
  uGlobalConfig.Persistence.UseCase.Interfaces,
  uGlobalConfig.Repository.Interfaces,
  uGlobalConfig.Input.DTO,
  uGlobalConfig.Show.DTO,
  uIndexResult,
  uEither,
  uGlobalConfig.Filter.DTO,
  uFilter;

type
  TGlobalConfigPersistenceUseCase = class(TInterfacedObject, IGlobalConfigPersistenceUseCase)
  private
    FRepository: IGlobalConfigRepository;
    constructor Create(ARepository: IGlobalConfigRepository);
  public
    class function Make(ARepository: IGlobalConfigRepository): IGlobalConfigPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TGlobalConfigFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TGlobalConfigShowDTO;
    function StoreAndShow(AInput: TGlobalConfigInputDTO): Either<String, TGlobalConfigShowDTO>;
    function Store(AInput: TGlobalConfigInputDTO): Int64;
    function Update(APK: Int64; AInput: TGlobalConfigInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TGlobalConfigInputDTO): Either<String, TGlobalConfigShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uGlobalConfig,
  XSuperObject,
  uGlobalConfig.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TGlobalConfigPersistenceUseCase }

constructor TGlobalConfigPersistenceUseCase.Create(ARepository: IGlobalConfigRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TGlobalConfigPersistenceUseCase.Show(APK: Int64): TGlobalConfigShowDTO;
begin
  Result := Nil;

  // Localizar Registro
  const LGlobalConfigFound: SH<TGlobalConfig> = FRepository.Show(APK);
  if not Assigned(LGlobalConfigFound.Value) then
    Exit;

  // Retornar DTO
  Result := TGlobalConfigMapper.EntityToShow(LGlobalConfigFound.Value);
end;

function TGlobalConfigPersistenceUseCase.Store(AInput: TGlobalConfigInputDTO): Int64;
begin
  raise Exception.Create('GlobalConfig Não pode ser inserido, apenas atualizado');
end;

function TGlobalConfigPersistenceUseCase.StoreAndShow(AInput: TGlobalConfigInputDTO): Either<String, TGlobalConfigShowDTO>;
begin
  raise Exception.Create('GlobalConfig Não pode ser inserido, apenas atualizado');
end;

function TGlobalConfigPersistenceUseCase.Update(APK: Int64; AInput: TGlobalConfigInputDTO): Int64;
begin
  // Mapear dados para Entity
  const LGlobalConfigToUpdate: SH<TGlobalConfig> = TGlobalConfigMapper.InputToEntity(AInput);
  With LGlobalConfigToUpdate.Value do
  begin
    id := APK;
    const LErrors = Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LGlobalConfigToUpdate);
end;

function TGlobalConfigPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TGlobalConfigInputDTO): Either<String, TGlobalConfigShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TGlobalConfigPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  raise Exception.Create('Este registro não pode ser deletado.');
end;

function TGlobalConfigPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  raise Exception.Create('Este registro não pode ser deletado.');
end;

function TGlobalConfigPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TGlobalConfigPersistenceUseCase.Index(AFilterDTO: TGlobalConfigFilterDTO): IIndexResult;
begin
  const LFilter = TGlobalConfigMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TGlobalConfigPersistenceUseCase.Make(ARepository: IGlobalConfigRepository): IGlobalConfigPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
