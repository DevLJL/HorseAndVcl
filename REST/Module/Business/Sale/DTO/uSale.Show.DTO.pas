unit uSale.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uSale.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uSaleItem.Show.DTO,
  uSalePayment.Show.DTO;

type
  TSaleShowDTO = class(TSaleInputDTO)
  private
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_name: String;
    Fcreated_at: TDateTime;
    Fcreated_by_acl_user_name: String;
    Fid: Int64;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;
    Fseller_name: String;
    Fperc_discount: double;
    Fsum_sale_item_total: double;
    Ftotal: double;
    Fperson_name: String;
    Fsum_sale_item_quantity: double;
    Fperc_increase: double;
    Fcarrier_name: String;

    // OneToMany
    Fsale_items: TObjectList<TSaleItemShowDTO>;
    Fsale_payments: TObjectList<TSalePaymentShowDTO>;
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
    [SwagProp('person_name', 'Pessoa (Nome)')]
    property person_name: String read Fperson_name write Fperson_name;

    [SwagString]
    [SwagProp('seller_name', 'Vendedor (Nome)')]
    property seller_name: String read Fseller_name write Fseller_name;

    [SwagString]
    [SwagProp('carrier_name', 'Transportador (Nome)')]
    property carrier_name: String read Fcarrier_name write Fcarrier_name;

    [SwagNumber]
    [SwagProp('total', 'Total')]
    property total: double read Ftotal write Ftotal;

    [SwagNumber]
    [SwagProp('perc_discount', 'Desconto %')]
    property perc_discount: double read Fperc_discount write Fperc_discount;

    [SwagNumber]
    [SwagProp('perc_increase', 'Acréscimo %')]
    property perc_increase: double read Fperc_increase write Fperc_increase;

    [SwagNumber]
    [SwagProp('sum_sale_item_total', 'Valor Total dos Itens')]
    property sum_sale_item_total: double read Fsum_sale_item_total write Fsum_sale_item_total;

    [SwagNumber]
    [SwagProp('sum_sale_item_quantity', 'Quantidade Total dos Itens')]
    property sum_sale_item_quantity: double read Fsum_sale_item_quantity write Fsum_sale_item_quantity;

    // OneToMany
    property sale_items: TObjectList<TSaleItemShowDTO> read Fsale_items write Fsale_items;
    property sale_payments: TObjectList<TSalePaymentShowDTO> read Fsale_payments write Fsale_payments;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TSaleShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TSaleShowDTO;
  public
    property data: TSaleShowDTO read Fdata write Fdata;
  end;

  TSaleIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TSaleShowDTO>;
  public
    property result: TObjectList<TSaleShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TSaleIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TSaleIndexDataResponseDTO;
  public
    property data: TSaleIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

uses
  System.SysUtils,
  uSale.Types;

{ TSaleShowDTO }

constructor TSaleShowDTO.Create;
begin
  inherited Create;
  Fsale_items    := TObjectList<TSaleItemShowDTO>.Create;
  Fsale_payments := TObjectList<TSalePaymentShowDTO>.Create;
end;

destructor TSaleShowDTO.Destroy;
begin
  if Assigned(Fsale_items)    then FreeAndNil(Fsale_items);
  if Assigned(Fsale_payments) then FreeAndNil(Fsale_payments);

  inherited;
end;

end.

