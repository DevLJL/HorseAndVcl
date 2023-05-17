unit uCashFlow.Service;

interface

uses
  uCashFlow.Input.DTO,
  uCashFlow.Show.DTO,
  RESTRequest4D,
  uEither,
  uCashFlow.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uCashFlow.Service.Interfaces;

type
  TCashFlowService = class(TBaseService, ICashFlowService)
  private
  public
    class function Make: ICashFlowService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCashFlowFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCashFlowShowDTO;
    function StoreAndShow(AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
    function Validate(AInput: TCashFlowInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uCashFlow.ViewModel,
  uReq,
  uTrans,
  uHlp;

const
  RESOURCE = '/CashFlows';

{ TCashFlowService }
function TCashFlowService.Delete(AId: Int64): Boolean;
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

function TCashFlowService.Index(AFilter: TCashFlowFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TCashFlowFilterDTO.Create;

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
  const LViewModel = TCashFlowViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.CashFlow, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TCashFlowService.Make: ICashFlowService;
begin
  Result := TCashFlowService.Create;
end;

function TCashFlowService.Show(AId: Int64): TCashFlowShowDTO;
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
  Result := TCashFlowShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TCashFlowService.StoreAndShow(AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
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
  Result := TCashFlowShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TCashFlowService.UpdateAndShow(AId: Int64; AInput: TCashFlowInputDTO): Either<String, TCashFlowShowDTO>;
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
  Result := TCashFlowShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TCashFlowService.Validate(AInput: TCashFlowInputDTO; AState: TEntityState): String;
begin
//  if AInput.name.IsEmpty then
//    Result := Result + Trans.FieldWasNotInformed('Razão/Nome') + #13;
end;

end.

