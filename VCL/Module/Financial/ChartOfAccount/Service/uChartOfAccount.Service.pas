unit uChartOfAccount.Service;

interface

uses
  uChartOfAccount.Input.DTO,
  uChartOfAccount.Show.DTO,
  RESTRequest4D,
  uEither,
  uChartOfAccount.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uChartOfAccount.Service.Interfaces;

type
  TChartOfAccountService = class(TBaseService, IChartOfAccountService)
  private
  public
    class function Make: IChartOfAccountService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TChartOfAccountFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TChartOfAccountShowDTO;
    function StoreAndShow(AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
    function Validate(AInput: TChartOfAccountInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uChartOfAccount.ViewModel,
  uReq,
  uTrans;

const
  RESOURCE = '/ChartOfAccounts';

{ TChartOfAccountService }
function TChartOfAccountService.Delete(AId: Int64): Boolean;
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

function TChartOfAccountService.Index(AFilter: TChartOfAccountFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TChartOfAccountFilterDTO.Create;

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
  const LViewModel = TChartOfAccountViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.ChartOfAccount, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TChartOfAccountService.Make: IChartOfAccountService;
begin
  Result := TChartOfAccountService.Create;
end;

function TChartOfAccountService.Show(AId: Int64): TChartOfAccountShowDTO;
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
  Result := TChartOfAccountShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TChartOfAccountService.StoreAndShow(AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
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
  Result := TChartOfAccountShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TChartOfAccountService.UpdateAndShow(AId: Int64; AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
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
  Result := TChartOfAccountShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TChartOfAccountService.Validate(AInput: TChartOfAccountInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

end.

