unit uProduct.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uProduct.Repository.Interfaces,
  uProduct.Persistence.UseCase.Interfaces,
  uProduct.Persistence.UseCase,
  uAppRest.Types,
  uProduct.Input.DTO,
  uProduct.Show.DTO,
  uProduct.Filter,
  uProduct.Filter.DTO;

Type
  [SwagPath('Products', 'Produtos')]
  TProductController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IProductRepository;
    FPersistence: IProductPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TProductFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TProductIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TProductShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagGET('/ShowByEanOrSkuCode/{value}', 'Localizar por Ean/SkuCode')]
    [SwagParamPath('value', 'Ean/SkuCode')]
    [SwagResponse(HTTP_OK, TProductShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure ShowByEanOrSkuCode;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TProductInputDTO)]
    [SwagResponse(HTTP_CREATED, TProductShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TProductInputDTO)]
    [SwagResponse(HTTP_OK, TProductShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TProductController }

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

constructor TProductController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.Product;
  FPersistence := TProductPersistenceUseCase.Make(FRepository);
end;

procedure TProductController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);

  // Limpar Cache
  Cache.RemoveValue(CACHE_PRODUCT_REQ_BODY_KEY);
end;

procedure TProductController.Index;
var
  LReqBodyValue: String;
  LIndexResultValue: String;
begin
  // Retornar Cache quando existir
  Cache.GetValue(CACHE_PRODUCT_REQ_BODY_KEY, LReqBodyValue);
  if (LReqBodyValue = FReq.Body) then
  begin
    Cache.GetValue(CACHE_PRODUCT_INDEX_RESULT_KEY, LIndexResultValue);
    Response(FRes).Data(SO(LIndexResultValue));
    Exit;
  end;

  // Obter FilterDTO
  const LFilter: SH<TProductFilterDTO> = TProductFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);
  Response(FRes).Data(LIndexResult.ToSuperObject);

  // Armazenar Cache
  Cache.SetValue(CACHE_PRODUCT_REQ_BODY_KEY, FReq.Body, CACHE_PRODUCT_MS_TO_EXPIRE);
  Cache.SetValue(CACHE_PRODUCT_INDEX_RESULT_KEY, LIndexResult.ToSuperObject.AsJSON, CACHE_PRODUCT_MS_TO_EXPIRE);
end;

procedure TProductController.Show;
begin
  // Obter e Procurar por ID
  const LID = StrInt(FReq.Params['id']);
  const LOutput = FPersistence.Show(LID);

  // N�o encontrado
  if not Assigned(LOutput) then
  begin
    Response(FRes).StatusCode(HTTP_NOT_FOUND);
    Exit;
  end;

  // Retornar
  Response(FRes).Data(LOutput, False);
end;

procedure TProductController.ShowByEanOrSkuCode;
begin
  // Obter e Procurar por EanCode/SkuCode
  const LValue = FReq.Params['value'];
  const LOutput = FPersistence.ShowByEanOrSkuCode(LValue);

  // N�o encontrado
  if not Assigned(LOutput) then
  begin
    Response(FRes).StatusCode(HTTP_NOT_FOUND);
    Exit;
  end;

  // Retornar
  Response(FRes).Data(LOutput, False);
end;

procedure TProductController.Store;
begin
  // Obter DTO
  const LInput: SH<TProductInputDTO> = TProductInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult: Either<String, TProductShowDTO> = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);

  // Limpar Cache
  Cache.RemoveValue(CACHE_PRODUCT_REQ_BODY_KEY);
end;

procedure TProductController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TProductInputDTO> = TProductInputDTO.FromReq(FReq);
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
  Cache.RemoveValue(CACHE_PRODUCT_REQ_BODY_KEY);
end;

end.


