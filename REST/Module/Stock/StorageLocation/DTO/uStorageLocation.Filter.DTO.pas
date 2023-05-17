unit uStorageLocation.Filter.DTO;

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
  TStorageLocationFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TStorageLocationFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TStorageLocationFilterDTO }

{$IFDEF APPREST}
class function TStorageLocationFilterDTO.FromReq(AReq: THorseRequest): TStorageLocationFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TStorageLocationFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

