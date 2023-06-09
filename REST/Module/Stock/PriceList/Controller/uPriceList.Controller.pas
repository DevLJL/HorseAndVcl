unit uPriceList.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uPriceList.Repository.Interfaces,
  uPriceList.Persistence.UseCase,
  uPriceList.Persistence.UseCase.Interfaces,
  uAppRest.Types,
  uPriceList.Input.DTO,
  uPriceList.Show.DTO,
  uPriceList.Filter,
  uPriceList.Filter.DTO;

Type
  [SwagPath('PriceLists', 'Listas de Pre�o')]
  TPriceListController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IPriceListRepository;
    FPersistence: IPriceListPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TPriceListFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TPriceListIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TPriceListShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TPriceListInputDTO)]
    [SwagResponse(HTTP_CREATED, TPriceListShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TPriceListInputDTO)]
    [SwagResponse(HTTP_OK, TPriceListShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TPriceListController }

uses
  uRepository.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uResponse,
  uMyClaims,
  uEither;

constructor TPriceListController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.PriceList;
  FPersistence := TPriceListPersistenceUseCase.Make(FRepository);
end;

procedure TPriceListController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TPriceListController.Index;
begin
  // Obter FilterDTO
  const LFilter: SH<TPriceListFilterDTO> = TPriceListFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TPriceListController.Show;
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

procedure TPriceListController.Store;
begin
  // Obter DTO
  const LInput: SH<TPriceListInputDTO> = TPriceListInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult: Either<String, TPriceListShowDTO> = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TPriceListController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TPriceListInputDTO> = TPriceListInputDTO.FromReq(FReq);
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
