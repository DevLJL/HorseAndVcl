unit uConsumptionSale.Filter.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.Filter.DTO,
  XSuperObject,
  uSmartPointer,
  uConsumption.Types;

type
  TConsumptionSaleFilterDTO = class
  private
    Fstatus: TConsumptionSaleStatus;
    Fnumber: SmallInt;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TConsumptionSaleFilterDTO;
    {$ENDIF}

    [SwagNumber]
    [SwagProp('status', 'Status', false)]
    property status: TConsumptionSaleStatus read Fstatus write Fstatus;

    [SwagNumber]
    [SwagProp('number', 'Número', false)]
    property number: SmallInt read Fnumber write Fnumber;
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TConsumptionSaleFilterDTO }

{$IFDEF APPREST}
class function TConsumptionSaleFilterDTO.FromReq(AReq: THorseRequest): TConsumptionSaleFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TConsumptionSaleFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

