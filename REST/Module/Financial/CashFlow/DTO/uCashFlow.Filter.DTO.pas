unit uCashFlow.Filter.DTO;

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
  TCashFlowFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TCashFlowFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TCashFlowFilterDTO }

{$IFDEF APPREST}
class function TCashFlowFilterDTO.FromReq(AReq: THorseRequest): TCashFlowFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TCashFlowFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

