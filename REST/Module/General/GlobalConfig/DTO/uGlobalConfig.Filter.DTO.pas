unit uGlobalConfig.Filter.DTO;

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
  TGlobalConfigFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TGlobalConfigFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TGlobalConfigFilterDTO }

{$IFDEF APPREST}
class function TGlobalConfigFilterDTO.FromReq(AReq: THorseRequest): TGlobalConfigFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TGlobalConfigFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

