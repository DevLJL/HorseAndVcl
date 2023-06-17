unit uTenant.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  Horse.Upload,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uTenant.Repository.Interfaces,
  uTenant.Persistence.UseCase.Interfaces,
  uTenant.Persistence.UseCase,
  uAppRest.Types,
  uTenant.Input.DTO,
  uTenant.Show.DTO,
  uTenant.Filter,
  uTenant.Filter.DTO;

Type
  [SwagPath('Companies', 'Empresas')]
  TTenantController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: ITenantRepository;
    FPersistence: ITenantPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TTenantFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TTenantIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TTenantShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TTenantInputDTO)]
    [SwagResponse(HTTP_CREATED, TTenantShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TTenantInputDTO)]
    [SwagResponse(HTTP_OK, TTenantShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TTenantController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uQueueEmail,
  uMyClaims,
  uEither;

constructor TTenantController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.Tenant;
  FPersistence := TTenantPersistenceUseCase.Make(FRepository);
end;

procedure TTenantController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TTenantController.Index;
begin
  // Obter FilterDTO
  const LFilter: SH<TTenantFilterDTO> = TTenantFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TTenantController.Show;
begin
  // Obter e Procurar ID
  const LID = StrInt(FReq.Params['id']);
  const LOutput = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput) of
    True:  Response(FRes).Data(LOutput);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TTenantController.Store;
begin
  // Obter DTO
  const LInput: SH<TTenantInputDTO> = TTenantInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult: Either<String, TTenantShowDTO> = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TTenantController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TTenantInputDTO> = TTenantInputDTO.FromReq(FReq);
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


