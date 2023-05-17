unit uSale.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uSale.Repository.Interfaces,
  uSale.Persistence.UseCase.Interfaces,
  uSale.Persistence.UseCase,
  uAppRest.Types,
  uSale.Input.DTO,
  uSale.Show.DTO,
  uSale.Filter,
  uSale.Filter.DTO,
  uSale.Types;

Type
  [SwagPath('Sales', 'Vendas')]
  TSaleController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: ISaleRepository;
    FPersistence: ISalePersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagGET('/{id}/DataForReport', 'Dados para emissão de comprovante no Front-End por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure DataForReport;

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPUT('/{id}/GenerateBilling/Operation/{operation_ord}/StationId/{station_id}', 'Faturar Venda')]
    [SwagParamPath('id', 'ID')]
    [SwagParamPath('operation_ord', 'Operação [0..2] (0-Revert, 1-Approve, 2-Cancel)')]
    [SwagParamPath('station_id', 'Estação (ID)')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure GenerateBilling;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TSaleFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TSaleIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}/PdfReport', 'Compr. de Venda em PDF por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure PdfReport;

    [SwagPOST('/{id}/PdfReport/SendByEmail', 'Enviar Compr. de Venda em PDF por E-mail')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure SendPdfReportByEmail;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TSaleShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TSaleInputDTO)]
    [SwagResponse(HTTP_CREATED, TSaleShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPOST('/StoreAndGenerateBilling/StationId/{station_id}', 'Incluir e Faturar Venda')]
    [SwagParamPath('station_id', 'Estação (ID)')]
    [SwagParamBody('body', TSaleInputDTO)]
    [SwagResponse(HTTP_CREATED, TSaleShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure StoreAndGenerateBilling;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TSaleInputDTO)]
    [SwagResponse(HTTP_OK, TSaleShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TSaleController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils,
  System.Classes,
  uTrans,
  uSale.GenerateBilling.UseCase,
  uSaleGenerateBillingRepositories,
  uOutPutFileStream,
  uSale.PdfReport.UseCase,
  XSuperObject,
  uSale.SendPdfReportByEmail.UseCase;

constructor TSaleController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.Sale;
  FPersistence := TSalePersistenceUseCase.Make(FRepository);
end;

procedure TSaleController.DataForReport;
begin
  // Obter ID e Conteúdo para relatório
  const LID = StrInt(FReq.Params['id']);
  const LData = FRepository.DataForReport(LID);

  // Retornar conteúdo para relatório
  const OutPut = SO(LData.Sale.ToJson);
  OutPut.A['sale_items']    := SA(LData.SaleItems.ToJsonArray);
  OutPut.A['sale_payments'] := SA(LData.SalePayments.ToJsonArray);
  Response(FRes).Data(OutPut);
end;

procedure TSaleController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TSaleController.GenerateBilling;
begin
  const LID        = StrInt(FReq.Params['id']);
  const LStationId = StrInt(FReq.Params['station_id']);
  const LOperation = TSaleGenerateBillingOperation(StrInt(FReq.Params['operation_ord']));

  // Faturar/Estornar
  const LRepositories = TSaleGenerateBillingRepositories.Make(FRepository.Conn);
  const LSaleShowDTO: SH<TSaleShowDTO> = TSaleGenerateBillingUseCase.Make(
    LRepositories,
    LID,
    LStationId,
    LOperation
  ).Execute;

  // Retornar Venda
  Response(FRes).Data(LSaleShowDTO);
end;

procedure TSaleController.Index;
begin
  // Obter FilterDTO
  const LInput: SH<TSaleFilterDTO> = TSaleFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LInput);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TSaleController.PdfReport;
begin
  // Obter ID e Stream de Relatório
  const LID = StrInt(FReq.Params['id']);
  const LStreamFile = TSalePdfReportUseCase.Make(FRepository).Execute(LID);

  // Retornar Stream
  FRes.SendFile(LStreamFile.Value, LStreamFile.FilePath, LStreamFile.ContentType);
end;

procedure TSaleController.SendPdfReportByEmail;
begin
  // Obter ID da Venda e registrar envio de e-mail para Task
  const LID = StrInt(FReq.Params['id']);
  TSaleSendPdfReportByEmailUseCase.Make(
    FRepository,
    TRepositoryFactory.Make(FRepository.Conn).QueueEmail
  ).Execute(LID);

  // Não retornar conteúdo se tudo der certo
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TSaleController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);

  // Procurar por ID
  const LOutput: SH<TSaleShowDTO> = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput.Value) of
    True:  Response(FRes).Data(LOutput.Value);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TSaleController.Store;
begin
  // Obter DTO
  const LInput: SH<TSaleInputDTO> = TSaleInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput: SH<TSaleShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TSaleController.StoreAndGenerateBilling;
begin
  // Obter DTO
  const LInput: SH<TSaleInputDTO> = TSaleInputDTO.FromReq(FReq);
  const LStationId = StrInt(FReq.Params['station_id']);
  SwaggerValidator.Validate(LInput);

  // Incluir e Faturar
  const LRepositories = TSaleGenerateBillingRepositories.Make(FRepository.Conn);
  const LOutput: SH<TSaleShowDTO> = TSaleGenerateBillingUseCase.Make(
    LRepositories,
    LInput,
    LStationId
  ).Execute;

  // Retornar Venda
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TSaleController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TSaleInputDTO> = TSaleInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Atualizar
  const LUseCaseResult = FPersistence.UpdateAndShow(LID, LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Verificar se registro foi atualizado
  if not Assigned(LUseCaseResult.Right) then
  begin
    Response(FRes).Error(True).Message(Trans.RecordNotFoundWithId(LID.ToString));
    Exit;
  end;

  // Retorno
  const LOutput: SH<TSaleShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput);
end;

end.


