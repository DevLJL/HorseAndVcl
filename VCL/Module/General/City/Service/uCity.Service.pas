unit uCity.Service;

interface

uses
  uCity.Input.DTO,
  uCity.Show.DTO,
  RESTRequest4D,
  uEither,
  uCity.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uCity.Service.Interfaces;

type
  TCityService = class(TBaseService, ICityService)
  private
  public
    class function Make: ICityService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCityFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCityShowDTO;
    function StoreAndShow(AInput: TCityInputDTO): Either<String, TCityShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCityInputDTO): Either<String, TCityShowDTO>;
    function Validate(AInput: TCityInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uCity.ViewModel,
  uReq, uTrans;

const
  RESOURCE = '/Cities';

{ TCityService }
function TCityService.Delete(AId: Int64): Boolean;
begin
  // Efetuar Requisi��o
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

function TCityService.Index(AFilter: TCityFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se n�o informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TCityFilterDTO.Create;

  // Efetuar Requisi��o
  const LEndPoint = RESOURCE+'/Index';
  const LResponse = Req(LEndPoint, AFilter.AsJSON)
    .AddETag(AFilter.etag)
    .Execute(TReqType.Post);

  // Nenhum recurso alterado desde a ultima requisi��o
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

  // Destruir filtro se n�o informado e criado neste escopo
  if not LInformedFilter and Assigned(AFilter) then
    AFilter.Free;

  // Retornar Listagem de dados
  const LViewModel = TCityViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.City, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TCityService.Make: ICityService;
begin
  Result := TCityService.Create;
end;

function TCityService.Show(AId: Int64): TCityShowDTO;
begin
  Result := Nil;
  if (AId <= 0) then
    Exit;

  // Efetuar Requisi��o
  const LEndPoint = RESOURCE+'/'+AId.ToString;
  const LResponse = Req(LEndPoint).Execute;
  if not (LResponse.StatusCode = 200) then
    Exit;

  // Retornar registro encontado
  Result := TCityShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TCityService.StoreAndShow(AInput: TCityInputDTO): Either<String, TCityShowDTO>;
begin
  // Validar
  const LError = Validate(AInput, TEntityState.Store);
  if not LError.Trim.IsEmpty then
  begin
    Result := LError;
    Exit;
  end;

  // Efetuar Requisi��o
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
  Result := TCityShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TCityService.UpdateAndShow(AId: Int64; AInput: TCityInputDTO): Either<String, TCityShowDTO>;
begin
  // Validar
  const LError = Validate(AInput, TEntityState.Update);
  if not LError.Trim.IsEmpty then
  begin
    Result := LError;
    Exit;
  end;

  // Efetuar Requisi��o
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
  Result := TCityShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TCityService.Validate(AInput: TCityInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;

  if AInput.state.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Estado') + #13;

  if AInput.country.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Pa�s') + #13;

  if AInput.ibge_code.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('C�d IBGE da Cidade') + #13;

  if AInput.country_ibge_code.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('C�d IBGE do Pa�s') + #13;
end;

end.

