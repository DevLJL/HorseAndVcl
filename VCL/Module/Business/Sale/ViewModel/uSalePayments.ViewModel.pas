unit uSalePayments.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uSale.ViewModel.Interfaces;

type
  TSalePaymentsViewModel = class(TInterfacedObject, ISalePaymentsViewModel)
  private
    [weak]
    FOwner: ISaleViewModel;
    FSalePayments: IZLMemTable;
    constructor Create(AOwner: ISaleViewModel);
  public
    class function Make(AOwner: ISaleViewModel): ISalePaymentsViewModel;
    function  SalePayments: IZLMemTable;
    function  SetEvents: ISalePaymentsViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure AfterPostDelete(DataSet: TDataSet);
    procedure BankAccountIdSetText(Sender: TField; const Text: string);
    procedure PaymentIdSetText(Sender: TField; const Text: string);
  end;

implementation

{ TSaleViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uBankAccount.Show.DTO,
  uBankAccount.Service,
  uPayment.Show.DTO,
  uPayment.Service;

procedure TSalePaymentsViewModel.AfterPostDelete(DataSet: TDataSet);
begin
  FOwner.CalcFields;
end;

procedure TSalePaymentsViewModel.BankAccountIdSetText(Sender: TField; const Text: string);
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
    UnLockControl;
  end;
end;

constructor TSalePaymentsViewModel.Create(AOwner: ISaleViewModel);
begin
  inherited Create;
  FOwner := AOwner;

  FSalePayments := TMemTableFactory.Make
    .AddField('id', ftLargeInt)
    .AddField('sale_id', ftLargeInt)
    .AddField('collection_uuid', ftString, 36)
    .AddField('payment_id', ftLargeint)
    .AddField('bank_account_id', ftLargeint)
    .AddField('amount', ftFloat)
    .AddField('note', ftString, 5000)
    .AddField('due_date', ftDate)
    .AddField('payment_name', ftString, 255) {virtual}
    .AddField('payment_flg_post_as_received', ftSmallint) {virtual}
    .AddField('bank_account_name', ftString, 255) {virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FSalePayments.DataSet);
  SetEvents;
end;

function TSalePaymentsViewModel.SetEvents: ISalePaymentsViewModel;
begin
  Result := Self;
  FSalePayments.DataSet.AfterInsert                      := AfterInsert;
  FSalePayments.DataSet.AfterPost                        := AfterPostDelete;
  FSalePayments.DataSet.AfterDelete                      := AfterPostDelete;
  FSalePayments.FieldByName('payment_id').OnSetText      := PaymentIdSetText;
  FSalePayments.FieldByName('bank_account_id').OnSetText := BankAccountIdSetText;
end;

function TSalePaymentsViewModel.SalePayments: IZLMemTable;
begin
  Result := FSalePayments;
end;

procedure TSalePaymentsViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

class function TSalePaymentsViewModel.Make(AOwner: ISaleViewModel): ISalePaymentsViewModel;
begin
  Result := Self.Create(AOwner);
end;

procedure TSalePaymentsViewModel.PaymentIdSetText(Sender: TField; const Text: string);
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
      Sender.DataSet.FieldByName('payment_flg_post_as_received').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LPaymentShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('payment_id').AsLargeInt                  := id;
      Sender.DataSet.FieldByName('payment_name').AsString                  := name;
      Sender.DataSet.FieldByName('payment_flg_post_as_received').AsInteger := flg_post_as_received;
    end;
  finally
    UnLockControl;
  end;
end;

end.
