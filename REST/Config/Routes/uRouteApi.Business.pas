unit uRouteApi.Business;

interface

uses
  Horse;

type
  TRouteApiBusiness = class
    class procedure Registry;
  end;

implementation

uses
  Horse.GBSwagger.Register,
  uSale.Controller;

{ TRouteApiBusiness }

class procedure TRouteApiBusiness.Registry;
begin
  With THorseGBSwaggerRegister do
  begin
    RegisterPath(TSaleController);
  end;
end;

end.

