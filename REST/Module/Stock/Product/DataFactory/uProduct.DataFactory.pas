unit uProduct.DataFactory;

interface

uses
  uBase.DataFactory,
  uProduct.Show.DTO,
  uProduct.Input.DTO,
  uProduct.Persistence.UseCase.Interfaces,
  uProduct.Persistence.UseCase;

type
  IProductDataFactory = Interface
    ['{3B85F4A1-1B6C-42FF-90CB-0073B4DB898B}']
    function GenerateInsert: TProductShowDTO;
    function GenerateInput: TProductInputDTO;
  End;

  TProductDataFactory = class(TBaseDataFactory, IProductDataFactory)
  private
    FPersistence: IProductPersistenceUseCase;
    constructor Create(APersistenceUseCase: IProductPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IProductPersistenceUseCase = nil): IProductDataFactory;
    function GenerateInsert: TProductShowDTO;
    function GenerateInput: TProductInputDTO;
  end;

implementation

{ TProductDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uProduct.Types,
  uUnit.Show.DTO,
  uUnit.DataFactory,
  uNcm.Show.DTO,
  uNcm.DataFactory,
  uCategory.Show.DTO,
  uCategory.DataFactory,
  uBrand.Show.DTO,
  uBrand.DataFactory,
  uSize.Show.DTO,
  uSize.DataFactory,
  uStorageLocation.Show.DTO,
  uStorageLocation.DataFactory,
  uTestConnection;

constructor TProductDataFactory.Create(APersistenceUseCase: IProductPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TProductPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Product);
end;

function TProductDataFactory.GenerateInput: TProductInputDTO;
begin
  const UnitShowDTO: SH<TUnitShowDTO> = TUnitDataFactory.Make.GenerateInsert;
  const NcmShowDTO: SH<TNcmShowDTO> = TNcmDataFactory.Make.GenerateInsert;
  const CategoryShowDTO: SH<TCategoryShowDTO> = TCategoryDataFactory.Make.GenerateInsert;
  const BrandShowDTO: SH<TBrandShowDTO> = TBrandDataFactory.Make.GenerateInsert;
  const SizeShowDTO: SH<TSizeShowDTO> = TSizeDataFactory.Make.GenerateInsert;
  const StorageLocationShowDTO: SH<TStorageLocationShowDTO> = TStorageLocationDataFactory.Make.GenerateInsert;

  Result := TProductInputDTO.Create;
  With Result do
  begin
    name                   := TFaker.Product;
    simplified_name        := Copy(name, 1, 30);
    &type                  := TProductType(Random(1));
    sku_code               := TFaker.GenerateUUID;
    ean_code               := EmptyStr;
    manufacturing_code     := EmptyStr;
    identification_code    := EmptyStr;
    cost                   := TFaker.NumberFloat;
    price                  := TFaker.NumberFloat;
    current_quantity       := TFaker.NumberFloat;
    minimum_quantity       := TFaker.NumberFloat;
    maximum_quantity       := TFaker.NumberFloat;
    gross_weight           := TFaker.NumberFloat;
    net_weight             := TFaker.NumberFloat;
    packing_weight         := TFaker.NumberFloat;
    flg_to_move_the_stock  := Random(1);
    flg_product_for_scales := Random(1);
    internal_note          := TFaker.LoremIpsum(255);
    complement_note        := TFaker.LoremIpsum(255);
    flg_discontinued       := Random(1);
    unit_id                := UnitShowDTO.Value.id;
    ncm_id                 := NcmShowDTO.Value.id;
    category_id            := CategoryShowDTO.Value.id;
    brand_id               := BrandShowDTO.Value.id;
    size_id                := SizeShowDTO.Value.id;
    storage_location_id    := StorageLocationShowDTO.Value.id;
    genre                  := TProductGenre.Masculine;
    acl_user_id := 1;
  end;
end;

function TProductDataFactory.GenerateInsert: TProductShowDTO;
begin
  const LInput: SH<TProductInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TProductDataFactory.Make(APersistenceUseCase: IProductPersistenceUseCase): IProductDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
