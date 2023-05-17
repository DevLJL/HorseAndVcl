unit uStorageLocation.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uStorageLocation.Repository.Interfaces,
  uStorageLocation.Persistence.UseCase.Interfaces,
  uStorageLocation.Persistence.UseCase,
  uAppRest.Types,
  uStorageLocation.Input.DTO,
  uStorageLocation.Show.DTO,
  uStorageLocation.Filter,
  uStorageLocation.Filter.DTO;

Type
  [SwagPath('StorageLocations', 'Locais para armazenamento')]
  TStorageLocationController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IStorageLocationRepository;
    FPersistence: IStorageLocationPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TStorageLocationFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TStorageLocationIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TStorageLocationShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TStorageLocationInputDTO)]
    [SwagResponse(HTTP_CREATED, TStorageLocationShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TStorageLocationInputDTO)]
    [SwagResponse(HTTP_OK, TStorageLocationShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TStorageLocationController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils, uTrans;

constructor TStorageLocationController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq                := Req;
  FRes                := Res;
  FRepository         := TRepositoryFactory.Make.StorageLocation;
  FPersistence := TStorageLocationPersistenceUseCase.Make(FRepository);
end;

procedure TStorageLocationController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TStorageLocationController.Index;
begin
  // Obter FilterDTO
  const LInput: SH<TStorageLocationFilterDTO> = TStorageLocationFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LInput);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TStorageLocationController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);

  // Procurar por ID
  const LOutput: SH<TStorageLocationShowDTO> = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput.Value) of
    True:  Response(FRes).Data(LOutput.Value);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TStorageLocationController.Store;
begin
  // Obter DTO
  const LInput: SH<TStorageLocationInputDTO> = TStorageLocationInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput: SH<TStorageLocationShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TStorageLocationController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TStorageLocationInputDTO> = TStorageLocationInputDTO.FromReq(FReq);
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
  const LOutput: SH<TStorageLocationShowDTO> = LUseCaseResult.Right;
  Response(FRes).Data(LOutput);
end;

end.


