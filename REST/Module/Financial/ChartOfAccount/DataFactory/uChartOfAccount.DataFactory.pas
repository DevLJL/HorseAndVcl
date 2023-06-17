unit uChartOfAccount.DataFactory;

interface

uses
  uBase.DataFactory,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.Input.DTO,
  uChartOfAccount.Persistence.UseCase.Interfaces,
  uChartOfAccount.Persistence.UseCase;

type
  IChartOfAccountDataFactory = Interface
    ['{0F590698-9A44-492D-AD8A-21E8EE7EDB86}']
    function GenerateInsert: TChartOfAccountShowDTO;
    function GenerateInput: TChartOfAccountInputDTO;
  End;

  TChartOfAccountDataFactory = class(TBaseDataFactory, IChartOfAccountDataFactory)
  private
    FPersistence: IChartOfAccountPersistenceUseCase;
    constructor Create(APersistenceUseCase: IChartOfAccountPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IChartOfAccountPersistenceUseCase = nil): IChartOfAccountDataFactory;
    function GenerateInsert: TChartOfAccountShowDTO;
    function GenerateInput: TChartOfAccountInputDTO;
  end;

implementation

{ TChartOfAccountDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TChartOfAccountDataFactory.Create(APersistenceUseCase: IChartOfAccountPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TChartOfAccountPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).ChartOfAccount);
end;

function TChartOfAccountDataFactory.GenerateInput: TChartOfAccountInputDTO;
begin
  Result := TChartOfAccountInputDTO.Create;
  With Result do
  begin
    name           := TFaker.Text(60);
    hierarchy_code := TFaker.NumberStr(10);
    flg_analytical := Random(1);
    note           := TFaker.LoremIpsum(255);
    acl_user_id := 1;
  end;
end;

function TChartOfAccountDataFactory.GenerateInsert: TChartOfAccountShowDTO;
begin
  const LInput: SH<TChartOfAccountInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TChartOfAccountDataFactory.Make(APersistenceUseCase: IChartOfAccountPersistenceUseCase): IChartOfAccountDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
