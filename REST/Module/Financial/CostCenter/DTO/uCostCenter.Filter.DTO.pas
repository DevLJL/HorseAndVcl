unit uCostCenter.Filter.DTO;

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
  TCostCenterFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TCostCenterFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TCostCenterFilterDTO }

{$IFDEF APPREST}
class function TCostCenterFilterDTO.FromReq(AReq: THorseRequest): TCostCenterFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TCostCenterFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

