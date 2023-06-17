unit uProduct.Service;

interface

uses
  uProduct.Input.DTO,
  uProduct.Show.DTO,
  RESTRequest4D,
  uEither,
  uProduct.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uProduct.Service.Interfaces;

type
  TProductService = class(TBaseService, IProductService)
  private
  public
    class function Make: IProductService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TProductFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TProductShowDTO;
    function ShowByEanOrSkuCode(AValue: String): TProductShowDTO;
    function StoreAndShow(AInput: TProductInputDTO): Either<String, TProductShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TProductInputDTO): Either<String, TProductShowDTO>;
    function Validate(AInput: TProductInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uProduct.ViewModel,
  uReq,
  uTrans,
  uHlp;

const
  RESOURCE = '/Products';

{ TProductService }
function TProductService.Delete(AId: Int64): Boolean;
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

function TProductService.Index(AFilter: TProductFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TProductFilterDTO.Create;

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
  const LViewModel = TProductViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Product, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TProductService.Make: IProductService;
begin
  Result := TProductService.Create;
end;

function TProductService.Show(AId: Int64): TProductShowDTO;
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
  Result := TProductShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TProductService.ShowByEanOrSkuCode(AValue: String): TProductShowDTO;
begin
  Result := Nil;
  if AValue.Trim.IsEmpty then
    Exit;

  // Efetuar Requisição
  const LEndPoint = RESOURCE+'/ShowByEanOrSkuCode/'+AValue.Trim;
  const LResponse = Req(LEndPoint).Execute;
  if not (LResponse.StatusCode = 200) then
    Exit;

  // Retornar registro encontado
  Result := TProductShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TProductService.StoreAndShow(AInput: TProductInputDTO): Either<String, TProductShowDTO>;
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
  Result := TProductShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TProductService.UpdateAndShow(AId: Int64; AInput: TProductInputDTO): Either<String, TProductShowDTO>;
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
  Result := TProductShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TProductService.Validate(AInput: TProductInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;

  // ProductPriceList
  for var LI := 0 to Pred(AInput.product_price_lists.Count) do
  begin
    var LCurrentError := '';
    if (AInput.product_price_lists.Items[LI].price_list_id <= 0) then
      LCurrentError := LCurrentError + '     [Lista de Preço (ID)] é um campo obrigatório.'+ #13;

    if (AInput.product_price_lists.Items[LI].price <= 0) then
      LCurrentError := LCurrentError + '     [Preço] é um campo obrigatório.'+ #13;

    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Lista de Preço > Posição ' + StrZero((lI+1).ToString,3) + ': ' + #13 + LCurrentError;
  end;
end;

end.

