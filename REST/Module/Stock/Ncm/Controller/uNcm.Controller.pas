unit uNcm.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uNcm.Repository.Interfaces,
  uNcm.Persistence.UseCase.Interfaces,
  uNcm.Persistence.UseCase,
  uAppRest.Types,
  uNcm.Input.DTO,
  uNcm.Show.DTO,
  uNcm.Filter,
  uNcm.Filter.DTO;

Type
  [SwagPath('Ncms', 'NCMs')]
  TNcmController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: INcmRepository;
    FPersistence: INcmPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TNcmFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TNcmIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TNcmShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TNcmInputDTO)]
    [SwagResponse(HTTP_CREATED, TNcmShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TNcmInputDTO)]
    [SwagResponse(HTTP_OK, TNcmShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TNcmController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uMyClaims,
  uEither;

constructor TNcmController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.Ncm;
  FPersistence := TNcmPersistenceUseCase.Make(FRepository);
end;

procedure TNcmController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TNcmController.Index;
begin
  // Obter FilterDTO
  const LFilter: SH<TNcmFilterDTO> = TNcmFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TNcmController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);

  // Procurar por ID
  const LOutput = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput) of
    True:  Response(FRes).Data(LOutput);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TNcmController.Store;
begin
  // Obter DTO
  const LInput: SH<TNcmInputDTO> = TNcmInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult: Either<String, TNcmShowDTO> = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TNcmController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TNcmInputDTO> = TNcmInputDTO.FromReq(FReq);
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


