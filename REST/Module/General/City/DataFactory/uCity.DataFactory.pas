unit uCity.DataFactory;

interface

uses
  uBase.DataFactory,
  uCity.Show.DTO,
  uCity.Input.DTO,
  uCity.Persistence.UseCase.Interfaces,
  uCity.Persistence.UseCase;

type
  ICityDataFactory = Interface
    ['{7BD83B1C-BEEA-4985-A818-CA0A7A99D17A}']
    function GenerateInsert: TCityShowDTO;
    function GenerateInput: TCityInputDTO;
  End;

  TCityDataFactory = class(TBaseDataFactory, ICityDataFactory)
  private
    FPersistence: ICityPersistenceUseCase;
    constructor Create(APersistenceUseCase: ICityPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: ICityPersistenceUseCase = nil): ICityDataFactory;
    function GenerateInsert: TCityShowDTO;
    function GenerateInput: TCityInputDTO;
  end;

implementation

{ TCityDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TCityDataFactory.Create(APersistenceUseCase: ICityPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TCityPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).City);
end;

function TCityDataFactory.GenerateInput: TCityInputDTO;
begin
  Result := TCityInputDTO.Create;
  With Result do
  begin
    name              := TFaker.City;
    state             := TFaker.StateAbbreviation;
    country           := TFaker.Country;
    ibge_code         := TFaker.IbgeCodeCity;
    country_ibge_code := (Random(9999)).ToString;
    identification    := TFaker.GenerateUUID;
    acl_user_id       := 1;
  end;
end;

function TCityDataFactory.GenerateInsert: TCityShowDTO;
begin
  const LInput: SH<TCityInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TCityDataFactory.Make(APersistenceUseCase: ICityPersistenceUseCase): ICityDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
