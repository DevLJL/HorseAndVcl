unit uGlobalConfig.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uGlobalConfig.Repository.Interfaces,
  uGlobalConfig.Persistence.UseCase,
  uGlobalConfig.Persistence.UseCase.Interfaces,
  uAppRest.Types,
  uGlobalConfig.Input.DTO,
  uGlobalConfig.Show.DTO,
  uGlobalConfig.Filter,
  uGlobalConfig.Filter.DTO;

Type
  [SwagPath('GlobalConfig', 'Config. Global')]
  TGlobalConfigController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IGlobalConfigRepository;
    FPersistence: IGlobalConfigPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TGlobalConfigFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TGlobalConfigIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TGlobalConfigShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TGlobalConfigInputDTO)]
    [SwagResponse(HTTP_OK, TGlobalConfigShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TGlobalConfigController }

uses
  uRepository.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uResponse,
  uMyClaims,
  uEither;

constructor TGlobalConfigController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.GlobalConfig;
  FPersistence := TGlobalConfigPersistenceUseCase.Make(FRepository);
end;

procedure TGlobalConfigController.Index;
begin
  // Obter FilterDTO
  const LFilter: SH<TGlobalConfigFilterDTO> = TGlobalConfigFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TGlobalConfigController.Show;
begin
  // Obter e Procurar por ID
  const LID = StrInt(FReq.Params['id']);
  const LOutput = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput) of
    True:  Response(FRes).Data(LOutput);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TGlobalConfigController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TGlobalConfigInputDTO> = TGlobalConfigInputDTO.FromReq(FReq);
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
