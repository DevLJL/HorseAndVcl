unit uBrand.DataFactory;

interface

uses
  uBase.DataFactory,
  uBrand.Show.DTO,
  uBrand.Input.DTO,
  uBrand.Persistence.UseCase.Interfaces,
  uBrand.Persistence.UseCase;

type
  IBrandDataFactory = Interface
    ['{711003F6-6201-4489-B922-E859AAEC304F}']
    function GenerateInsert: TBrandShowDTO;
    function GenerateInput: TBrandInputDTO;
  End;

  TBrandDataFactory = class(TBaseDataFactory, IBrandDataFactory)
  private
    FPersistence: IBrandPersistenceUseCase;
    constructor Create(APersistenceUseCase: IBrandPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IBrandPersistenceUseCase = nil): IBrandDataFactory;
    function GenerateInsert: TBrandShowDTO;
    function GenerateInput: TBrandInputDTO;
  end;

implementation

{ TBrandDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TBrandDataFactory.Create(APersistenceUseCase: IBrandPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TBrandPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Brand);
end;

function TBrandDataFactory.GenerateInput: TBrandInputDTO;
begin
  Result := TBrandInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Brand;
    acl_user_id := 1;
  end;
end;

function TBrandDataFactory.GenerateInsert: TBrandShowDTO;
begin
  const LInput: SH<TBrandInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TBrandDataFactory.Make(APersistenceUseCase: IBrandPersistenceUseCase): IBrandDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
