unit uProduct.Filter.DTO;

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
  TProductFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TProductFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TProductFilterDTO }

{$IFDEF APPREST}
class function TProductFilterDTO.FromReq(AReq: THorseRequest): TProductFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TProductFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

