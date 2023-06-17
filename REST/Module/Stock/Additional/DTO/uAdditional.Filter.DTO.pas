unit uAdditional.Filter.DTO;

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
  TAdditionalFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TAdditionalFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TAdditionalFilterDTO }

{$IFDEF APPREST}
class function TAdditionalFilterDTO.FromReq(AReq: THorseRequest): TAdditionalFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TAdditionalFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

