unit uBankAccount.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uBankAccount.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections;

type
  TBankAccountShowDTO = class(TBankAccountInputDTO)
  private
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_name: String;
    Fcreated_at: TDateTime;
    Fcreated_by_acl_user_name: String;
    Fid: Int64;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;
    Fbank_name: string;
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

    [SwagString]
    [SwagProp('bank_name', 'Banco (Nome)')]
    property bank_name: string read Fbank_name write Fbank_name;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TBankAccountShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TBankAccountShowDTO;
  public
    property data: TBankAccountShowDTO read Fdata write Fdata;
  end;

  TBankAccountIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TBankAccountShowDTO>;
  public
    property result: TObjectList<TBankAccountShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TBankAccountIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TBankAccountIndexDataResponseDTO;
  public
    property data: TBankAccountIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

end.

