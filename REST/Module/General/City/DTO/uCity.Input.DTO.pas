unit uCity.Input.DTO;

interface

uses
  uBase.DTO,
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer;

type
  TCityInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fidentification: String;
    Fcountry_ibge_code: String;
    Fstate: String;
    Fcountry: String;
    Fibge_code: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TCityInputDTO;
    {$ENDIF}

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagString(2,2)]
    [SwagProp('state', 'Estado', true)]
    property state: String read Fstate write Fstate;

    [SwagString(100)]
    [SwagProp('country', 'País', true)]
    property country: String read Fcountry write Fcountry;

    [SwagString(30)]
    [SwagProp('ibge_code', 'Cód IBGE da Cidade', true)]
    property ibge_code: String read Fibge_code write Fibge_code;

    [SwagString(30)]
    [SwagProp('country_ibge_code', 'Cód IBGE do País', true)]
    property country_ibge_code: String read Fcountry_ibge_code write Fcountry_ibge_code;

    [SwagString(100)]
    [SwagProp('identification', 'Identificação', false)]
    property identification: String read Fidentification write Fidentification;

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

{ TCityInputDTO }

{$IFDEF APPREST}
class function TCityInputDTO.FromReq(AReq: THorseRequest): TCityInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TCityInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := StrInt(AReq.Session<TMyClaims>.Id);
end;
{$ENDIF}

end.

