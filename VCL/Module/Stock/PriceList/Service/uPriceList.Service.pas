unit uPriceList.Service;

interface

uses
  uPriceList.Input.DTO,
  uPriceList.Show.DTO,
  RESTRequest4D,
  uEither,
  uPriceList.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uPriceList.Service.Interfaces;

type
  TPriceListService = class(TBaseService, IPriceListService)
  private
  public
    class function Make: IPriceListService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TPriceListFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TPriceListShowDTO;
    function StoreAndShow(AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
    function Validate(AInput: TPriceListInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uPriceList.ViewModel,
  uReq,
  uTrans;

const
  RESOURCE = '/PriceLists';

{ TPriceListService }
function TPriceListService.Delete(AId: Int64): Boolean;
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

function TPriceListService.Index(AFilter: TPriceListFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TPriceListFilterDTO.Create;

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
  const LViewModel = TPriceListViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.PriceList, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TPriceListService.Make: IPriceListService;
begin
  Result := TPriceListService.Create;
end;

function TPriceListService.Show(AId: Int64): TPriceListShowDTO;
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
  Result := TPriceListShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TPriceListService.StoreAndShow(AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
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
  Result := TPriceListShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TPriceListService.UpdateAndShow(AId: Int64; AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
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
  Result := TPriceListShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TPriceListService.Validate(AInput: TPriceListInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

end.

