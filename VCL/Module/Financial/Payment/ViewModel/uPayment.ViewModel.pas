unit uPayment.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uPayment.ViewModel.Interfaces,
  uPayment.Show.DTO,
  uPayment.Input.DTO;

type
  TPaymentViewModel = class(TInterfacedObject, IPaymentViewModel)
  private
    FPayment: IZLMemTable;
    FPaymentTermsViewModel: IPaymentTermsViewModel;
    constructor Create;
  public
    class function Make: IPaymentViewModel;
    function  FromShowDTO(AInput: TPaymentShowDTO): IPaymentViewModel;
    function  ToInputDTO: TPaymentInputDTO;
    function  EmptyDataSets: IPaymentViewModel;

    function  Payment: IZLMemTable;
    function  PaymentTerms: IZLMemTable;

    function  SetEvents: IPaymentViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure BankAccountDefaultIdSetText(Sender: TField; const Text: string);
  end;

implementation

{ TPaymentViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uPaymentTerms.ViewModel,
  Vcl.Forms,
  uPaymentTerm.Show.DTO,
  XSuperObject,
  uPaymentTerm.Input.DTO,
  uBankAccount.Show.DTO,
  uBankAccount.Service;

constructor TPaymentViewModel.Create;
begin
  inherited Create;

  FPayment := TMemTableFactory.Make
    .AddField('id',                        ftLargeint)
    .AddField('name',                      ftString, 100)
    .AddField('flg_post_as_received',      ftSmallint)
    .AddField('flg_active',                ftSmallint)
    .AddField('flg_active_at_pos',         ftSmallint)
    .AddField('bank_account_default_id',   ftLargeint)
    .AddField('created_at',                ftDateTime)
    .AddField('updated_at',                ftDateTime)
    .AddField('created_by_acl_user_id',    ftLargeint)
    .AddField('updated_by_acl_user_id',    ftLargeint)
    .AddField('bank_account_default_name', ftString, 100) {virtual}
    .AddField('created_by_acl_user_name',  ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name',  ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FPayment.DataSet);
  SetEvents;

  FPaymentTermsViewModel := TPaymentTermsViewModel.Make(Self);
end;

procedure TPaymentViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TPaymentViewModel.SetEvents: IPaymentViewModel;
begin
  Result := Self;

  FPayment.DataSet.AfterInsert                              := AfterInsert;
  FPayment.FieldByName('bank_account_default_id').OnSetText := BankAccountDefaultIdSetText;

  // Evitar Data Inválida
  for var LField in FPayment.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

procedure TPaymentViewModel.BankAccountDefaultIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt   := StrInt64(Text);
    const LBankAccountShowDTO: SH<TBankAccountShowDTO> = TBankAccountService.Make.Show(Sender.AsLargeInt);
    if not Assigned(lBankAccountShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('bank_account_default_id').Clear;
      Sender.DataSet.FieldByName('bank_account_default_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With lBankAccountShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('bank_account_default_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('bank_account_default_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

function TPaymentViewModel.EmptyDataSets: IPaymentViewModel;
begin
  Result := Self;

  FPayment.EmptyDataSet;
  PaymentTerms.EmptyDataSet;
end;

function TPaymentViewModel.Payment: IZLMemTable;
begin
  Result := FPayment;
end;

function TPaymentViewModel.PaymentTerms: IZLMemTable;
begin
  Result := FPaymentTermsViewModel.PaymentTerms;
end;

procedure TPaymentViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TPaymentViewModel.FromShowDTO(AInput: TPaymentShowDTO): IPaymentViewModel;
begin
  Result := Self;

  // Payment
  FPayment.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;

  // PaymentTerms
  PaymentTerms.UnsignEvents;
  for var LPaymentTerm in AInput.payment_terms do
  begin
    MergeDataSet(LPaymentTerm.AsJSON, PaymentTerms.DataSet, true);
    Application.ProcessMessages;
  end;
  PaymentTerms.First;
  FPaymentTermsViewModel.SetEvents;
end;

class function TPaymentViewModel.Make: IPaymentViewModel;
begin
  Result := Self.Create;
end;

function TPaymentViewModel.ToInputDTO: TPaymentInputDTO;
begin
  Try
    FPayment.UnsignEvents;
    PaymentTerms.UnsignEvents;

    // Payment
    Result := TPaymentInputDTO.FromJSON(Payment.ToJson);

    // PaymentTerms
    const LPaymentTerms = TMemTableFactory.Make.FromDataSet(PaymentTerms.DataSet);
    LPaymentTerms.First;
    while not LPaymentTerms.Eof do
    begin
      Result.payment_terms.Add(TPaymentTermInputDTO.Create);
      With Result.payment_terms.Last do
        FromJSON(LPaymentTerms.ToJson);

      LPaymentTerms.Next;
      Application.ProcessMessages;
    end;
  Finally
    SetEvents;
    FPaymentTermsViewModel.SetEvents;
  End;
end;

end.


