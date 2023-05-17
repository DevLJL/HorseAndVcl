unit uConsumption.Filter.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.Filter.DTO,
  XSuperObject,
  uSmartPointer;

type
  TConsumptionFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TConsumptionFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TConsumptionFilterDTO }

{$IFDEF APPREST}
class function TConsumptionFilterDTO.FromReq(AReq: THorseRequest): TConsumptionFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TConsumptionFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

