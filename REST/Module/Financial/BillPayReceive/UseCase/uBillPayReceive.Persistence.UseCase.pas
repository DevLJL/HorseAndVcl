unit uBillPayReceive.Persistence.UseCase;

interface

uses
  uBillPayReceive.Persistence.UseCase.Interfaces,
  uBillPayReceive.Repository.Interfaces,
  uBillPayReceive.Input.DTO,
  uBillPayReceive.Show.DTO,
  uIndexResult,
  uEither,
  uBillPayReceive.Filter.DTO,
  uFilter;

type
  TBillPayReceivePersistenceUseCase = class(TInterfacedObject, IBillPayReceivePersistenceUseCase)
  private
    FRepository: IBillPayReceiveRepository;
    constructor Create(ARepository: IBillPayReceiveRepository);
  public
    class function Make(ARepository: IBillPayReceiveRepository): IBillPayReceivePersistenceUseCase;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TBillPayReceiveFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TBillPayReceiveShowDTO;
    function StoreAndShow(AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
    function Store(AInput: TBillPayReceiveInputDTO): Int64;
    function Update(APK: Int64; AInput: TBillPayReceiveInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
  end;

implementation

uses
  uSmartPointer,
  uBillPayReceive,
  XSuperObject,
  uBillPayReceive.Mapper,
  System.SysUtils,
  uApplication.Exception;

{ TBillPayReceivePersistenceUseCase }

constructor TBillPayReceivePersistenceUseCase.Create(ARepository: IBillPayReceiveRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TBillPayReceivePersistenceUseCase.Show(APK: Int64): TBillPayReceiveShowDTO;
var
  LBillPayReceiveFound: SH<TBillPayReceive>;
begin
  Result := Nil;

  // Localizar Registro
  LBillPayReceiveFound := FRepository.Show(APK);
  if not Assigned(LBillPayReceiveFound.Value) then
    Exit;

  // Retornar DTO
  Result := TBillPayReceiveMapper.EntityToShow(LBillPayReceiveFound.Value);
end;

function TBillPayReceivePersistenceUseCase.Store(AInput: TBillPayReceiveInputDTO): Int64;
var
  LEntity: SH<TBillPayReceive>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LEntity := TBillPayReceiveMapper.InputToEntity(AInput);
  LErrors := LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);

  // Incluir
  Result := FRepository.Store(LEntity);
end;

function TBillPayReceivePersistenceUseCase.StoreAndShow(AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
begin
  try
    Result := Show(Store(AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TBillPayReceivePersistenceUseCase.Update(APK: Int64; AInput: TBillPayReceiveInputDTO): Int64;
var
  LBillPayReceiveToUpdate: SH<TBillPayReceive>;
  LErrors: String;
begin
  // Mapear dados para Entity
  LBillPayReceiveToUpdate := TBillPayReceiveMapper.InputToEntity(AInput);
  With LBillPayReceiveToUpdate.Value do
  begin
    id      := APK;
    LErrors := Validate;
    if not LErrors.Trim.IsEmpty then
      raise EEntityValidationException.Create(LErrors);
  end;

  // Atualizar
  Result := FRepository.Update(APK, LBillPayReceiveToUpdate);
end;

function TBillPayReceivePersistenceUseCase.UpdateAndShow(AId: Int64; AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
begin
  try
    Result := Show(Update(AId, AInput));
  except
    on E: EEntityValidationException do Result := E.Message;
    on E: Exception do raise;
  end;
end;

function TBillPayReceivePersistenceUseCase.Delete(AId: Int64): Boolean;
begin
  Result := FRepository.Delete(AId);
end;

function TBillPayReceivePersistenceUseCase.DeleteByIdRange(AIds: String): Boolean;
begin
  Result := FRepository.DeleteByIdRange(AIds);
end;

function TBillPayReceivePersistenceUseCase.Index(AFilterEntity: IFilter): IIndexResult;
begin
  Result := FRepository.Index(AFilterEntity);
end;

function TBillPayReceivePersistenceUseCase.Index(AFilterDTO: TBillPayReceiveFilterDTO): IIndexResult;
begin
  const LFilter = TBillPayReceiveMapper.FilterToEntity(AFilterDTO);
  Result := Self.Index(LFilter);
end;

class function TBillPayReceivePersistenceUseCase.Make(ARepository: IBillPayReceiveRepository): IBillPayReceivePersistenceUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
