unit uPerson.Service;

interface

uses
  uPerson.Input.DTO,
  uPerson.Show.DTO,
  RESTRequest4D,
  uEither,
  uPerson.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uPerson.Service.Interfaces;

type
  TPersonService = class(TBaseService, IPersonService)
  private
  public
    class function Make: IPersonService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TPersonFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TPersonShowDTO;
    function StoreAndShow(AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
    function Validate(AInput: TPersonInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uPerson.ViewModel,
  uReq,
  uTrans,
  uHlp;

const
  RESOURCE = '/Persons';

{ TPersonService }
function TPersonService.Delete(AId: Int64): Boolean;
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

function TPersonService.Index(AFilter: TPersonFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TPersonFilterDTO.Create;

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
  const LViewModel = TPersonViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Person, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TPersonService.Make: IPersonService;
begin
  Result := TPersonService.Create;
end;

function TPersonService.Show(AId: Int64): TPersonShowDTO;
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
  Result := TPersonShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TPersonService.StoreAndShow(AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
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
  Result := TPersonShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TPersonService.UpdateAndShow(AId: Int64; AInput: TPersonInputDTO): Either<String, TPersonShowDTO>;
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
  Result := TPersonShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TPersonService.Validate(AInput: TPersonInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Razão/Nome') + #13;

  if AInput.address.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Endereço') + #13;

  if (AInput.city_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Cidade') + #13;

  if OnlyNumbers(AInput.phone_1).Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Telefone 1') + #13;
end;

end.

