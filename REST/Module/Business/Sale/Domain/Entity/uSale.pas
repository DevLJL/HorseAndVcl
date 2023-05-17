unit uSale;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB,
  uPerson,
  System.Generics.Collections,
  uSaleItem,
  uSale.Types,
  uSalePayment;

type
  TSale = class(TBaseEntity)
  private
    Famount_of_people: SmallInt;
    Fperson_id: Int64;
    Fname: string;
    Fincrease: double;
    Fflg_payment_requested: SmallInt;
    Finformed_legal_entity_number: String;
    Fcarrier_id: Int64;
    Fid: Int64;
    Fmoney_change: double;
    Fdiscount: double;
    Fnote: String;
    Fmoney_received: double;
    Fseller_id: Int64;
    Ffreight: double;
    Finternal_note: String;
    Fstatus: TSaleStatus;
    Ftype: TSaleType;
    Fdelivery_status: TSaleDeliveryStatus;
    Fconsumption_number: SmallInt;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;

    // OneToOne
    Fperson: TPerson;
    Fseller: TPerson;
    Fcarrier: TPerson;
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;

    // OneToMany
    Fsale_items: TObjectList<TSaleItem>;
    Fsale_payments: TObjectList<TSalePayment>;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property person_id: Int64 read Fperson_id write Fperson_id;
    property seller_id: Int64 read Fseller_id write Fseller_id;
    property carrier_id: Int64 read Fcarrier_id write Fcarrier_id;
    property note: String read Fnote write Fnote;
    property internal_note: String read Finternal_note write Finternal_note;
    property status: TSaleStatus read Fstatus write Fstatus;
    property delivery_status: TSaleDeliveryStatus read Fdelivery_status write Fdelivery_status;
    property &type: TSaleType read Ftype write Ftype;
    property flg_payment_requested: SmallInt read Fflg_payment_requested write Fflg_payment_requested;
    property discount: double read Fdiscount write Fdiscount;
    property increase: double read Fincrease write Fincrease;
    property freight: double read Ffreight write Ffreight;
    function total: double;
    property money_received: double read Fmoney_received write Fmoney_received;
    property money_change: double read Fmoney_change write Fmoney_change;
    property amount_of_people: SmallInt read Famount_of_people write Famount_of_people;
    property informed_legal_entity_number: String read Finformed_legal_entity_number write Finformed_legal_entity_number;
    property consumption_number: SmallInt read Fconsumption_number write Fconsumption_number;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    function sum_sale_item_total: Double;
    function sum_sale_item_quantity: Double;
    function perc_discount: Double;
    function perc_increase: Double;
    function sum_sale_payment_amount: Double;

    // OneToOne
    property person: TPerson read Fperson write Fperson;
    property seller: TPerson read Fseller write Fseller;
    property carrier: TPerson read Fcarrier write Fcarrier;
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    // OneToMany
    property sale_items: TObjectList<TSaleItem> read Fsale_items write Fsale_items;
    property sale_payments: TObjectList<TSalePayment> read Fsale_payments write Fsale_payments;

    function Validate: String; override;
    procedure BeforeSave(AState: TEntityState);
    function BeforeSaveAndValidate(AState: TEntityState): String;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uApplication.Exception,
  uSale.BeforeSave,
  System.Math,
  uTrans;

{ TSale }

procedure TSale.BeforeSave(AState: TEntityState);
begin
  TSaleBeforeSave.Make(Self, AState).Execute;
end;

function TSale.BeforeSaveAndValidate(AState: TEntityState): String;
begin
  BeforeSave(AState);
  Result := Validate;
end;

constructor TSale.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TSale.Destroy;
begin
  if Assigned(Fperson)              then Fperson.Free;
  if Assigned(Fseller)              then Fseller.Free;
  if Assigned(Fcarrier)             then Fcarrier.Free;
  if Assigned(Fsale_items)      then Fsale_items.Free;
  if Assigned(Fsale_payments)   then Fsale_payments.Free;
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;

  inherited;
end;

procedure TSale.Initialize;
begin
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
  Fperson              := TPerson.Create;
  Fseller              := TPerson.Create;
  Fcarrier             := TPerson.Create;
  Fsale_items          := TObjectList<TSaleItem>.Create;
  Fsale_payments       := TObjectList<TSalePayment>.Create;
end;

function TSale.perc_discount: Double;
begin
  Result := 0;
  const lSumSaleItemTotal: Double = sum_sale_item_total;
  if (lSumSaleItemTotal <= 0) then
    Exit;

  Result := (Fdiscount/lSumSaleItemTotal)*100;
end;

function TSale.perc_increase: Double;
begin
  Result := 0;
  const lSumSaleItemTotal: Double = sum_sale_item_total;
  if (lSumSaleItemTotal <= 0) then
    Exit;

  Result := (Fincrease/lSumSaleItemTotal)*100;
end;

function TSale.sum_sale_item_quantity: Double;
begin
  Result := 0;
  for var LSaleItem in Fsale_items do
    Result := Result + LSaleItem.quantity;
end;

function TSale.sum_sale_item_total: Double;
begin
  Result := 0;
  for var LSaleItem in Fsale_items do
    Result := Result + LSaleItem.total;
end;

function TSale.sum_sale_payment_amount: Double;
begin
  Result := 0;
  for var LSalePayment in Fsale_payments do
    Result := Result + LSalePayment.amount;
end;

function TSale.total: double;
begin
  var lSumSaleItemTotal: Double := 0;
  for var LSaleItem in Fsale_items do
    lSumSaleItemTotal := lSumSaleItemTotal + LSaleItem.total;

  Result := (lSumSaleItemTotal + Fincrease + Ffreight) - Fdiscount;
end;

function TSale.Validate: String;
var
  LCurrentError: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if (Fseller_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Vendedor/Atendente') + #13;

  if (Fsale_items.Count <= 0) then
    Result := Result + 'Nenhum produto/serviço informado.' + #13;

  // SaleItem
  for var lI := 0 to Pred(Fsale_items.Count) do
  begin
    LCurrentError := Fsale_items.Items[lI].Validate;
    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Venda > Item ' + StrZero((lI+1).ToString,3) + ': ' + LCurrentError;
  end;

  // SalePayment
  for var lI := 0 to Pred(Fsale_payments.Count) do
  begin
    LCurrentError := Fsale_payments.Items[lI].Validate;
    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Venda > Pagamento ' + StrZero((lI+1).ToString,3) + ': ' + LCurrentError;
  end;
end;

end.

