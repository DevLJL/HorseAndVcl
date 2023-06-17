unit uConsumption.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uConsumption.Repository.Interfaces,
  uConsumption.Persistence.UseCase.Interfaces,
  uConsumption.Persistence.UseCase,
  uAppRest.Types,
  uConsumption.Input.DTO,
  uConsumption.Show.DTO,
  uConsumption.Filter,
  uConsumption.Filter.DTO,
  uConsumptionSale.Filter.DTO;

Type
  [SwagPath('Consumption', 'Consumo')]
  TConsumptionController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IConsumptionRepository;
    FPersistence: IConsumptionPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TConsumptionFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TConsumptionIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagPOST('/IndexWithSale','Listagem de consumo com Vendas')]
    [SwagParamBody('body', TConsumptionSaleFilterDTO, false, '', false)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure IndexWithSale;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TConsumptionShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TConsumptionInputDTO)]
    [SwagResponse(HTTP_CREATED, TConsumptionShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TConsumptionInputDTO)]
    [SwagResponse(HTTP_OK, TConsumptionShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TConsumptionController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uMyClaims,
  uEither;

constructor TConsumptionController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.Consumption;
  FPersistence := TConsumptionPersistenceUseCase.Make(FRepository);
end;

procedure TConsumptionController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TConsumptionController.Index;
begin
  // Obter FilterDTO
  const LFilter: SH<TConsumptionFilterDTO> = TConsumptionFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TConsumptionController.IndexWithSale;
begin
  // Obter FilterDTO
  const LFilter: SH<TConsumptionSaleFilterDTO> = TConsumptionSaleFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Listar Consumo relacionado a vendas
  const LDataSet = FPersistence.IndexWithSale(LFilter).DataSet;

  // Retorno
  Response(FRes).Data(LDataSet);
end;

procedure TConsumptionController.Show;
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

procedure TConsumptionController.Store;
begin
  // Obter DTO
  const LInput: SH<TConsumptionInputDTO> = TConsumptionInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult: Either<String, TConsumptionShowDTO> = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TConsumptionController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TConsumptionInputDTO> = TConsumptionInputDTO.FromReq(FReq);
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


