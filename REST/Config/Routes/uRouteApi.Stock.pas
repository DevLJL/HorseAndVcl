unit uRouteApi.Stock;

interface

uses
  Horse;

type
  TRouteApiStock = class
    class procedure Registry;
  end;

implementation

uses
  uAdditional.Controller,
  uPriceList.Controller,
  uBrand.Controller,
  Horse.GBSwagger.Register,
  uCategory.Controller,
  uNcm.Controller,
  uProduct.Controller,
  uSize.Controller,
  uStorageLocation.Controller,
  uUnit.Controller;

{ TRouteApiStock }

class procedure TRouteApiStock.Registry;
begin
  With THorseGBSwaggerRegister do
  begin
    RegisterPath(TAdditionalController);
    RegisterPath(TPriceListController);
    RegisterPath(TBrandController);
    RegisterPath(TCategoryController);
    RegisterPath(TNcmController);
    RegisterPath(TProductController);
    RegisterPath(TSizeController);
    RegisterPath(TStorageLocationController);
    RegisterPath(TUnitController);
  end;
end;

end.

