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
  private
    Fstation_id: String;
    Fopened: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TCashFlowFilterDTO;
    {$ENDIF}

    [SwagString]
    [SwagProp('station_id', 'Estação (ID)', false)]
    property station_id: String read Fstation_id write Fstation_id;

    [SwagString]
    [SwagProp('opened', 'Caixa Aberto? [0-Não, 1-Sim]', false)]
    property opened: String read Fopened write Fopened;
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

