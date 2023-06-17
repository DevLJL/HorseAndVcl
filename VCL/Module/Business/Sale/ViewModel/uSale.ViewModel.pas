unit uSale.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uSale.ViewModel.Interfaces,
  uSale.Show.DTO,
  uSale.Input.DTO;

type
  TSaleViewModel = class(TInterfacedObject, ISaleViewModel)
  private
    FSale: IZLMemTable;
    FSaleItemsViewModel: ISaleItemsViewModel;
    FSalePaymentsViewModel: ISalePaymentsViewModel;
    constructor Create;
  public
    class function Make: ISaleViewModel;
    function  FromShowDTO(AInput: TSaleShowDTO): ISaleViewModel;
    function  ToInputDTO: TSaleInputDTO;
    function  EmptyDataSets: ISaleViewModel;

    function  Sale: IZLMemTable;
    function  SaleItems: IZLMemTable;
    function  SalePayments: IZLMemTable;

    function  SetEvents: ISaleViewModel;
    function  CalcFields: ISaleViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure AfterEdit(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure AmountOfPeopleGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure DiscountSetText(Sender: TField; const Text: string);
    procedure IncreaseSetText(Sender: TField; const Text: string);
    procedure FreightServiceCoverSetText(Sender: TField; const Text: string);
    procedure PercDiscountSetText(Sender: TField; const Text: string);
    procedure PercIncreaseSetText(Sender: TField; const Text: string);
    procedure PersonIdSetText(Sender: TField; const Text: string);
    procedure SellerIdSetText(Sender: TField; const Text: string);
    procedure CarrierIdSetText(Sender: TField; const Text: string);
  end;

implementation

{ TSaleViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uSaleItems.ViewModel,
  Vcl.Forms,
  uSaleItem.Show.DTO,
  XSuperObject,
  uSaleItem.Input.DTO,
  uBankAccount.Show.DTO,
  uBankAccount.Service,
  uUserLogged,
  uPerson.Show.DTO,
  uPerson.Service,
  uSalePayments.ViewModel,
  uSalePayment.Input.DTO,
  System.Classes;

constructor TSaleViewModel.Create;
begin
  inherited Create;

  FSale := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('person_id', ftLargeint)
    .AddField('seller_id', ftLargeInt)
    .AddField('carrier_id', ftLargeInt)
    .AddField('note', ftString, 5000)
    .AddField('internal_note', ftString, 5000)
    .AddField('status', ftSmallInt)
    .AddField('delivery_status', ftSmallInt)
    .AddField('type', ftSmallInt)
    .AddField('flg_payment_requested', ftSmallInt)
    .AddField('discount', ftFloat)
    .AddField('increase', ftFloat)
    .AddField('freight', ftFloat)
    .AddField('service_charge', ftFloat)
    .AddField('cover_charge', ftFloat)
    .AddField('total', ftFloat)
    .AddField('money_received', ftFloat)
    .AddField('money_change', ftFloat)
    .AddField('amount_of_people', ftSmallInt)
    .AddField('informed_legal_entity_number', ftString, 20)
    .AddField('consumption_number', ftSmallInt)
    .AddField('sale_check_id', ftLargeint)
    .AddField('sale_check_name', ftString, 255)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeInt)
    .AddField('updated_by_acl_user_id', ftLargeInt)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .AddField('person_name', ftString, 255) {virtual}
    .AddField('person_address', ftString, 255) {Virtual}
    .AddField('person_address_number', ftString, 15) {Virtual}
    .AddField('person_complement', ftString, 255) {Virtual}
    .AddField('person_district', ftString, 255) {Virtual}
    .AddField('person_reference_point', ftString, 255) {Virtual}
    .AddField('person_city_name', ftString, 100) {virtual}
    .AddField('person_city_state', ftString, 100) {virtual}
    .AddField('seller_name', ftString, 255) {virtual}
    .AddField('carrier_name', ftString, 255) {virtual}
    .AddField('perc_discount', ftFloat) {virtual}
    .AddField('perc_increase', ftFloat) {virtual}
    .AddField('sum_sale_item_total', ftFloat) {virtual}
    .AddField('sum_sale_item_quantity', ftFloat) {virtual}
    .AddField('sum_sale_payment_amount', ftFloat) {virtual}
    .AddField('remaining_change', ftFloat) {virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FSale.DataSet);
  FSale.FieldByName('amount_of_people').Alignment := taCenter;
  SetEvents;

  FSaleItemsViewModel    := TSaleItemsViewModel.Make(Self);
  FSalePaymentsViewModel := TSalePaymentsViewModel.Make(Self);
end;

function TSaleViewModel.CalcFields: ISaleViewModel;
begin
  const LKeepGoing = FSale.Active and (FSale.State in [dsInsert, dsEdit]);
  if not LKeepGoing then
    Exit;

  // SaleItemList
  var LSumSaleItemTotal: Double    := 0;
  var LSumSaleItemQuantity: Double := 0;
  With TMemTableFactory.Make.FromDataSet(SaleItems.DataSet) do
  begin
    First;
    while not Eof do
    begin
      LSumSaleItemTotal    := LSumSaleItemTotal    + FieldByName('total').AsFloat;
      LSumSaleItemQuantity := LSumSaleItemQuantity + FieldByName('quantity').AsFloat;

      Application.ProcessMessages;
      Next;
    end;
  end;

  // SalePaymentList
  var LSumSalePaymentAmount: Double := 0;
  With TMemTableFactory.Make.FromDataSet(SalePayments.DataSet) do
  begin
    First;
    while not Eof do
    begin
      LSumSalePaymentAmount := LSumSalePaymentAmount + FieldByName('amount').AsFloat;

      Application.ProcessMessages;
      Next;
    end;
  end;

  With FSale do
  begin
    FieldByName('sum_sale_item_total').AsFloat     := LSumSaleItemTotal;
    FieldByName('sum_sale_item_quantity').AsFloat  := LSumSaleItemQuantity;
    FieldByName('discount').AsFloat                := PercentageOfValue(FieldByName('perc_discount').AsFloat, LSumSaleItemTotal);
    FieldByName('increase').AsFloat                := PercentageOfValue(FieldByName('perc_increase').AsFloat, LSumSaleItemTotal);
    FieldByName('total').AsFloat                   := LSumSaleItemTotal -
                                                      FieldByName('discount').AsFloat +
                                                      FieldByName('increase').AsFloat +
                                                      FieldByName('freight').AsFloat +
                                                      FieldByName('service_charge').AsFloat +
                                                      FieldByName('cover_charge').AsFloat;
    FieldByName('sum_sale_payment_amount').AsFloat := LSumSalePaymentAmount;
    FieldByName('remaining_change').AsCurrency     := LSumSalePaymentAmount-FSale.FieldByName('total').AsCurrency;
  end;
end;

procedure TSaleViewModel.CarrierIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LPersonShowDTO: SH<TPersonShowDTO> = TPersonService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LPersonShowDTO.Value) or (Assigned(LPersonShowDTO.Value) and (LPersonShowDTO.Value.flg_carrier = 0)) then
    begin
      Sender.DataSet.FieldByName('carrier_id').Clear;
      Sender.DataSet.FieldByName('carrier_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LPersonShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('carrier_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('carrier_name').AsString := name;
    end;

  finally
    UnLockControl;
  end;
end;

procedure TSaleViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

procedure TSaleViewModel.DiscountSetText(Sender: TField; const Text: string);
begin
  Sender.AsCurrency := StrFloat(Text);
  const LSumSaleItemTotal = FSale.FieldByName('sum_sale_item_total').AsFloat;

  case (LSumSaleItemTotal = 0) of
    True:  Sender.DataSet.FieldByName('perc_discount').AsFloat := 0;
    False: Sender.DataSet.FieldByName('perc_discount').AsFloat := (Sender.AsCurrency/LSumSaleItemTotal)*100;
  end;
  CalcFields;
end;

procedure TSaleViewModel.SellerIdSetText(Sender: TField; const Text: string);
begin
  const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
  if not LKeepGoing then
    Exit;

  Sender.AsLargeInt := StrInt64(Text);
  const LPersonShowDTO: SH<TPersonShowDTO> = TPersonService.Make.Show(Sender.AsLargeInt);
  if not Assigned(LPersonShowDTO.Value) or (Assigned(LPersonShowDTO.Value) and (LPersonShowDTO.Value.flg_seller = 0)) then
  begin
    Sender.DataSet.FieldByName('seller_id').Clear;
    Sender.DataSet.FieldByName('seller_name').Clear;
    Exit;
  end;

  // Carregar com dados encontrados
  With LPersonShowDTO.Value do
  begin
    Sender.DataSet.FieldByName('seller_id').AsLargeInt := id;
    Sender.DataSet.FieldByName('seller_name').AsString := name;
  end;
end;

function TSaleViewModel.SetEvents: ISaleViewModel;
begin
  Result := Self;

  FSale.DataSet.AfterInsert                       := AfterInsert;
  FSale.DataSet.AfterEdit                         := AfterEdit;
  FSale.FieldByName('person_id').OnSetText        := PersonIdSetText;
  FSale.FieldByName('seller_id').OnSetText        := SellerIdSetText;
  FSale.FieldByName('carrier_id').OnSetText       := CarrierIdSetText;
  FSale.FieldByName('discount').OnSetText         := DiscountSetText;
  FSale.FieldByName('increase').OnSetText         := IncreaseSetText;
  FSale.FieldByName('perc_discount').OnSetText    := PercDiscountSetText;
  FSale.FieldByName('perc_increase').OnSetText    := PercIncreaseSetText;
  FSale.FieldByName('freight').OnSetText          := FreightServiceCoverSetText;
  FSale.FieldByName('service_charge').OnSetText   := FreightServiceCoverSetText;
  FSale.FieldByName('cover_charge').OnSetText     := FreightServiceCoverSetText;
  FSale.FieldByName('amount_of_people').OnGetText := AmountOfPeopleGetText;

  // Evitar Data Inválida
  for var LField in FSale.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TSaleViewModel.EmptyDataSets: ISaleViewModel;
begin
  Result := Self;

  FSale.EmptyDataSet;
  SaleItems.EmptyDataSet;
  SalePayments.EmptyDataSet;
end;

function TSaleViewModel.Sale: IZLMemTable;
begin
  Result := FSale;
end;

function TSaleViewModel.SaleItems: IZLMemTable;
begin
  Result := FSaleItemsViewModel.SaleItems;
end;

function TSaleViewModel.SalePayments: IZLMemTable;
begin
  Result := FSalePaymentsViewModel.SalePayments;
end;

procedure TSaleViewModel.AfterEdit(DataSet: TDataSet);
begin
  CalcFields;
end;

procedure TSaleViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
  DataSet.FieldByName('amount_of_people').AsInteger := 1;

  // Vendedor Padrão
  if (UserLogged.Current.seller_id > 0) then
  begin
    FSale.FieldByName('seller_id').AsInteger  := UserLogged.Current.seller_id;
    FSale.FieldByName('seller_name').AsString := UserLogged.Current.seller_name;
  end;
end;

procedure TSaleViewModel.AmountOfPeopleGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := Format('%2.2d', [Sender.AsInteger]);
end;

procedure TSaleViewModel.FreightServiceCoverSetText(Sender: TField; const Text: string);
begin
  Sender.AsCurrency := StrFloat(Text);
  CalcFields;
end;

function TSaleViewModel.FromShowDTO(AInput: TSaleShowDTO): ISaleViewModel;
begin
  Result := Self;

  // Sale
  FSale.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;

  // SaleItems
  SaleItems.EmptyDataSet.UnsignEvents;
  for var LSaleItem in AInput.sale_items do
  begin
    MergeDataSet(LSaleItem.AsJSON, SaleItems.DataSet, true);
    Application.ProcessMessages;
  end;
  SaleItems.First;
  FSaleItemsViewModel.SetEvents;

  // SalePayments
  SalePayments.EmptyDataSet.UnsignEvents;
  for var LSalePayment in AInput.sale_payments do
  begin
    MergeDataSet(LSalePayment.AsJSON, SalePayments.DataSet, true);
    Application.ProcessMessages;
  end;
  SalePayments.First;
  FSalePaymentsViewModel.SetEvents;
end;

procedure TSaleViewModel.IncreaseSetText(Sender: TField; const Text: string);
begin
  Sender.AsCurrency := StrFloat(Text);
  const LSumSaleItemTotal = FSale.FieldByName('sum_sale_item_total').AsFloat;

  case (LSumSaleItemTotal = 0) of
    True:  Sender.DataSet.FieldByName('perc_increase').AsFloat := 0;
    False: Sender.DataSet.FieldByName('perc_increase').AsFloat := (Sender.AsCurrency/LSumSaleItemTotal)*100;
  end;
  CalcFields;
end;

class function TSaleViewModel.Make: ISaleViewModel;
begin
  Result := Self.Create;
end;

procedure TSaleViewModel.PercDiscountSetText(Sender: TField; const Text: string);
begin
  Sender.AsFloat := StrFloat(Text);
  Sender.DataSet.FieldByName('discount').Text := PercentageOfValue(
    Sender.AsCurrency,
    Sender.DataSet.FieldByName('sum_sale_item_total').AsFloat
  ).ToString;
end;

procedure TSaleViewModel.PercIncreaseSetText(Sender: TField; const Text: string);
begin
  Sender.AsFloat := StrFloat(Text);
  Sender.DataSet.FieldByName('increase').Text := PercentageOfValue(
    Sender.AsFloat,
    Sender.DataSet.FieldByName('sum_sale_item_total').AsFloat
  ).ToString;
end;

procedure TSaleViewModel.PersonIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LPersonShowDTO: SH<TPersonShowDTO> = TPersonService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LPersonShowDTO.Value) or (Assigned(LPersonShowDTO.Value) and (LPersonShowDTO.Value.flg_customer = 0)) then
    begin
      Sender.DataSet.FieldByName('person_id').Clear;
      Sender.DataSet.FieldByName('person_name').Clear;
      Sender.DataSet.FieldByName('person_address').Clear;
      Sender.DataSet.FieldByName('person_address_number').Clear;
      Sender.DataSet.FieldByName('person_complement').Clear;
      Sender.DataSet.FieldByName('person_district').Clear;
      Sender.DataSet.FieldByName('person_reference_point').Clear;
      Sender.DataSet.FieldByName('person_city_name').Clear;
      Sender.DataSet.FieldByName('person_city_state').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LPersonShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('person_id').AsLargeInt            := id;
      Sender.DataSet.FieldByName('person_name').AsString            := name;
      Sender.DataSet.FieldByName('person_address').AsString         := address;
      Sender.DataSet.FieldByName('person_address_number').AsString  := address_number;
      Sender.DataSet.FieldByName('person_complement').AsString      := complement;
      Sender.DataSet.FieldByName('person_district').AsString        := district;
      Sender.DataSet.FieldByName('person_reference_point').AsString := reference_point;
      Sender.DataSet.FieldByName('person_city_name').AsString       := city_name;
      Sender.DataSet.FieldByName('person_city_state').AsString      := city_state;
    end;
  finally
    UnLockControl;
  end;
