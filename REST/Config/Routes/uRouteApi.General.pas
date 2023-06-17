unit uRouteApi.General;

interface

uses
  Horse;

type
  TRouteApiGeneral = class
    class procedure Registry;
  end;

implementation

uses
  uGlobalConfig.Controller,
  uPosPrinter.Controller,
  uQueueEmail.Controller,
  uCity.Controller,
  uTenant.Controller,
  uPerson.Controller,
  uConsumption.Controller,
  uStation.Controller,
  Horse.GBSwagger.Register;

{ TRouteApiGeneral }

class procedure TRouteApiGeneral.Registry;
begin
  With THorseGBSwaggerRegister do
  begin
    RegisterPath(TGlobalConfigController);
    RegisterPath(TPosPrinterController);
    RegisterPath(TQueueEmailController);
    RegisterPath(TCityController);
    RegisterPath(TTenantController);
    RegisterPath(TPersonController);
    RegisterPath(TConsumptionController);
    RegisterPath(TStationController);
  end;
end;

end.

