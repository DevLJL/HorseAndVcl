unit uStation.Service;

interface

uses
  uStation.Input.DTO,
  uStation.Show.DTO,
  RESTRequest4D,
  uEither,
  uStation.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uStation.Service.Interfaces;

type
  TStationService = class(TBaseService, IStationService)
  private
  public
    class function Make: IStationService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TStationFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TStationShowDTO;
    function StoreAndShow(AInput: TStationInputDTO): Either<String, TStationShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TStationInputDTO): Either<String, TStationShowDTO>;
    function Validate(AInput: TStationInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uStation.ViewModel,
  uReq,
  uTrans;

const
  RESOURCE = '/Stations';

{ TStationService }
function TStationService.Delete(AId: Int64): Boolean;
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

function TStationService.Index(AFilter: TStationFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TStationFilterDTO.Create;

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
  const LViewModel = TStationViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Station, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TStationService.Make: IStationService;
begin
  Result := TStationService.Create;
end;

function TStationService.Show(AId: Int64): TStationShowDTO;
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
  Result := TStationShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TStationService.StoreAndShow(AInput: TStationInputDTO): Either<String, TStationShowDTO>;
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
  Result := TStationShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TStationService.UpdateAndShow(AId: Int64; AInput: TStationInputDTO): Either<String, TStationShowDTO>;
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
  Result := TStationShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TStationService.Validate(AInput: TStationInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

end.

