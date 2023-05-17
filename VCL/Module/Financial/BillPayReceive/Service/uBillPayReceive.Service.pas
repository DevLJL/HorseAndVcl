unit uBillPayReceive.Service;

interface

uses
  uBillPayReceive.Input.DTO,
  uBillPayReceive.Show.DTO,
  RESTRequest4D,
  uEither,
  uBillPayReceive.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uBillPayReceive.Service.Interfaces;

type
  TBillPayReceiveService = class(TBaseService, IBillPayReceiveService)
  private
  public
    class function Make: IBillPayReceiveService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBillPayReceiveFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBillPayReceiveShowDTO;
    function StoreAndShow(AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
    function Validate(AInput: TBillPayReceiveInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uBillPayReceive.ViewModel,
  uReq,
  uTrans;

const
  RESOURCE = '/BillPayReceives';

{ TBillPayReceiveService }
function TBillPayReceiveService.Delete(AId: Int64): Boolean;
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

function TBillPayReceiveService.Index(AFilter: TBillPayReceiveFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TBillPayReceiveFilterDTO.Create;

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
  const LViewModel = TBillPayReceiveViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.BillPayReceive, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TBillPayReceiveService.Make: IBillPayReceiveService;
begin
  Result := TBillPayReceiveService.Create;
end;

function TBillPayReceiveService.Show(AId: Int64): TBillPayReceiveShowDTO;
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
  Result := TBillPayReceiveShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TBillPayReceiveService.StoreAndShow(AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
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
  Result := TBillPayReceiveShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TBillPayReceiveService.UpdateAndShow(AId: Int64; AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
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
  Result := TBillPayReceiveShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TBillPayReceiveService.Validate(AInput: TBillPayReceiveInputDTO; AState: TEntityState): String;
begin
//
end;

end.

