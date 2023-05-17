unit uBillPayReceive.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uBillPayReceive.ViewModel.Interfaces,
  uBillPayReceive.Show.DTO,
  uBillPayReceive.Input.DTO;

type
  TBillPayReceiveViewModel = class(TInterfacedObject, IBillPayReceiveViewModel)
  private
    FBillPayReceive: IZLMemTable;
    constructor Create;
  public
    class function Make: IBillPayReceiveViewModel;
    function  FromShowDTO(AInput: TBillPayReceiveShowDTO): IBillPayReceiveViewModel;
    function  ToInputDTO: TBillPayReceiveInputDTO;
    function  EmptyDataSets: IBillPayReceiveViewModel;

    function  BillPayReceive: IZLMemTable;

    function  SetEvents: IBillPayReceiveViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure PersonIdSetText(Sender: TField; const Text: string);
    procedure ChartOfAccountIdSetText(Sender: TField; const Text: string);
    procedure CostCenterIdSetText(Sender: TField; const Text: string);
    procedure BankAccountIdSetText(Sender: TField; const Text: string);
    procedure PaymentIdSetText(Sender: TField; const Text: string);
  end;

implementation

{ TBillPayReceiveViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.Service,
  uCostCenter.Show.DTO,
  uCostCenter.Service,
  uBankAccount.Show.DTO,
  uBankAccount.Service,
  uPayment.Show.DTO,
  uPayment.Service,
  uPerson.Show.DTO,
  uPerson.Service;

procedure TBillPayReceiveViewModel.ChartOfAccountIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LChartOfAccountShowDTO: SH<TChartOfAccountShowDTO> = TChartOfAccountService.Make.Show(Sender.AsLargeInt);
    if not Assigned(lChartOfAccountShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('chart_of_account_id').Clear;
      Sender.DataSet.FieldByName('chart_of_account_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With lChartOfAccountShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('chart_of_account_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('chart_of_account_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

procedure TBillPayReceiveViewModel.CostCenterIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LCostCenterShowDTO: SH<TCostCenterShowDTO> = TCostCenterService.Make.Show(Sender.AsLargeInt);
    if not Assigned(lCostCenterShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('cost_center_id').Clear;
      Sender.DataSet.FieldByName('cost_center_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With lCostCenterShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('cost_center_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('cost_center_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

constructor TBillPayReceiveViewModel.Create;
begin
  inherited Create;

  FBillPayReceive := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('batch', ftString, 46)
    .AddField('type', ftSmallint)
    .AddField('short_description', ftString, 100)
    .AddField('person_id', ftLargeint)
    .AddField('chart_of_account_id', ftLargeint)
    .AddField('cost_center_id', ftLargeint)
    .AddField('bank_account_id', ftLargeint)
    .AddField('payment_id', ftLargeint)
    .AddField('due_date', ftDate)
    .AddField('installment_quantity', ftSmallint)
    .AddField('installment_number', ftSmallint)
    .AddField('amount', ftFloat)
    .AddField('discount', ftFloat)
    .AddField('interest_and_fine', ftFloat)
    .AddField('net_amount', ftFloat)
    .AddField('status', ftSmallint)
    .AddField('payment_date', ftDate)
    .AddField('note', ftString, 5000)
    .AddField('sale_id', ftLargeint)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeint)
    .AddField('updated_by_acl_user_id', ftLargeint)
    .AddField('person_name', ftString, 255) {virtual}
    .AddField('chart_of_account_name', ftString, 255) {virtual}
    .AddField('cost_center_name', ftString, 255) {virtual}
    .AddField('bank_account_name', ftString, 255) {virtual}
    .AddField('payment_name', ftString, 255) {virtual}
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FBillPayReceive.DataSet);
  SetEvents;
end;

procedure TBillPayReceiveViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TBillPayReceiveViewModel.SetEvents: IBillPayReceiveViewModel;
begin
  Result := Self;
  FBillPayReceive.DataSet.AfterInsert := AfterInsert;
  FBillPayReceive.FieldByName('person_id').OnSetText           := PersonIdSetText;
  FBillPayReceive.FieldByName('chart_of_account_id').OnSetText := ChartOfAccountIdSetText;
  FBillPayReceive.FieldByName('cost_center_id').OnSetText      := CostCenterIdSetText;
  FBillPayReceive.FieldByName('bank_account_id').OnSetText     := BankAccountIdSetText;
  FBillPayReceive.FieldByName('payment_id').OnSetText          := PaymentIdSetText;

  // Evitar Data Inválida
  for var LField in FBillPayReceive.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TBillPayReceiveViewModel.EmptyDataSets: IBillPayReceiveViewModel;
begin
  Result := Self;
  FBillPayReceive.EmptyDataSet;
end;

procedure TBillPayReceiveViewModel.BankAccountIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LBankAccountShowDTO: SH<TBankAccountShowDTO> = TBankAccountService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LBankAccountShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('bank_account_id').Clear;
      Sender.DataSet.FieldByName('bank_account_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LBankAccountShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('bank_account_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('bank_account_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

function TBillPayReceiveViewModel.BillPayReceive: IZLMemTable;
begin
  Result := FBillPayReceive;
end;

procedure TBillPayReceiveViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
  DataSet.FieldByName('type').AsInteger                 := -1;
  DataSet.FieldByName('installment_quantity').AsInteger := 1;
  DataSet.FieldByName('installment_number').AsInteger   := 1;
  DataSet.FieldByName('batch').AsString                 := NextUUID;
end;

function TBillPayReceiveViewModel.FromShowDTO(AInput: TBillPayReceiveShowDTO): IBillPayReceiveViewModel;
begin
  Result := Self;

  FBillPayReceive.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TBillPayReceiveViewModel.Make: IBillPayReceiveViewModel;
begin
  Result := TBillPayReceiveViewModel.Create;
end;

procedure TBillPayReceiveViewModel.PaymentIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LPaymentShowDTO: SH<TPaymentShowDTO> = TPaymentService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LPaymentShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('payment_id').Clear;
      Sender.DataSet.FieldByName('payment_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LPaymentShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('payment_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('payment_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

procedure TBillPayReceiveViewModel.PersonIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LPersonShowDTO: SH<TPersonShowDTO> = TPersonService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LPersonShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('person_id').Clear;
      Sender.DataSet.FieldByName('person_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LPersonShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('person_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('person_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

function TBillPayReceiveViewModel.ToInputDTO: TBillPayReceiveInputDTO;
begin
  FBillPayReceive.UnsignEvents;
  try
    Result := TBillPayReceiveInputDTO.FromJSON(BillPayReceive.ToJson);
  finally
    SetEvents;
  end;
end;

end.
