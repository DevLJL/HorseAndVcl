unit uCashFlow.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uCashFlow.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uCashFlowTransaction.Show.DTO;

type
  TCashFlowShowDTO = class(TCashFlowInputDTO)
  private
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_name: String;
    Fcreated_at: TDateTime;
    Fcreated_by_acl_user_name: String;
    Fid: Int64;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;
    Fstation_name: String;

    // OneToMany
    Fcash_flow_transactions: TObjectList<TCashFlowTransactionShowDTO>;
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
    [SwagProp('station_name', 'Estação (Nome)')]
    property station_name: String read Fstation_name write Fstation_name;

    // OneToMany
    property cash_flow_transactions: TObjectList<TCashFlowTransactionShowDTO> read Fcash_flow_transactions write Fcash_flow_transactions;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TCashFlowShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TCashFlowShowDTO;
  public
    property data: TCashFlowShowDTO read Fdata write Fdata;
  end;

  TCashFlowIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TCashFlowShowDTO>;
  public
    property result: TObjectList<TCashFlowShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TCashFlowIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TCashFlowIndexDataResponseDTO;
  public
    property data: TCashFlowIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

uses
  System.SysUtils;

{ TCashFlowShowDTO }

constructor TCashFlowShowDTO.Create;
begin
  inherited Create;
  Fcash_flow_transactions := TObjectList<TCashFlowTransactionShowDTO>.Create;
end;

destructor TCashFlowShowDTO.Destroy;
begin
  if Assigned(Fcash_flow_transactions) then FreeAndNil(Fcash_flow_transactions);

  inherited;
end;

end.

