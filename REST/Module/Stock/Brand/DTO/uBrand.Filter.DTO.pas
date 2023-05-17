unit uBrand.Filter.DTO;

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
  TBrandFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TBrandFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TBrandFilterDTO }

{$IFDEF APPREST}
class function TBrandFilterDTO.FromReq(AReq: THorseRequest): TBrandFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TBrandFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

