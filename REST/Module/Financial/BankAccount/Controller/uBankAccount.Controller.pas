unit uBankAccount.Controller;

interface

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Registry,
  GBSwagger.Path.Attributes,
  GBSwagger.Validator.Interfaces,
  uBankAccount.Repository.Interfaces,
  uBankAccount.Persistence.UseCase.Interfaces,
  uBankAccount.Persistence.UseCase,
  uAppRest.Types,
  uBankAccount.Input.DTO,
  uBankAccount.Show.DTO,
  uBankAccount.Filter,
  uBankAccount.Filter.DTO;

Type
  [SwagPath('BankAccounts', 'Contas Bancárias')]
  TBankAccountController = class
  private
    FReq: THorseRequest;
    FRes: THorseResponse;
    FRepository: IBankAccountRepository;
    FPersistence: IBankAccountPersistenceUseCase;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);

    [SwagDELETE('/{id}', 'Deletar')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_NO_CONTENT)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Delete;

    [SwagPOST('/Index','Listagem de registros')]
    [SwagParamBody('body', TBankAccountFilterDTO, false, '', false)]
    [SwagResponse(HTTP_OK, TBankAccountIndexResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Index;

    [SwagGET('/{id}', 'Localizar por ID')]
    [SwagParamPath('id', 'ID')]
    [SwagResponse(HTTP_OK, TBankAccountShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Show;

    [SwagPOST('/', 'Incluir')]
    [SwagParamBody('body', TBankAccountInputDTO)]
    [SwagResponse(HTTP_CREATED, TBankAccountShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Store;

    [SwagPUT('/{id}', 'Atualizar')]
    [SwagParamPath('id', 'ID')]
    [SwagParamBody('body', TBankAccountInputDTO)]
    [SwagResponse(HTTP_OK, TBankAccountShowResponseDTO)]
    [SwagResponse(HTTP_BAD_REQUEST)]
    [SwagResponse(HTTP_INTERNAL_SERVER_ERROR)]
    procedure Update;
  end;

implementation

{ TBankAccountController }

uses
  uRepository.Factory,
  uHlp,
  uResponse,
  uSmartPointer,
  System.SysUtils,
  uTrans,
  uMyClaims,
  uEither;

constructor TBankAccountController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FReq         := Req;
  FRes         := Res;
  FRepository  := TRepositoryFactory.Make.BankAccount;
  FPersistence := TBankAccountPersistenceUseCase.Make(FRepository);
end;

procedure TBankAccountController.Delete;
begin
  const LID = StrInt(FReq.Params['id']);
  
  FPersistence.Delete(LID);
  Response(FRes).StatusCode(HTTP_NO_CONTENT);
end;

procedure TBankAccountController.Index;
begin
  // Obter FilterDTO
  const LFilter: SH<TBankAccountFilterDTO> = TBankAccountFilterDTO.FromReq(FReq);
  SwaggerValidator.Validate(LFilter);

  // Efetuar Listagem
  const LIndexResult = FPersistence.Index(LFilter);

  // Retorno
  Response(FRes).Data(LIndexResult.ToSuperObject);
end;

procedure TBankAccountController.Show;
begin
  // Obter ID
  const LID = StrInt(FReq.Params['id']);
  const LOutput = FPersistence.Show(LID);

  // Retorno
  case Assigned(LOutput) of
    True:  Response(FRes).Data(LOutput);
    False: Response(FRes).StatusCode(HTTP_NOT_FOUND);
  end;
end;

procedure TBankAccountController.Store;
begin
  // Obter DTO
  const LInput: SH<TBankAccountInputDTO> = TBankAccountInputDTO.FromReq(FReq);
  SwaggerValidator.Validate(LInput);

  // Inserir
  const LUseCaseResult: Either<String, TBankAccountShowDTO> = FPersistence.StoreAndShow(LInput);
  if not LUseCaseResult.Match then
  begin
    Response(FRes).Error(True).Message(LUseCaseResult.Left);
    Exit;
  end;

  // Retorno
  const LOutput = LUseCaseResult.Right;
  Response(FRes).Data(LOutput).StatusCode(HTTP_CREATED);
end;

procedure TBankAccountController.Update;
begin
  // Obter ID e DTO
  const LID = StrInt(FReq.Params['id']);
  const LInput: SH<TBankAccountInputDTO> = TBankAccountInputDTO.FromReq(FReq);
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


