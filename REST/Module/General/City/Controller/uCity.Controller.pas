unit uCity.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uCity.Repository.Interfaces,
  uCity.Persistence.UseCase.Interfaces,
  uCity.Persistence.UseCase,
  uAppRest.Types,
  uCity.Input.DTO,
  uCity.Show.DTO,
  uCity.Filter,
  uCity.Filter.DTO;

Type
  [SwagPath('Cities', 'Cidades')]
  TCityController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: ICityRepository;
    FPersistence: ICityPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TCityFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TCityIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TCityShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TCityInputDTO)]
    [SwagResponse(HTTP_CREATED, TCityShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TCityInputDTO)]
    [SwagResponse(HTTP_OK, TCityShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TCityController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils, uTrans;

constructor TCityController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq                := Req;
  FRes                := Res;
  FRepository         := TRepositoryFactory.Make.City;
  FPersistence := TCityPersistenceUseCase.Make(FRepository);
end;

procedure TCityController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TCityController.Index;
begin
  // Obter FilterDTO
  const LInput: SH<TCityFilterDTO> = TCityFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LInput);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TCityController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);

  // Procurar por ID
  const LOutput: SH<TCityShowDTO> = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput.Value) of
    True:  Response(FRes).Data(LOutput.Value);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TCityController.Store;
begin
  // Obter DTO
  const LInput: SH<TCityInputDTO> = TCityInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput: SH<TCityShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TCityController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TCityInputDTO> = TCityInputDTO.FromReq(FReq);
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
  const LOutput: SH<TCityShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput);
end;

end.


