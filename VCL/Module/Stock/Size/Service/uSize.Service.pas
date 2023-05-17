unit uSize.Service;

interface

uses
  uSize.Input.DTO,
  uSize.Show.DTO,
  RESTRequest4D,
  uEither,
  uSize.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uSize.Service.Interfaces;

type
  TSizeService = class(TBaseService, ISizeService)
  private
  public
    class function Make: ISizeService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TSizeFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TSizeShowDTO;
    function StoreAndShow(AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
    function Validate(AInput: TSizeInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uSize.ViewModel,
  uReq,
  uTrans;

const
  RESOURCE = '/Sizes';

{ TSizeService }
function TSizeService.Delete(AId: Int64): Boolean;
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

function TSizeService.Index(AFilter: TSizeFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TSizeFilterDTO.Create;

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
  const LViewModel = TSizeViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Size, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TSizeService.Make: ISizeService;
begin
  Result := TSizeService.Create;
end;

function TSizeService.Show(AId: Int64): TSizeShowDTO;
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
  Result := TSizeShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TSizeService.StoreAndShow(AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
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
  Result := TSizeShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TSizeService.UpdateAndShow(AId: Int64; AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
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
  Result := TSizeShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TSizeService.Validate(AInput: TSizeInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

end.

