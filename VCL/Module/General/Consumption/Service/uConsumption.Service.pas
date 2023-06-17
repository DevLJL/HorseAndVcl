unit uConsumption.Service;

interface

uses
  uConsumption.Input.DTO,
  uConsumption.Show.DTO,
  RESTRequest4D,
  uEither,
  uConsumption.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uConsumption.Service.Interfaces,
  uConsumptionSale.Filter.DTO,
  uZLMemTable.Interfaces;

type
  TConsumptionService = class(TBaseService, IConsumptionService)
  private
  public
    class function Make: IConsumptionService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TConsumptionFilterDTO = nil): Either<String, IIndexResult>;
    function IndexWithSale(AFilter: TConsumptionSaleFilterDTO = nil): Either<String, IZLMemTable>;
    function Show(AId: Int64): TConsumptionShowDTO;
    function StoreAndShow(AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
    function Validate(AInput: TConsumptionInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uConsumption.ViewModel,
  uReq,
  uTrans,
  uConsumptionSale.ViewModel;

const
  RESOURCE = '/Consumption';

{ TConsumptionService }
function TConsumptionService.Delete(AId: Int64): Boolean;
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

function TConsumptionService.Index(AFilter: TConsumptionFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TConsumptionFilterDTO.Create;

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
  const LViewModel = TConsumptionViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Consumption, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

function TConsumptionService.IndexWithSale(AFilter: TConsumptionSaleFilterDTO): Either<String, IZLMemTable>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TConsumptionSaleFilterDTO.Create;

  // Efetuar Requisição
  const LEndPoint = RESOURCE+'/IndexWithSale';
  const LResponse = Req(LEndPoint, AFilter.AsJSON)
    .Execute(TReqType.Post);

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
  const LViewModel = TConsumptionSaleViewModel.Make;
  const LSO = SO(LResponse.Content).O['data'].A['result'];
  LViewModel.ConsumptionSale.FromJson(LSO.AsJSON);
  LViewModel.SetEvents;
  Result := LViewModel.ConsumptionSale;
end;

class function TConsumptionService.Make: IConsumptionService;
begin
  Result := TConsumptionService.Create;
end;

function TConsumptionService.Show(AId: Int64): TConsumptionShowDTO;
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
  Result := TConsumptionShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TConsumptionService.StoreAndShow(AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
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
  Result := TConsumptionShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TConsumptionService.UpdateAndShow(AId: Int64; AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
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
  Result := TConsumptionShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TConsumptionService.Validate(AInput: TConsumptionInputDTO; AState: TEntityState): String;
begin
  if (AInput.number <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Número de Consumo') + #13;
end;

end.

