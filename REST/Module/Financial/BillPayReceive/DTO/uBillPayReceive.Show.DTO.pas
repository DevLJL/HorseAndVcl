unit uBillPayReceive.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uBillPayReceive.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections;

type
  TBillPayReceiveShowDTO = class(TBillPayReceiveInputDTO)
  private
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_name: String;
    Fcreated_at: TDateTime;
    Fcreated_by_acl_user_name: String;
    Fid: Int64;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;
    Fcost_center_name: String;
    Fchart_of_account_name: String;
    Fperson_name: String;
    Fbank_account_name: String;
    Fpayment_name: String;
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
    [SwagProp('person_name', 'Pessoa (Nome)')]
    property person_name: String read Fperson_name write Fperson_name;

    [SwagString]
    [SwagProp('chart_of_account_name', 'Plano de Conta (Nome)')]
    property chart_of_account_name: String read Fchart_of_account_name write Fchart_of_account_name;

    [SwagString]
    [SwagProp('cost_center_name', 'Centro de Custo (Nome)')]
    property cost_center_name: String read Fcost_center_name write Fcost_center_name;

    [SwagString]
    [SwagProp('bank_account_name', 'Conta Bancária (Nome)')]
    property bank_account_name: String read Fbank_account_name write Fbank_account_name;

    [SwagString]
    [SwagProp('payment_name', 'Pagamento (Nome)')]
    property payment_name: String read Fpayment_name write Fpayment_name;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TBillPayReceiveShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TBillPayReceiveShowDTO;
  public
    property data: TBillPayReceiveShowDTO read Fdata write Fdata;
  end;

  TBillPayReceiveIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TBillPayReceiveShowDTO>;
  public
    property result: TObjectList<TBillPayReceiveShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TBillPayReceiveIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TBillPayReceiveIndexDataResponseDTO;
  public
    property data: TBillPayReceiveIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

end.

