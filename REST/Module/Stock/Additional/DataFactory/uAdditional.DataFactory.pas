unit uAdditional.DataFactory;

interface

uses
  uBase.DataFactory,
  uAdditional.Show.DTO,
  uAdditional.Input.DTO,
  uAdditional.Persistence.UseCase.Interfaces,
  uAdditional.Persistence.UseCase;

type
  IAdditionalDataFactory = Interface
    ['{B16ED782-0599-40B4-8DDF-2A6B9C2D3A25}']
    function GenerateInsert: TAdditionalShowDTO;
    function GenerateInput: TAdditionalInputDTO;
  End;

  TAdditionalDataFactory = class(TBaseDataFactory, IAdditionalDataFactory)
  private
    FPersistence: IAdditionalPersistenceUseCase;
    constructor Create(APersistenceUseCase: IAdditionalPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IAdditionalPersistenceUseCase = nil): IAdditionalDataFactory;
    function GenerateInsert: TAdditionalShowDTO;
    function GenerateInput: TAdditionalInputDTO;
  end;

implementation

{ TAdditionalDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TAdditionalDataFactory.Create(APersistenceUseCase: IAdditionalPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TAdditionalPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Additional);
end;

function TAdditionalDataFactory.GenerateInput: TAdditionalInputDTO;
begin
  Result := TAdditionalInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Text(30);
    acl_user_id := 1;
  end;
end;

function TAdditionalDataFactory.GenerateInsert: TAdditionalShowDTO;
begin
  const LInput: SH<TAdditionalInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TAdditionalDataFactory.Make(APersistenceUseCase: IAdditionalPersistenceUseCase): IAdditionalDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
