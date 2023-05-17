unit uPayment.Service;

interface

uses
  uPayment.Input.DTO,
  uPayment.Show.DTO,
  RESTRequest4D,
  uEither,
  uPayment.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uPayment.Service.Interfaces;

type
  TPaymentService = class(TBaseService, IPaymentService)
  private
  public
    class function Make: IPaymentService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TPaymentFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TPaymentShowDTO;
    function StoreAndShow(AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
    function Validate(AInput: TPaymentInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uPayment.ViewModel,
  uReq,
  uTrans,
  uHlp;

const
  RESOURCE = '/Payments';

{ TPaymentService }
function TPaymentService.Delete(AId: Int64): Boolean;
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

function TPaymentService.Index(AFilter: TPaymentFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TPaymentFilterDTO.Create;

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
  const LViewModel = TPaymentViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Payment, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TPaymentService.Make: IPaymentService;
begin
  Result := TPaymentService.Create;
end;

function TPaymentService.Show(AId: Int64): TPaymentShowDTO;
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
  Result := TPaymentShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TPaymentService.StoreAndShow(AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
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
  Result := TPaymentShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TPaymentService.UpdateAndShow(AId: Int64; AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
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
  Result := TPaymentShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TPaymentService.Validate(AInput: TPaymentInputDTO; AState: TEntityState): String;
begin
//  if AInput.name.IsEmpty then
//    Result := Result + Trans.FieldWasNotInformed('Razão/Nome') + #13;
end;

end.

