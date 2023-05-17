unit uChartOfAccount.Input.DTO;

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
  TChartOfAccountInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fnote: string;
    Fflg_analytical: SmallInt;
    Fhierarchy_code: string;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TChartOfAccountInputDTO;
    {$ENDIF}

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagString(100)]
    [SwagProp('hierarchy_code', 'Hierarquia (Código)', true)]
    property hierarchy_code: string read Fhierarchy_code write Fhierarchy_code;

    [SwagNumber(0,1)]
    [SwagProp('flg_analytical', 'Analítico [0..1]', false)]
    property flg_analytical: SmallInt read Fflg_analytical write Fflg_analytical;

    [SwagString]
    [SwagProp('note', 'Observação', false)]
    property note: string read Fnote write Fnote;

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

{ TChartOfAccountInputDTO }

{$IFDEF APPREST}
class function TChartOfAccountInputDTO.FromReq(AReq: THorseRequest): TChartOfAccountInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TChartOfAccountInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := StrInt(AReq.Session<TMyClaims>.Id);
end;
{$ENDIF}

end.

