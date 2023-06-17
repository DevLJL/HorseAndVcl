unit uPriceList.DataFactory;

interface

uses
  uBase.DataFactory,
  uPriceList.Show.DTO,
  uPriceList.Input.DTO,
  uPriceList.Persistence.UseCase.Interfaces,
  uPriceList.Persistence.UseCase;

type
  IPriceListDataFactory = Interface
    ['{E52BB3F0-21D1-470C-A7DC-E58D18F06AD3}']
    function GenerateInsert: TPriceListShowDTO;
    function GenerateInput: TPriceListInputDTO;
  End;

  TPriceListDataFactory = class(TBaseDataFactory, IPriceListDataFactory)
  private
    FPersistence: IPriceListPersistenceUseCase;
    constructor Create(APersistenceUseCase: IPriceListPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IPriceListPersistenceUseCase = nil): IPriceListDataFactory;
    function GenerateInsert: TPriceListShowDTO;
    function GenerateInput: TPriceListInputDTO;
  end;

implementation

{ TPriceListDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TPriceListDataFactory.Create(APersistenceUseCase: IPriceListPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TPriceListPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).PriceList);
end;

function TPriceListDataFactory.GenerateInput: TPriceListInputDTO;
begin
  Result := TPriceListInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Text(30);
    acl_user_id := 1;
  end;
end;

function TPriceListDataFactory.GenerateInsert: TPriceListShowDTO;
begin
  const LInput: SH<TPriceListInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TPriceListDataFactory.Make(APersistenceUseCase: IPriceListPersistenceUseCase): IPriceListDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
