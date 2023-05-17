unit uPayment.Filter.DTO;

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
  TPaymentFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TPaymentFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TPaymentFilterDTO }

{$IFDEF APPREST}
class function TPaymentFilterDTO.FromReq(AReq: THorseRequest): TPaymentFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TPaymentFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

