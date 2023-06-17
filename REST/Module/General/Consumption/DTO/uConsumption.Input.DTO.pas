unit uConsumption.Input.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.DTO,
  XSuperObject,
  uSmartPointer;

type
  TConsumptionInputDTO = class(TBaseDTO)
  private
    Facl_user_id: Int64;
    Fflg_active: SmallInt;
    Fnumber: SmallInt;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TConsumptionInputDTO;
    {$ENDIF}

    [SwagNumber]
    [SwagProp('number', 'Número', true)]
    property number: SmallInt read Fnumber write Fnumber;

    [SwagNumber]
    [SwagProp('flg_active', 'Ativo', false)]
    property flg_active: SmallInt read Fflg_active write Fflg_active;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TConsumptionInputDTO }

{$IFDEF APPREST}
class function TConsumptionInputDTO.FromReq(AReq: THorseRequest): TConsumptionInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TConsumptionInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

