unit uPosPrinter.Filter.DTO;

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
  TPosPrinterFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TPosPrinterFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TPosPrinterFilterDTO }

{$IFDEF APPREST}
class function TPosPrinterFilterDTO.FromReq(AReq: THorseRequest): TPosPrinterFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TPosPrinterFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

