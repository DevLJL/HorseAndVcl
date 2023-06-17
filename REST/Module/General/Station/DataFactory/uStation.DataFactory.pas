unit uStation.DataFactory;

interface

uses
  uBase.DataFactory,
  uStation.Show.DTO,
  uStation.Input.DTO,
  uStation.Persistence.UseCase.Interfaces,
  uStation.Persistence.UseCase;

type
  IStationDataFactory = Interface
    ['{75783978-43B7-4BF2-B67D-AD6EE42C9CCB}']
    function GenerateInsert: TStationShowDTO;
    function GenerateInput: TStationInputDTO;
  End;

  TStationDataFactory = class(TBaseDataFactory, IStationDataFactory)
  private
    FPersistence: IStationPersistenceUseCase;
    constructor Create(APersistenceUseCase: IStationPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IStationPersistenceUseCase = nil): IStationDataFactory;
    function GenerateInsert: TStationShowDTO;
    function GenerateInput: TStationInputDTO;
  end;

implementation

{ TStationDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TStationDataFactory.Create(APersistenceUseCase: IStationPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TStationPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Station);
end;

function TStationDataFactory.GenerateInput: TStationInputDTO;
begin
  Result := TStationInputDTO.Create;
  With Result do
  begin
    name := TFaker.Text(60);
  end;
end;

function TStationDataFactory.GenerateInsert: TStationShowDTO;
begin
  const LInput: SH<TStationInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TStationDataFactory.Make(APersistenceUseCase: IStationPersistenceUseCase): IStationDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
