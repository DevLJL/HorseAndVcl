unit uPosPrinter.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uPosPrinter.Repository.Interfaces,
  uPosPrinter.Persistence.UseCase,
  uPosPrinter.Persistence.UseCase.Interfaces,
  uAppRest.Types,
  uPosPrinter.Input.DTO,
  uPosPrinter.Show.DTO,
  uPosPrinter.Filter,
  uPosPrinter.Filter.DTO;

Type

  [SwagPath('PosPrinters', 'Impressoras POS(Point Of Sale)')]
  TPosPrinterController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IPosPrinterRepository;
    FPersistence: IPosPrinterPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index', 'Listagem de registros')]
    [SwagParamBody('body', TPosPrinterFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TPosPrinterIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagPOST('/{id}/SendTestPrintToQueue', 'Enviar Impressão de Teste para Fila')]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure SendTestPrintToQueue;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TPosPrinterShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TPosPrinterInputDTO)]
    [SwagResponse(HTTP_CREATED, TPosPrinterShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TPosPrinterInputDTO)]
    [SwagResponse(HTTP_OK, TPosPrinterShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TPosPrinterController }

uses
  uRepository.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uResponse,
  uMyClaims,
  XSuperObject,
  uPosPrinter.SendPrintTestToQueue.UseCase,
  uEither;

constructor TPosPrinterController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.PosPrinter;
  FPersistence := TPosPrinterPersistenceUseCase.Make(FRepository);
end;

procedure TPosPrinterController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);

  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TPosPrinterController.Index;
begin
  // Obter FilterDTO
  const LFilter: SH<TPosPrinterFilterDTO> = TPosPrinterFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TPosPrinterController.SendTestPrintToQueue;
begin
  const LID      = StrInt(FReq.Params['id']);
  const LContent = SO(FReq.Body).S['content'];

  // Imprimir Teste
  TPosPrinterSendPrintTestToQueueUseCase
    .Make(FRepository)
    .Execute(LID, LContent);

  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TPosPrinterController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);
  const LOutput = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput) of
    True:  Response(FRes).Data(LOutput);
    false: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TPosPrinterController.Store;
begin
  // Obter DTO
  const LInput: SH<TPosPrinterInputDTO> = TPosPrinterInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult: Either<String, TPosPrinterShowDTO> = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TPosPrinterController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TPosPrinterInputDTO> = TPosPrinterInputDTO.FromReq(FReq);
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
  const LOutput = LUseCaseResult.Right;
  Response(FRes).Data(LOutput);
end;

end.
