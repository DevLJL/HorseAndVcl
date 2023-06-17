unit uNcm.Input.DTO;

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
  TNcmInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fnational_rate: Double;
    Fcode: String;
    Fstate_rate: Double;
    Fcest: String;
    Fadditional_information: String;
    Fstart_of_validity: TDate;
    Fimported_rate: Double;
    Fmunicipal_rate: Double;
    Fend_of_validity: TDate;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TNcmInputDTO;
    {$ENDIF}

    [SwagString(255)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagString(8)]
    [SwagProp('code', 'Código', true)]
    property code: String read Fcode write Fcode;

    [SwagNumber]
    [SwagProp('national_rate', 'Alíq. Nacional', false)]
    property national_rate: Double read Fnational_rate write Fnational_rate;

    [SwagNumber]
    [SwagProp('imported_rate', 'Alíq. Importada', false)]
    property imported_rate: Double read Fimported_rate write Fimported_rate;

    [SwagNumber]
    [SwagProp('state_rate', 'Alíq. Estadual', false)]
    property state_rate: Double read Fstate_rate write Fstate_rate;

    [SwagNumber]
    [SwagProp('municipal_rate', 'Aliq. Municipal', false)]
    property municipal_rate: Double read Fmunicipal_rate write Fmunicipal_rate;

    [SwagString(45)]
    [SwagProp('cest', 'Cest', false)]
    property cest: String read Fcest write Fcest;

    [SwagString]
    [SwagProp('additional_information', 'Informação Adicional', false)]
    property additional_information: String read Fadditional_information write Fadditional_information;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('start_of_validity', 'Inicnio de Vigência', false)]
    property start_of_validity: TDate read Fstart_of_validity write Fstart_of_validity;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('end_of_validity', 'Término de Vigência', false)]
    property end_of_validity: TDate read Fend_of_validity write Fend_of_validity;

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

{ TNcmInputDTO }

{$IFDEF APPREST}
class function TNcmInputDTO.FromReq(AReq: THorseRequest): TNcmInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TNcmInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

