unit uQueueEmail.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uQueueEmail.Repository.Interfaces,
  uQueueEmail.Persistence.UseCase,
  uQueueEmail.Persistence.UseCase.Interfaces,
  uAppRest.Types,
  uQueueEmail.Input.DTO,
  uQueueEmail.Show.DTO,
  uQueueEmail.Filter,
  uQueueEmail.Filter.DTO;

Type
  [SwagPath('QueueEmails', 'Envio de E-mails')]
  TQueueEmailController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IQueueEmailRepository;
    FPersistence: IQueueEmailPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TQueueEmailFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TQueueEmailIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TQueueEmailShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TQueueEmailInputDTO)]
    [SwagResponse(HTTP_CREATED, TQueueEmailShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TQueueEmailInputDTO)]
    [SwagResponse(HTTP_OK, TQueueEmailShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TQueueEmailController }

uses
  uRepository.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uResponse;

constructor TQueueEmailController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.QueueEmail;
  FPersistence := TQueueEmailPersistenceUseCase.Make(FRepository);
end;

procedure TQueueEmailController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TQueueEmailController.Index;
begin
  // Obter FilterDTO
  const LInput: SH<TQueueEmailFilterDTO> = TQueueEmailFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LInput);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TQueueEmailController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);

  // Procurar por ID
  const LOutput: SH<TQueueEmailShowDTO> = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput.Value) of
    True:  Response(FRes).Data(LOutput.Value);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TQueueEmailController.Store;
begin
  // Obter DTO
  const LInput: SH<TQueueEmailInputDTO> = TQueueEmailInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput: SH<TQueueEmailShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TQueueEmailController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TQueueEmailInputDTO> = TQueueEmailInputDTO.FromReq(FReq);
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
  const LOutput: SH<TQueueEmailShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput);
end;

end.
