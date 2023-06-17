unit uPayment.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uPayment.Repository.Interfaces,
  uPayment.Persistence.UseCase.Interfaces,
  uPayment.Persistence.UseCase,
  uAppRest.Types,
  uPayment.Input.DTO,
  uPayment.Show.DTO,
  uPayment.Filter,
  uPayment.Filter.DTO;

Type
  [SwagPath('Payments', 'Pagamentos')]
  TPaymentController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IPaymentRepository;
    FPersistence: IPaymentPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TPaymentFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TPaymentIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TPaymentShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TPaymentInputDTO)]
    [SwagResponse(HTTP_CREATED, TPaymentShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TPaymentInputDTO)]
    [SwagResponse(HTTP_OK, TPaymentShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TPaymentController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uCache,
  XSuperObject,
  uMyClaims,
  uEither;

const
  LCACHE_MS_TO_EXPIRE     = 3600000; {Expira em 60 minutos}
  LCACHE_REQ_BODY_KEY     = 'TPaymentController.Index.LastReqBody';
  LCACHE_INDEX_RESULT_KEY = 'TPaymentController.Index.LastIndexResult';

constructor TPaymentController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.Payment;
  FPersistence := TPaymentPersistenceUseCase.Make(FRepository);
end;

procedure TPaymentController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);

  // Limpar Cache
  Cache.RemoveValue(LCACHE_REQ_BODY_KEY);
end;

procedure TPaymentController.Index;
var
  LReqBodyValue: String;
  LIndexResultValue: String;
begin
  // Retornar Cache quando existir
  Cache.GetValue(LCACHE_REQ_BODY_KEY, LReqBodyValue);
  if (LReqBodyValue = FReq.Body) then
  begin
    Cache.GetValue(LCACHE_INDEX_RESULT_KEY, LIndexResultValue);
    Response(FRes).Data(SO(LIndexResultValue));
    Exit;
  end;

  // Obter FilterDTO
  const LFilter: SH<TPaymentFilterDTO> = TPaymentFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);
  Response(FRes).Data(LIndexResult.ToSuperObject);

  // Armazenar Cache
  Cache.SetValue(LCACHE_REQ_BODY_KEY, FReq.Body, LCACHE_MS_TO_EXPIRE);
  Cache.SetValue(LCACHE_INDEX_RESULT_KEY, LIndexResult.ToSuperObject.AsJSON, LCACHE_MS_TO_EXPIRE);
end;

procedure TPaymentController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);
  const LOutput = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput) of
    True:  Response(FRes).Data(LOutput);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TPaymentController.Store;
begin
  // Obter DTO
  const LInput: SH<TPaymentInputDTO> = TPaymentInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult: Either<String, TPaymentShowDTO> = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);

  // Limpar Cache
  Cache.RemoveValue(LCACHE_REQ_BODY_KEY);
end;

procedure TPaymentController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TPaymentInputDTO> = TPaymentInputDTO.FromReq(FReq);
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

  // Limpar Cache
  Cache.RemoveValue(LCACHE_REQ_BODY_KEY);
end;

end.


