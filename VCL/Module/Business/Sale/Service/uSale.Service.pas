unit uSale.Service;

interface

uses
  uSale.Input.DTO,
  uSale.Show.DTO,
  RESTRequest4D,
  uEither,
  uSale.Filter.DTO,
  uIndexResult,
  uBase.Service,
  uAppVcl.Types,
  uSale.Service.Interfaces,
  uSale.Types;

type
  TSaleService = class(TBaseService, ISaleService)
  private
  public
    class function Make: ISaleService;
    function Delete(AId: Int64): Boolean;
    function GenerateBilling(AId: Int64; AOperation: TSaleGenerateBillingOperation): Either<String, TSaleShowDTO>;
    function Index(AFilter: TSaleFilterDTO = nil): Either<String, IIndexResult>;
    function PdfReport(AId: Int64): ISaleService;
    function PosTicket(AId, ACopies: Int64): ISaleService;
    function SendPdfReport(AId: Int64): Boolean;
    function Show(AId: Int64): TSaleShowDTO;
    function StoreAndGenerateBilling(AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
    function StoreAndShow(AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TSaleInputDTO; AReturnShowDTO: Boolean = True): Either<String, TSaleShowDTO>;
    function Validate(AInput: TSaleInputDTO; AState: TEntityState): String;
  end;

implementation

uses
  XSuperObject,
  System.SysUtils,
  System.Classes,
  uSale.ViewModel,
  uReq,
  uTrans,
  uHlp,
  uEnv.Vcl;

const
  RESOURCE = '/Sales';

{ TSaleService }
function TSaleService.Delete(AId: Int64): Boolean;
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

function TSaleService.GenerateBilling(AId: Int64; AOperation: TSaleGenerateBillingOperation): Either<String, TSaleShowDTO>;
begin
  // Efetuar Requisição
  const LEndPoint = Format(RESOURCE+'/%s/GenerateBilling/Operation/%s/StationId/%s', [
    AId.ToString,
    Ord(AOperation).ToString,
    ENV_VCL.StationId.ToString
  ]);
  const LResponse = Req(LEndPoint).Execute(TReqType.Put);
  if not (LResponse.StatusCode = 200) then
  begin
    case (Pos('"message":', LResponse.Content) > 0) of
      True:  Result := SO(LResponse.Content).S['message'];
      False: Result := LResponse.Content;
    end;
    Exit;
  end;

  // Retornar registro atualizado
  Result := TSaleShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TSaleService.Index(AFilter: TSaleFilterDTO): Either<String, IIndexResult>;
begin
  // Criar filtro se não informado
  const LInformedFilter = Assigned(AFilter);
  if not LInformedFilter then
    AFilter := TSaleFilterDTO.Create;

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
  const LViewModel = TSaleViewModel.Make;
  const LIndexResult = TIndexResult.FromResponse(LResponse.Content, LViewModel.Sale, LResponse.ETag);
  LViewModel.SetEvents;
  Result := LIndexResult;
end;

class function TSaleService.Make: ISaleService;
begin
  Result := TSaleService.Create;
end;

function TSaleService.PdfReport(AId: Int64): ISaleService;
begin
  Result := Self;

  // Efetuar Requisição
  const LEndPoint = RESOURCE+'/'+AId.ToString+'/PdfReport';
  const LResponse = Req(LEndPoint).Execute;
  if not (LResponse.StatusCode = 200) then
  begin
    case (Pos('"message":', LResponse.Content) > 0) of
      True:  raise Exception.Create(SO(LResponse.Content).S['message']);
      False: raise Exception.Create(LResponse.Content);
    end;
  end;

  // Abrir Arquivo Stream
  LResponse.OpenStreamFile;
end;

function TSaleService.PosTicket(AId, ACopies: Int64): ISaleService;
begin
  Result := Self;
  if (ENV_VCL.PosPrinterIdDefault <= 0) then
    raise Exception.Create('Nenhuma impressora POS setada como padrão em .ENV');

  // Efetuar Requisição
  const LEndPoint = Format('%s/%d/Ticket/PosPrinter/%d/Copies/%d/SendToQueue', [
    RESOURCE,
    AId,
    ENV_VCL.PosPrinterIdDefault,
    ACopies
  ]);
  const LResponse = Req(LEndPoint, EmptyStr, ENV_VCL.PosPrinterURI).Execute(TReqType.Post);
  if not (LResponse.StatusCode = 204) then
  begin
    case (Pos('"message":', LResponse.Content) > 0) of
      True:  raise Exception.Create(SO(LResponse.Content).S['message']);
      False: raise Exception.Create(LResponse.Content);
    end;
  end;
end;

function TSaleService.SendPdfReport(AId: Int64): Boolean;
begin
  // Efetuar Requisição /Sales/13/PdfReport/SendByEmail
  const LEndPoint = RESOURCE+'/'+AId.ToString+'/PdfReport/SendByEmail';
  const LResponse = Req(LEndPoint).Execute(TReqType.Post);
  if not (LResponse.StatusCode = 204) then
  begin
    case (Pos('"message":', LResponse.Content) > 0) of
      True:  raise Exception.Create(SO(LResponse.Content).S['message']);
      False: raise Exception.Create(LResponse.Content);
    end;
  end;
  Result := True;
end;

function TSaleService.Show(AId: Int64): TSaleShowDTO;
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
  Result := TSaleShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TSaleService.StoreAndGenerateBilling(AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
begin
  // Validar
  const LError = Validate(AInput, TEntityState.Store);
  if not LError.Trim.IsEmpty then
  begin
    Result := LError;
    Exit;
  end;

  // Efetuar Requisição
  const LEndPoint = RESOURCE+'/StoreAndGenerateBilling/StationId/'+ENV_VCL.StationId.ToString;
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
  Result := TSaleShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TSaleService.StoreAndShow(AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
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
  Result := TSaleShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
end;

function TSaleService.UpdateAndShow(AId: Int64; AInput: TSaleInputDTO; AReturnShowDTO: Boolean): Either<String, TSaleShowDTO>;
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
  case AReturnShowDTO of
    True:  Result := TSaleShowDTO.FromJSON(SO(LResponse.Content).O['data'].AsJSON);
    False: Result := Nil;
  end;
end;

function TSaleService.Validate(AInput: TSaleInputDTO; AState: TEntityState): String;
begin
  if (AInput.seller_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Atendente') + #13;
end;

end.

