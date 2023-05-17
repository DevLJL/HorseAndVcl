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
  uQueueEmail.Controller,
  uCity.Controller,
  uCompany.Controller,
  uPerson.Controller,
  uConsumption.Controller,
  uStation.Controller,
  Horse.GBSwagger.Register;

{ TRouteApiGeneral }

class procedure TRouteApiGeneral.Registry;
begin
  With THorseGBSwaggerRegister do
  begin
    RegisterPath(TQueueEmailController);
    RegisterPath(TCityController);
    RegisterPath(TCompanyController);
    RegisterPath(TPersonController);
    RegisterPath(TConsumptionController);
    RegisterPath(TStationController);
  end;
end;

end.

