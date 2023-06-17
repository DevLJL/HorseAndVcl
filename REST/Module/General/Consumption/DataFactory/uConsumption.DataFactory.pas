unit uConsumption.DataFactory;

interface

uses
  uBase.DataFactory,
  uConsumption.Show.DTO,
  uConsumption.Input.DTO,
  uConsumption.Persistence.UseCase.Interfaces,
  uConsumption.Persistence.UseCase;

type
  IConsumptionDataFactory = Interface
    ['{3C51F73C-7B97-4FAC-92F5-CF8450CCC961}']
    function GenerateInsert: TConsumptionShowDTO;
    function GenerateInput: TConsumptionInputDTO;
  End;

  TConsumptionDataFactory = class(TBaseDataFactory, IConsumptionDataFactory)
  private
    FPersistence: IConsumptionPersistenceUseCase;
    constructor Create(APersistenceUseCase: IConsumptionPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IConsumptionPersistenceUseCase = nil): IConsumptionDataFactory;
    function GenerateInsert: TConsumptionShowDTO;
    function GenerateInput: TConsumptionInputDTO;
  end;

implementation

{ TConsumptionDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TConsumptionDataFactory.Create(APersistenceUseCase: IConsumptionPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TConsumptionPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Consumption);
end;

function TConsumptionDataFactory.GenerateInput: TConsumptionInputDTO;
begin
  Result := TConsumptionInputDTO.Create;
  With Result do
  begin
    number      := Random(100)+1;
    flg_active  := Random(1);
    acl_user_id := 1;
  end;
end;

function TConsumptionDataFactory.GenerateInsert: TConsumptionShowDTO;
begin
  const LInput: SH<TConsumptionInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TConsumptionDataFactory.Make(APersistenceUseCase: IConsumptionPersistenceUseCase): IConsumptionDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
