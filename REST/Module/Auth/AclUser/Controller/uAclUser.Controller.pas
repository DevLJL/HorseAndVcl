unit uAclUser.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uAclUser.Repository.Interfaces,
  uAclUser.Persistence.UseCase.Interfaces,
  uAclUser.Persistence.UseCase,
  uAppRest.Types,
  uAclUser.Input.DTO,
  uAclUser.Show.DTO,
  uAclUser.Filter,
  uAclUser.Filter.DTO,
  uAclUser.Login.DTO,
  uAclUser.Auth.UseCase;

Type
  [SwagPath('AclUsers', 'Usuários')]
  TAclUserController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IAclUserRepository;
    FPersistence: IAclUserPersistenceUseCase;
    FAuthUseCase: IAclUserAuthUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TAclUserFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TAclUserIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TAclUserShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TAclUserInputDTO)]
    [SwagResponse(HTTP_CREATED, TAclUserShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TAclUserInputDTO)]
    [SwagResponse(HTTP_OK, TAclUserShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;

    [SwagPOST('/Login', 'Login', true)]
    [SwagParamBody('body', TAclUserLoginDTO)]
    [SwagResponse(HTTP_CREATED, TAclUserShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Login;
  end;

implementation

{ TAclUserController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils,
  uTrans;

constructor TAclUserController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.AclUser;
  FPersistence := TAclUserPersistenceUseCase.Make(FRepository);
  FAuthUseCase := TAclUserAuthUseCase.Make(FRepository);
end;

procedure TAclUserController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TAclUserController.Index;
begin
  // Obter FilterDTO
  const LInput: SH<TAclUserFilterDTO> = TAclUserFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LInput);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TAclUserController.Login;
begin
  // Obter DTO
  const LInput: SH<TAclUserLoginDTO> = TAclUserLoginDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Efetuar login
  const LResult: SH<TAclUserShowDTO> = TAclUserAuthUseCase
    .Make  (FRepository)
    .Login (LInput);

  // Retorno
  Response(FRes).Data(LResult);
end;

procedure TAclUserController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);

  // Procurar por ID
  const LOutput: SH<TAclUserShowDTO> = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput.Value) of
    True:  Response(FRes).Data(LOutput.Value);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TAclUserController.Store;
begin
  // Obter DTO
  const LInput: SH<TAclUserInputDTO> = TAclUserInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput: SH<TAclUserShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TAclUserController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TAclUserInputDTO> = TAclUserInputDTO.FromReq(FReq);
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
  const LOutput: SH<TAclUserShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput);
end;

end.


