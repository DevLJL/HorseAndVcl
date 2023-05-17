unit uCostCenter.Input.DTO;

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
  TCostCenterInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fcode: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TCostCenterInputDTO;
    {$ENDIF}

    [SwagString(255)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

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

{ TCostCenterInputDTO }

{$IFDEF APPREST}
class function TCostCenterInputDTO.FromReq(AReq: THorseRequest): TCostCenterInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TCostCenterInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := StrInt(AReq.Session<TMyClaims>.Id);
end;
{$ENDIF}

end.

