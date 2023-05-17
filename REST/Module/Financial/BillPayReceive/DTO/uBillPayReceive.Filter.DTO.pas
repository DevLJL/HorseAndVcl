unit uBillPayReceive.Filter.DTO;

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
  TBillPayReceiveFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TBillPayReceiveFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TBillPayReceiveFilterDTO }

{$IFDEF APPREST}
class function TBillPayReceiveFilterDTO.FromReq(AReq: THorseRequest): TBillPayReceiveFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TBillPayReceiveFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

