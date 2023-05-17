unit uCashFlowTransactions.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uCashFlow.ViewModel.Interfaces;

type
  TCashFlowTransactionsViewModel = class(TInterfacedObject, ICashFlowTransactionsViewModel)
  private
    [weak]
    FOwner: ICashFlowViewModel;
    FCashFlowTransactions: IZLMemTable;
    constructor Create(AOwner: ICashFlowViewModel);
  public
    class function Make(AOwner: ICashFlowViewModel): ICashFlowTransactionsViewModel;
    function  CashFlowTransactions: IZLMemTable;
    function  SetEvents: ICashFlowTransactionsViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure PaymentIdSetText(Sender: TField; const Text: string);
    procedure PersonIdSetText(Sender: TField; const Text: string);
  end;

implementation

{ TCashFlowViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uPayment.Show.DTO,
  uPayment.Service,
  uPerson.Show.DTO,
  uPerson.Service;

constructor TCashFlowTransactionsViewModel.Create(AOwner: ICashFlowViewModel);
begin
  inherited Create;
  FOwner := AOwner;

  FCashFlowTransactions := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('cash_flow_id', ftLargeint)
    .AddField('flg_manual_transaction', ftSmallint)
    .AddField('transaction_date', ftDateTime)
    .AddField('history', ftString, 80)
    .AddField('type', ftSmallint) // [0-Debito, 1-Credito]
    .AddField('amount', ftFloat)
    .AddField('payment_id', ftLargeint)
    .AddField('note', ftString, 5000)
    .AddField('sale_id', ftLargeint)
    .AddField('person_id', ftLargeint)
    .AddField('payment_name', ftString, 255) {virtual}
    .AddField('person_name', ftString, 255) {virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FCashFlowTransactions.DataSet);
  SetEvents;
end;

function TCashFlowTransactionsViewModel.SetEvents: ICashFlowTransactionsViewModel;
begin
  Result := Self;
  FCashFlowTransactions.DataSet.AfterInsert := AfterInsert;
  FCashFlowTransactions.FieldByName('payment_id').OnSetText := PaymentIdSetText;
  FCashFlowTransactions.FieldByName('person_id').OnSetText  := PersonIdSetText;
end;

function TCashFlowTransactionsViewModel.CashFlowTransactions: IZLMemTable;
begin
  Result := FCashFlowTransactions;
end;

procedure TCashFlowTransactionsViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

class function TCashFlowTransactionsViewModel.Make(AOwner: ICashFlowViewModel): ICashFlowTransactionsViewModel;
begin
  Result := Self.Create(AOwner);
end;

procedure TCashFlowTransactionsViewModel.PaymentIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not lKeepGoing then
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

procedure TCashFlowTransactionsViewModel.PersonIdSetText(Sender: TField; const Text: string);
begin
  Try
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
  Finally
    UnlockControl;
  End;
end;

end.

