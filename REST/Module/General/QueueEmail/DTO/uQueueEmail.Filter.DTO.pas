unit uQueueEmail.Filter.DTO;

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
  TQueueEmailFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TQueueEmailFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TQueueEmailFilterDTO }

{$IFDEF APPREST}
class function TQueueEmailFilterDTO.FromReq(AReq: THorseRequest): TQueueEmailFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TQueueEmailFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

