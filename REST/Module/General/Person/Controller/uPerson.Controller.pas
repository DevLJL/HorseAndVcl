unit uPerson.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uPerson.Repository.Interfaces,
  uPerson.Persistence.UseCase.Interfaces,
  uPerson.Persistence.UseCase,
  uAppRest.Types,
  uPerson.Input.DTO,
  uPerson.Show.DTO,
  uPerson.Filter,
  uPerson.Filter.DTO;

Type
  [SwagPath('Persons', 'Pessoas')]
  TPersonController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IPersonRepository;
    FPersistence: IPersonPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TPersonFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TPersonIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TPersonShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TPersonInputDTO)]
    [SwagResponse(HTTP_CREATED, TPersonShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TPersonInputDTO)]
    [SwagResponse(HTTP_OK, TPersonShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TPersonController }

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
  LCACHE_MS_TO_EXPIRE     = 900000; {Expira em 15 minutos}
  LCACHE_REQ_BODY_KEY     = 'TPersonController.Index.LastReqBody';
  LCACHE_INDEX_RESULT_KEY = 'TPersonController.Index.LastIndexResult';

constructor TPersonController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.Person;
  FPersistence := TPersonPersistenceUseCase.Make(FRepository);
end;

procedure TPersonController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);

  // Limpar Cache
  Cache.RemoveValue(LCACHE_REQ_BODY_KEY);
end;

procedure TPersonController.Index;
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
  const LFilter: SH<TPersonFilterDTO> = TPersonFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);
  Response(FRes).Data(LIndexResult.ToSuperObject);

  // Armazenar Cache
  Cache.SetValue(LCACHE_REQ_BODY_KEY, FReq.Body, LCACHE_MS_TO_EXPIRE);
  Cache.SetValue(LCACHE_INDEX_RESULT_KEY, LIndexResult.ToSuperObject.AsJSON, LCACHE_MS_TO_EXPIRE);
end;

procedure TPersonController.Show;
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

procedure TPersonController.Store;
begin
  // Obter DTO
  const LInput: SH<TPersonInputDTO> = TPersonInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult: Either<String, TPersonShowDTO> = FPersistence.StoreAndShow(LInput);
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

procedure TPersonController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TPersonInputDTO> = TPersonInputDTO.FromReq(FReq);
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


