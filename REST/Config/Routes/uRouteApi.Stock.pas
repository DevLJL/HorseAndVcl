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

