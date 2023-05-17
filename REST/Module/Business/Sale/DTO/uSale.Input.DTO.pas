unit uSale.Input.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uSaleItem.Input.DTO,
  uSalePayment.Input.DTO,
  uSale.Types;

type
  TSaleInputDTO = class(TBaseDTO)
  private
    Famount_of_people: SmallInt;
    Fperson_id: Int64;
    Fincrease: Double;
    Finformed_legal_entity_number: String;
    Fflg_payment_requested: SmallInt;
    Facl_user_id: Int64;
    Fcarrier_id: Int64;
    Fconsumption_number: Int64;
    Fmoney_change: Double;
    Fdiscount: Double;
    Fstatus: TSaleStatus;
    Fnote: String;
    Fmoney_received: Double;
    Ftype: TSaleType;
    Fseller_id: Int64;
    Fdelivery_status: TSaleDeliveryStatus;
    Ffreight: Double;
    Finternal_note: String;

    // OneToMany
    Fsale_items: TObjectList<TSaleItemInputDTO>;
    Fsale_payments: TObjectList<TSalePaymentInputDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TSaleInputDTO;
    {$ENDIF}

    [SwagNumber]
    [SwagProp('person_id', 'Pessoa (ID)', false)]
    property person_id: Int64 read Fperson_id write Fperson_id;

    [SwagNumber]
    [SwagProp('seller_id', 'Vendedor (ID)', true)]
    property seller_id: Int64 read Fseller_id write Fseller_id;

    [SwagNumber]
    [SwagProp('carrier_id', 'Transportador (ID)', false)]
    property carrier_id: Int64 read Fcarrier_id write Fcarrier_id;

    [SwagString]
    [SwagProp('note', 'Observação', false)]
    property note: String read Fnote write Fnote;

    [SwagString]
    [SwagProp('internal_note', 'Observação Interna', false)]
    property internal_note: String read Finternal_note write Finternal_note;

    [SwagNumber]
    [SwagProp('status', 'Status [0..2] ssPending, ssApproved, ssCanceled', false)]
    property status: TSaleStatus read Fstatus write Fstatus;

    [SwagNumber]
    [SwagProp('delivery_status', 'Status [0..6] sdsNew, sdsrefused, sdsScheduled, sdsPreparing, sdsInTransit, sdsDelivered, sdsCanceled', false)]
    property delivery_status: TSaleDeliveryStatus read Fdelivery_status write Fdelivery_status;

    [SwagNumber]
    [SwagProp('type', 'Tipo [0..2] ]stNormal, stConsumption, stDelivery', false)]
    property &type: TSaleType read Ftype write Ftype;

    [SwagNumber(0,1)]
    [SwagProp('flg_payment_requested', 'Pagamento requisitado', false)]
    property flg_payment_requested: SmallInt read Fflg_payment_requested write Fflg_payment_requested;

    [SwagNumber]
    [SwagProp('discount', 'Desconto', false)]
    property discount: Double read Fdiscount write Fdiscount;

    [SwagNumber]
    [SwagProp('increase', 'Acréscimo', false)]
    property increase: Double read Fincrease write Fincrease;

    [SwagNumber]
    [SwagProp('increase', 'Frete', false)]
    property freight: Double read Ffreight write Ffreight;

    [SwagNumber]
    [SwagProp('money_received', 'Valor recebido', false)]
    property money_received: Double read Fmoney_received write Fmoney_received;

    [SwagNumber]
    [SwagProp('money_change', 'Troco', false)]
    property money_change: Double read Fmoney_change write Fmoney_change;

    [SwagNumber]
    [SwagProp('amount_of_people', 'Quantidade de Pessoas', false)]
    property amount_of_people: SmallInt read Famount_of_people write Famount_of_people;

    [SwagNumber]
    [SwagProp('informed_legal_entity_number', 'CPF/CNPJ informado', false)]
    property informed_legal_entity_number: String read Finformed_legal_entity_number write Finformed_legal_entity_number;

    [SwagNumber]
    [SwagProp('consumption_number', 'Número de Consumo', false)]
    property consumption_number: Int64 read Fconsumption_number write Fconsumption_number;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;

    // OneToMany
    property sale_items: TObjectList<TSaleItemInputDTO> read Fsale_items write Fsale_items;
    property sale_payments: TObjectList<TSalePaymentInputDTO> read Fsale_payments write Fsale_payments;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TSaleInputDTO }

constructor TSaleInputDTO.Create;
begin
  inherited Create;
  Fsale_items    := TObjectList<TSaleItemInputDTO>.Create;
  Fsale_payments := TObjectList<TSalePaymentInputDTO>.Create;
end;

destructor TSaleInputDTO.Destroy;
begin
  if Assigned(Fsale_items)    then FreeAndNil(Fsale_items);
  if Assigned(Fsale_payments) then FreeAndNil(Fsale_payments);
  inherited;
end;

{$IFDEF APPREST}
class function TSaleInputDTO.FromReq(AReq: THorseRequest): TSaleInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TSaleInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := StrInt(AReq.Session<TMyClaims>.Id);
end;
{$ENDIF}

end.

