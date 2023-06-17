unit uGlobalConfig.Service;

interface

uses
  uGlobalConfig.Input.DTO,
  uGlobalConfig.Show.DTO,
  RESTRequest4D,
  uEither,
  uGlobalConfig.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uGlobalConfig.Service.Interfaces;

type
  TGlobalConfigService = class(TBaseService, IGlobalConfigService)
  private
  public
    class function Make: IGlobalConfigService;
    function Index(AFilter: TGlobalConfigFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64 = 1): TGlobalConfigShowDTO;
    function UpdateAndShow(AId: Int64 = 1; AInput: TGlobalConfigInputDTO = nil): Either<String, TGlobalConfigShowDTO>;
    function Validate(AInput: TGlobalConfigInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uGlobalConfig.ViewModel,
  uReq,
  uTrans,
  uHlp;

const
  RESOURCE = '/GlobalConfig';

{ TGlobalConfigService }
function TGlobalConfigService.Index(AFilter: TGlobalConfigFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TGlobalConfigFilterDTO.Create;

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
  const LViewModel = TGlobalConfigViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.GlobalConfig, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TGlobalConfigService.Make: IGlobalConfigService;
begin
  Result := TGlobalConfigService.Create;
end;

function TGlobalConfigService.Show(AId: Int64): TGlobalConfigShowDTO;
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
  Result := TGlobalConfigShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TGlobalConfigService.UpdateAndShow(AId: Int64; AInput: TGlobalConfigInputDTO): Either<String, TGlobalConfigShowDTO>;
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
  Result := TGlobalConfigShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TGlobalConfigService.Validate(AInput: TGlobalConfigInputDTO; AState: TEntityState): String;
begin
//
end;

end.

