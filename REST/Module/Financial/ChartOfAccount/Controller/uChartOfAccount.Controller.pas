unit uChartOfAccount.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uChartOfAccount.Repository.Interfaces,
  uChartOfAccount.Persistence.UseCase.Interfaces,
  uChartOfAccount.Persistence.UseCase,
  uAppRest.Types,
  uChartOfAccount.Input.DTO,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.Filter,
  uChartOfAccount.Filter.DTO;

Type
  [SwagPath('ChartOfAccounts', 'Planos de Conta')]
  TChartOfAccountController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IChartOfAccountRepository;
    FPersistence: IChartOfAccountPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TChartOfAccountFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TChartOfAccountIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TChartOfAccountShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TChartOfAccountInputDTO)]
    [SwagResponse(HTTP_CREATED, TChartOfAccountShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TChartOfAccountInputDTO)]
    [SwagResponse(HTTP_OK, TChartOfAccountShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TChartOfAccountController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils, uTrans;

constructor TChartOfAccountController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq                := Req;
  FRes                := Res;
  FRepository         := TRepositoryFactory.Make.ChartOfAccount;
  FPersistence := TChartOfAccountPersistenceUseCase.Make(FRepository);
end;

procedure TChartOfAccountController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TChartOfAccountController.Index;
begin
  // Obter FilterDTO
  const LInput: SH<TChartOfAccountFilterDTO> = TChartOfAccountFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LInput);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TChartOfAccountController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);

  // Procurar por ID
  const LOutput: SH<TChartOfAccountShowDTO> = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput.Value) of
    True:  Response(FRes).Data(LOutput.Value);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TChartOfAccountController.Store;
begin
  // Obter DTO
  const LInput: SH<TChartOfAccountInputDTO> = TChartOfAccountInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput: SH<TChartOfAccountShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TChartOfAccountController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TChartOfAccountInputDTO> = TChartOfAccountInputDTO.FromReq(FReq);
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
  const LOutput: SH<TChartOfAccountShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput);
end;

end.


