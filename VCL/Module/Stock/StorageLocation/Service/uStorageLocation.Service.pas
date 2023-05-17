unit uStorageLocation.Service;

interface

uses
  uStorageLocation.Input.DTO,
  uStorageLocation.Show.DTO,
  RESTRequest4D,
  uEither,
  uStorageLocation.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uStorageLocation.Service.Interfaces;

type
  TStorageLocationService = class(TBaseService, IStorageLocationService)
  private
  public
    class function Make: IStorageLocationService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TStorageLocationFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TStorageLocationShowDTO;
    function StoreAndShow(AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
    function Validate(AInput: TStorageLocationInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uStorageLocation.ViewModel,
  uReq,
  uTrans;

const
  RESOURCE = '/StorageLocations';

{ TStorageLocationService }
function TStorageLocationService.Delete(AId: Int64): Boolean;
begin
  // Efetuar Requisição
  const LEndPoint = RESOURCE+'/'+AId.ToString;
  const LResponse = Req(LEndPoint).Execute(TReqType.Delete);
  if not (LResponse.StatusCode = 204) then
  begin
    case (Pos('"message":', LResponse.Content) > 0) of
      True:  raise Exception.Create(SO(LResponse.Content).S['message']);
      False: raise Exception.Create(LResponse.Content);
    end;
  end;

  Result := True;
end;

function TStorageLocationService.Index(AFilter: TStorageLocationFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TStorageLocationFilterDTO.Create;

  // Efetuar Requisição
  const LEndPoint = RESOURCE+'/Index';
  const LResponse = Req(LEndPoint, AFilter.AsJSON)
    .AddETag(AFilter.etag)
    .Execute(TReqType.Post);

  // Nenhum recurso alterado desde a ultima requisição
  if (LResponse.StatusCode = 304) then
  begin
    Result := TIndexResult.Make.ETag(LResponse.ETag);
    Exit;
  end;

  // Retornar erro se for diferente de 200
  if not (LResponse.StatusCode = 200) then
  begin
    case (Pos('"message":', LResponse.Content) > 0) of
      True:  Result := SO(LResponse.Content).S['message'];
      False: Result := LResponse.Content;
    end;
    Exit;
  end;

  // Destruir filtro se não informado e criado neste escopo
  if not LInformedFilter and Assigned(AFilter) then
    AFilter.Free;

  // Retornar Listagem de dados
  const LViewModel = TStorageLocationViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.StorageLocation, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TStorageLocationService.Make: IStorageLocationService;
begin
  Result := TStorageLocationService.Create;
end;

function TStorageLocationService.Show(AId: Int64): TStorageLocationShowDTO;
begin
  Result := Nil;
  if (AId <= 0) then
    Exit;

  // Efetuar Requisição
  const LEndPoint = RESOURCE+'/'+AId.ToString;
  const LResponse = Req(LEndPoint).Execute;
  if not (LResponse.StatusCode = 200) then
    Exit;

  // Retornar registro encontado
  Result := TStorageLocationShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TStorageLocationService.StoreAndShow(AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
begin
  // Validar
  const LError = Validate(AInput, TEntityState.Store);
  if not LError.Trim.IsEmpty then
  begin
    Result := LError;
    Exit;
  end;

  // Efetuar Requisição
  const LEndPoint = RESOURCE;
  const LResponse = Req(LEndPoint, AInput.AsJson).Execute(TReqType.Post);
  if not (LResponse.StatusCode = 201) then
  begin
    case (Pos('"message":', LResponse.Content) > 0) of
      True:  Result := SO(LResponse.Content).S['message'];
      False: Result := LResponse.Content;
    end;
    Exit;
  end;

  // Retornar registro incluso
  Result := TStorageLocationShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TStorageLocationService.UpdateAndShow(AId: Int64; AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
begin
  // Validar
  const LError = Validate(AInput, TEntityState.Update);
  if not LError.Trim.IsEmpty then
  begin
    Result := LError;
    Exit;
  end;

  // Efetuar Requisição
  const LEndPoint = RESOURCE+'/'+AId.ToString;
  const LResponse = Req(LEndPoint, AInput.AsJson).Execute(TReqType.Put);
  if not (LResponse.StatusCode = 200) then
  begin
    case (Pos('"message":', LResponse.Content) > 0) of
      True:  Result := SO(LResponse.Content).S['message'];
      False: Result := LResponse.Content;
    end;
    Exit;
  end;

  // Retornar registro atualizado
  Result := TStorageLocationShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TStorageLocationService.Validate(AInput: TStorageLocationInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

end.

