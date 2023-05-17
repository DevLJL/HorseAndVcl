unit uStation.Persistence.UseCase;

interface

uses
  uStation.Persistence.UseCase.Interfaces,
  uStation.Repository.Interfaces,
  uStation.Input.DTO,
  uStation.Show.DTO,
  uIndexResult,
  uEither,
  uStation.Filter.DTO,
  uFilter;

type
  TStationPersistenceUseCase = class(TInterfacedObject, IStationPersistenceUseCase)
  private
    FRepository: IStationRepository;
    constructor Create(ARepository: IStationRepository);
  public
    class function Make(ARepository: IStationRepository): IStationPersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TStationFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TStationShowDTO;
    function StoreAndShow(AInput: TStationInputDTO): Either<String, TStationShowDTO>;
    function Store(AInput: TStationInputDTO): Int64;
    function Update(APK: Int64; AInput: TStationInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TStationInputDTO): Either<String, TStationShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uStation,
  XSuperObject,
  uStation.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TStationPersistenceUseCase }

constructor TStationPersistenceUseCase.Create(ARepository: IStationRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TStationPersistenceUseCase.Show(APK: Int64): TStationShowDTO;
var
  LStationFound: SH<TStation>;
begin
  Result := Nil;

  // Localizar Registro
  LStationFound := FRepository.Show(APK);
  if not Assigned(LStationFound.Value) then
    Exit;

  // Retornar DTO
  Result := TStationMapper.EntityToShow(LStationFound.Value);
end;

function TStationPersistenceUseCase.Store(AInput: TStationInputDTO): Int64;
var
  LEntity: SH<TStation>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TStationMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TStationPersistenceUseCase.StoreAndShow(AInput: TStationInputDTO): Either<String, TStationShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TStationPersistenceUseCase.Update(APK: Int64; AInput: TStationInputDTO): Int64;
var
  LStationToUpdate: SH<TStation>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LStationToUpdate := TStationMapper.InputToEntity(AInput);
  With LStationToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LStationToUpdate);
end;

function TStationPersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TStationInputDTO): Either<String, TStationShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TStationPersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TStationPersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TStationPersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TStationPersistenceUseCase.Index(AFilterDTO: TStationFilterDTO): IIndexResult;
begin
  const LFilter = TStationMapper.FilterToEntity(AFilterDTO);
  Result := FRepository.Index(LFilter);
end;

class function TStationPersistenceUseCase.Make(ARepository: IStationRepository): IStationPersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
