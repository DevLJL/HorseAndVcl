unit uCompany.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  Horse.Upload,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uCompany.Repository.Interfaces,
  uCompany.Persistence.UseCase.Interfaces,
  uCompany.Persistence.UseCase,
  uAppRest.Types,
  uCompany.Input.DTO,
  uCompany.Show.DTO,
  uCompany.Filter,
  uCompany.Filter.DTO;

Type
  [SwagPath('Companies', 'Empresas')]
  TCompanyController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: ICompanyRepository;
    FPersistence: ICompanyPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TCompanyFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TCompanyIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TCompanyShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TCompanyInputDTO)]
    [SwagResponse(HTTP_CREATED, TCompanyShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TCompanyInputDTO)]
    [SwagResponse(HTTP_OK, TCompanyShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TCompanyController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uQueueEmail;

constructor TCompanyController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.Company;
  FPersistence := TCompanyPersistenceUseCase.Make(FRepository);
end;

procedure TCompanyController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TCompanyController.Index;
begin
  // Obter FilterDTO
  const LInput: SH<TCompanyFilterDTO> = TCompanyFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LInput);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TCompanyController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);

  // Procurar por ID
  const LOutput: SH<TCompanyShowDTO> = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput.Value) of
    True:  Response(FRes).Data(LOutput.Value);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TCompanyController.Store;
begin
  // Obter DTO
  const LInput: SH<TCompanyInputDTO> = TCompanyInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput: SH<TCompanyShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TCompanyController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TCompanyInputDTO> = TCompanyInputDTO.FromReq(FReq);
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
  const LOutput: SH<TCompanyShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput);
end;

end.


