unit uBrand.Service;

interface

uses
  uBrand.Input.DTO,
  uBrand.Show.DTO,
  RESTRequest4D,
  uEither,
  uBrand.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uBrand.Service.Interfaces;

type
  TBrandService = class(TBaseService, IBrandService)
  private
  public
    class function Make: IBrandService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBrandFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBrandShowDTO;
    function StoreAndShow(AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
    function Validate(AInput: TBrandInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uBrand.ViewModel,
  uReq,
  uTrans;

const
  RESOURCE = '/Brands';

{ TBrandService }
function TBrandService.Delete(AId: Int64): Boolean;
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

function TBrandService.Index(AFilter: TBrandFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TBrandFilterDTO.Create;

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
  const LViewModel = TBrandViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Brand, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TBrandService.Make: IBrandService;
begin
  Result := TBrandService.Create;
end;

function TBrandService.Show(AId: Int64): TBrandShowDTO;
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
  Result := TBrandShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TBrandService.StoreAndShow(AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
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
  Result := TBrandShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TBrandService.UpdateAndShow(AId: Int64; AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
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
  Result := TBrandShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TBrandService.Validate(AInput: TBrandInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

end.

