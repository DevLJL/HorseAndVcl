unit uCompany.Service;

interface

uses
  uCompany.Input.DTO,
  uCompany.Show.DTO,
  RESTRequest4D,
  uEither,
  uCompany.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uCompany.Service.Interfaces;

type
  TCompanyService = class(TBaseService, ICompanyService)
  private
  public
    class function Make: ICompanyService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCompanyFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCompanyShowDTO;
    function StoreAndShow(AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
    function Validate(AInput: TCompanyInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uCompany.ViewModel,
  uReq,
  uTrans,
  uHlp;

const
  RESOURCE = '/Companies';

{ TCompanyService }
function TCompanyService.Delete(AId: Int64): Boolean;
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

function TCompanyService.Index(AFilter: TCompanyFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TCompanyFilterDTO.Create;

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
  const LViewModel = TCompanyViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Company, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TCompanyService.Make: ICompanyService;
begin
  Result := TCompanyService.Create;
end;

function TCompanyService.Show(AId: Int64): TCompanyShowDTO;
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
  Result := TCompanyShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TCompanyService.StoreAndShow(AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
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
  Result := TCompanyShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TCompanyService.UpdateAndShow(AId: Int64; AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
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
  Result := TCompanyShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TCompanyService.Validate(AInput: TCompanyInputDTO; AState: TEntityState): String;
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

