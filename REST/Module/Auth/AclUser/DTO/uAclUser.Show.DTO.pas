unit uAclUser.Show.DTO;

interface

uses
  uAclUser.Input.DTO,
  Horse.Request,
  GBSwagger.Model.Attributes,
  XSuperObject,
  uSmartPointer,
  uAppRest.Types,
  uResponse.DTO,
  System.Generics.Collections,
  uAclRole.Show.DTO;

type
  TAclUserShowDTO = class(TAclUserInputDTO)
  private
    Fid: Int64;
    Flast_token: String;
    Flast_expiration: String;
    Facl_role_name: String;
    Facl_role: TAclRoleShowDTO;
  public
    constructor Create;
    destructor Destroy; override;

    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagClass]
    [SwagProp('acl_role_name', 'Perfil (Nome)', true)]
    property acl_role_name: String read Facl_role_name write Facl_role_name;

    [SwagString]
    [SwagProp('last_token', 'Último token', true)]
    property last_token: String read Flast_token write Flast_token;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('last_expiration', CREATED_AT_DISPLAY, true)]
    property last_expiration: String read Flast_expiration write Flast_expiration;

    [SwagIgnore]
    property acl_role: TAclRoleShowDTO read Facl_role write Facl_role;
  end;

  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TAclUserShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TAclUserShowDTO;
  public
    property data: TAclUserShowDTO read Fdata write Fdata;
  end;

  TAclUserIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TAclUserShowDTO>;
  public
    property result: TObjectList<TAclUserShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TAclUserIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TAclUserIndexDataResponseDTO;
  public
    property data: TAclUserIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------

implementation

{ TAclUserShowDTO }

constructor TAclUserShowDTO.Create;
begin
  inherited Create;
  Facl_role := TAclRoleShowDTO.Create;
end;

destructor TAclUserShowDTO.Destroy;
begin
  if Assigned(Facl_role) then Facl_role.Free;
  inherited;
end;

end.

