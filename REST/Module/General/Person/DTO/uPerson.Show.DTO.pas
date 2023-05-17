unit uPerson.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uPerson.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uPersonContact.Show.DTO;

type
  TPersonShowDTO = class(TPersonInputDTO)
  private
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_name: String;
    Fcreated_at: TDateTime;
    Fcreated_by_acl_user_name: String;
    Fid: Int64;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;
    Fcity_country: String;
    Fcity_country_ibge_code: String;
    Fcity_ibge_code: String;
    Fcity_name: String;
    Fcity_state: String;

    // OneToMany
    Fperson_contacts: TObjectList<TPersonContactShowDTO>;
  public
    constructor Create;
    destructor Destroy; override;

    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('created_at', CREATED_AT_DISPLAY, true)]
    property created_at: TDateTime read Fcreated_at write Fcreated_at;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('updated_at', UPDATED_AT_DISPLAY)]
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;

    [SwagNumber]
    [SwagProp('created_by_acl_user_id', CREATED_BY_ACL_USER_ID, true)]
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;

    [SwagNumber]
    [SwagProp('updated_by_acl_user_id', UPDATED_BY_ACL_USER_ID)]
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    [SwagString]
    [SwagProp('created_by_acl_user_name', CREATED_BY_ACL_USER_NAME, true)]
    property created_by_acl_user_name: String read Fcreated_by_acl_user_name write Fcreated_by_acl_user_name;

    [SwagString]
    [SwagProp('updated_by_acl_user_name', UPDATED_BY_ACL_USER_NAME)]
    property updated_by_acl_user_name: String read Fupdated_by_acl_user_name write Fupdated_by_acl_user_name;

    [SwagString]
    [SwagProp('city_name', 'Cidade (Nome)')]
    property city_name: String read Fcity_name write Fcity_name;

    [SwagString]
    [SwagProp('city_state', 'Cidade (Estado)')]
    property city_state: String read Fcity_state write Fcity_state;

    [SwagString]
    [SwagProp('city_country', 'Cidade (País)')]
    property city_country: String read Fcity_country write Fcity_country;

    [SwagString]
    [SwagProp('city_ibge_code', 'Cidade (Cód IBGE. da Cidade)')]
    property city_ibge_code: String read Fcity_ibge_code write Fcity_ibge_code;

    [SwagString]
    [SwagProp('city_country_ibge_code', 'Cidade (Cód IBGE. do País)')]
    property city_country_ibge_code: String read Fcity_country_ibge_code write Fcity_country_ibge_code;

    // OneToMany
    property person_contacts: TObjectList<TPersonContactShowDTO> read Fperson_contacts write Fperson_contacts;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TPersonShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TPersonShowDTO;
  public
    property data: TPersonShowDTO read Fdata write Fdata;
  end;

  TPersonIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TPersonShowDTO>;
  public
    property result: TObjectList<TPersonShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TPersonIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TPersonIndexDataResponseDTO;
  public
    property data: TPersonIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

uses
  System.SysUtils;

{ TPersonShowDTO }

constructor TPersonShowDTO.Create;
begin
  inherited Create;
  Fperson_contacts := TObjectList<TPersonContactShowDTO>.Create;
end;

destructor TPersonShowDTO.Destroy;
begin
  if Assigned(Fperson_contacts) then FreeAndNil(Fperson_contacts);
  inherited;
end;

end.

