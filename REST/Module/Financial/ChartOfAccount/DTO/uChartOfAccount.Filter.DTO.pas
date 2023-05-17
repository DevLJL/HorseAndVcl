unit uChartOfAccount.Filter.DTO;

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
  TChartOfAccountFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TChartOfAccountFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TChartOfAccountFilterDTO }

{$IFDEF APPREST}
class function TChartOfAccountFilterDTO.FromReq(AReq: THorseRequest): TChartOfAccountFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TChartOfAccountFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

