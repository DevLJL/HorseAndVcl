unit uNcm.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uNcm.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections;

type
  TNcmShowDTO = class(TNcmInputDTO)
  private
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_name: String;
    Fcreated_at: TDateTime;
    Fcreated_by_acl_user_name: String;
    Fid: Int64;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;
  public
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
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TNcmShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TNcmShowDTO;
  public
    property data: TNcmShowDTO read Fdata write Fdata;
  end;

  TNcmIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TNcmShowDTO>;
  public
    property result: TObjectList<TNcmShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TNcmIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TNcmIndexDataResponseDTO;
  public
    property data: TNcmIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

end.

