unit uCostCenter.DataFactory;

interface

uses
  uBase.DataFactory,
  uCostCenter.Show.DTO,
  uCostCenter.Input.DTO,
  uCostCenter.Persistence.UseCase.Interfaces,
  uCostCenter.Persistence.UseCase;

type
  ICostCenterDataFactory = Interface
    ['{13A7A326-5ABF-477E-B0D8-A28AC7E3DA11}']
    function GenerateInsert: TCostCenterShowDTO;
    function GenerateInput: TCostCenterInputDTO;
  End;

  TCostCenterDataFactory = class(TBaseDataFactory, ICostCenterDataFactory)
  private
    FPersistence: ICostCenterPersistenceUseCase;
    constructor Create(APersistenceUseCase: ICostCenterPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: ICostCenterPersistenceUseCase = nil): ICostCenterDataFactory;
    function GenerateInsert: TCostCenterShowDTO;
    function GenerateInput: TCostCenterInputDTO;
  end;

implementation

{ TCostCenterDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TCostCenterDataFactory.Create(APersistenceUseCase: ICostCenterPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TCostCenterPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).CostCenter);
end;

function TCostCenterDataFactory.GenerateInput: TCostCenterInputDTO;
begin
  Result := TCostCenterInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Text(60);
    acl_user_id := 1;
  end;
end;

function TCostCenterDataFactory.GenerateInsert: TCostCenterShowDTO;
begin
  const LInput: SH<TCostCenterInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TCostCenterDataFactory.Make(APersistenceUseCase: ICostCenterPersistenceUseCase): ICostCenterDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