end;

function TSaleViewModel.ToInputDTO: TSaleInputDTO;
begin
  Try
    FSale.UnsignEvents;
    SaleItems.UnsignEvents;
    SalePayments.UnsignEvents;

    // Sale
    Result := TSaleInputDTO.FromJSON(Sale.ToJson);

    // SaleItems
    const LSaleItems = TMemTableFactory.Make.FromDataSet(SaleItems.DataSet);
    LSaleItems.First;
    while not LSaleItems.Eof do
    begin
      Result.sale_items.Add(TSaleItemInputDTO.Create);
      With Result.sale_items.Last do
        FromJSON(LSaleItems.ToJson);

      LSaleItems.Next;
      Application.ProcessMessages;
    end;

    // SalePayments
    const LSalePayments = TMemTableFactory.Make.FromDataSet(SalePayments.DataSet);
    LSalePayments.First;
    while not LSalePayments.Eof do
    begin
      Result.sale_payments.Add(TSalePaymentInputDTO.Create);
      With Result.sale_payments.Last do
        FromJSON(LSalePayments.ToJson);

      LSalePayments.Next;
      Application.ProcessMessages;
    end;
  Finally
    SetEvents;
    FSaleItemsViewModel.SetEvents;
    FSalePaymentsViewModel.SetEvents;
  End;
end;

end.
