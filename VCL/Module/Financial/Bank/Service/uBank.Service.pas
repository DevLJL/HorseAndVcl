
unit uBank.Service;

interface

uses
  uBank.Input.DTO,
  uBank.Show.DTO,
  RESTRequest4D,
  uEither,
  uBank.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uBank.Service.Interfaces;

type
  TBankService = class(TBaseService, IBankService)
  private
  public
    class function Make: IBankService;
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBankFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBankShowDTO;
    function StoreAndShow(AInput: TBankInputDTO): Either<String, TBankShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBankInputDTO): Either<String, TBankShowDTO>;
    function Validate(AInput: TBankInputDTO; AState: TEntityState): String;
    function BeforeAndValidate(AInput: TBankInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  uBank.ViewModel,
  uReq,
  uTrans,
  uHlp;

const
  RESOURCE = '/Banks';

{ TBankService }
function TBankService.BeforeAndValidate(AInput: TBankInputDTO; AState: TEntityState): String;
begin
  AInput.code := StrZero(AInput.code,3);

  Result := Validate(AInput, AState);
end;

function TBankService.Delete(AId: Int64): Boolean;
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

function TBankService.Index(AFilter: TBankFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TBankFilterDTO.Create;

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
  const LViewModel = TBankViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Bank, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TBankService.Make: IBankService;
begin
  Result := TBankService.Create;
end;

function TBankService.Show(AId: Int64): TBankShowDTO;
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
  Result := TBankShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TBankService.StoreAndShow(AInput: TBankInputDTO): Either<String, TBankShowDTO>;
begin
  // Validar
  const LError = BeforeAndValidate(AInput, TEntityState.Store);
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
  Result := TBankShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TBankService.UpdateAndShow(AId: Int64; AInput: TBankInputDTO): Either<String, TBankShowDTO>;
begin
  // Validar
  const LError = BeforeAndValidate(AInput, TEntityState.Update);
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
  Result := TBankShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TBankService.Validate(AInput: TBankInputDTO; AState: TEntityState): String;
begin
  if AInput.name.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

end.

