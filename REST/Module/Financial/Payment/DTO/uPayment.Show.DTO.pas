unit uPayment.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uPayment.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uPaymentTerm.Show.DTO;

type
  TPaymentShowDTO = class(TPaymentInputDTO)
  private
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_name: String;
    Fcreated_at: TDateTime;
    Fcreated_by_acl_user_name: String;
    Fid: Int64;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;
    Fbank_account_default_name: String;

    // OneToMany
    Fpayment_terms: TObjectList<TPaymentTermShowDTO>;
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
    [SwagProp('bank_account_default_name', 'Conta Bancária Padrão (Nome)')]
    property bank_account_default_name: String read Fbank_account_default_name write Fbank_account_default_name;

    // OneToMany
    property payment_terms: TObjectList<TPaymentTermShowDTO> read Fpayment_terms write Fpayment_terms;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TPaymentShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TPaymentShowDTO;
  public
    property data: TPaymentShowDTO read Fdata write Fdata;
  end;

  TPaymentIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TPaymentShowDTO>;
  public
    property result: TObjectList<TPaymentShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TPaymentIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TPaymentIndexDataResponseDTO;
  public
    property data: TPaymentIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

uses
  System.SysUtils;

{ TPaymentShowDTO }

constructor TPaymentShowDTO.Create;
begin
  inherited Create;
  Fpayment_terms := TObjectList<TPaymentTermShowDTO>.Create;
end;

destructor TPaymentShowDTO.Destroy;
begin
  if Assigned(Fpayment_terms) then FreeAndNil(Fpayment_terms);

  inherited;
end;

end.

