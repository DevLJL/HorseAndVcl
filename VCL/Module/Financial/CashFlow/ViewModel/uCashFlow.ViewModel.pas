unit uCashFlow.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uCashFlow.ViewModel.Interfaces,
  uCashFlow.Show.DTO,
  uCashFlow.Input.DTO;

type
  TCashFlowViewModel = class(TInterfacedObject, ICashFlowViewModel)
  private
    FCashFlow: IZLMemTable;
    FCashFlowTransactionsViewModel: ICashFlowTransactionsViewModel;
    constructor Create;
  public
    class function Make: ICashFlowViewModel;
    function  FromShowDTO(AInput: TCashFlowShowDTO): ICashFlowViewModel;
    function  ToInputDTO: TCashFlowInputDTO;
    function  EmptyDataSets: ICashFlowViewModel;

    function  CashFlow: IZLMemTable;
    function  CashFlowTransactions: IZLMemTable;

    function  SetEvents: ICashFlowViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure StationIdSetText(Sender: TField; const Text: string);
  end;

implementation

{ TCashFlowViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uCashFlowTransactions.ViewModel,
  Vcl.Forms,
  uCashFlowTransaction.Show.DTO,
  XSuperObject,
  uCashFlowTransaction.Input.DTO,
  uStation.Show.DTO,
  uStation.Service;

constructor TCashFlowViewModel.Create;
begin
  inherited Create;

  FCashFlow := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('station_id', ftLargeint)
    .AddField('opening_balance_amount', ftFloat)
    .AddField('final_balance_amount', ftFloat)
    .AddField('opening_date', ftDateTime)
    .AddField('closing_date', ftDateTime)
    .AddField('closing_note', ftString, 5000)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeint)
    .AddField('updated_by_acl_user_id', ftLargeint)
    .AddField('station_name', ftString, 100) {virtual}
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FCashFlow.DataSet);
  SetEvents;

  FCashFlowTransactionsViewModel := TCashFlowTransactionsViewModel.Make(Self);
end;

procedure TCashFlowViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TCashFlowViewModel.SetEvents: ICashFlowViewModel;
begin
  Result := Self;

  FCashFlow.DataSet.AfterInsert                 := AfterInsert;
  FCashFlow.FieldByName('station_id').OnSetText := StationIdSetText;

  // Evitar Data Inválida
  for var LField in FCashFlow.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

procedure TCashFlowViewModel.StationIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LStationShowDTO: SH<TStationShowDTO> = TStationService.Make.Show(Sender.AsLargeInt);
    if not Assigned(lStationShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('station_id').Clear;
      Sender.DataSet.FieldByName('station_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With lStationShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('station_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('station_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

function TCashFlowViewModel.EmptyDataSets: ICashFlowViewModel;
begin
  Result := Self;

  FCashFlow.EmptyDataSet;
  CashFlowTransactions.EmptyDataSet;
end;

function TCashFlowViewModel.CashFlow: IZLMemTable;
begin
  Result := FCashFlow;
end;

function TCashFlowViewModel.CashFlowTransactions: IZLMemTable;
begin
  Result := FCashFlowTransactionsViewModel.CashFlowTransactions;
end;

procedure TCashFlowViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TCashFlowViewModel.FromShowDTO(AInput: TCashFlowShowDTO): ICashFlowViewModel;
begin
  Result := Self;

  // CashFlow
  FCashFlow.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;

  // CashFlowTransactions
  CashFlowTransactions.UnsignEvents;
  for var LCashFlowTransaction in AInput.cash_flow_transactions do
  begin
    MergeDataSet(LCashFlowTransaction.AsJSON, CashFlowTransactions.DataSet, true);
    Application.ProcessMessages;
  end;
  CashFlowTransactions.First;
  FCashFlowTransactionsViewModel.SetEvents;
end;

class function TCashFlowViewModel.Make: ICashFlowViewModel;
begin
  Result := Self.Create;
end;

function TCashFlowViewModel.ToInputDTO: TCashFlowInputDTO;
begin
  Try
    FCashFlow.UnsignEvents;
    CashFlowTransactions.UnsignEvents;

    // CashFlow
    Result := TCashFlowInputDTO.FromJSON(CashFlow.ToJson);

    // CashFlowTransactions
    const LCashFlowTransactions = TMemTableFactory.Make.FromDataSet(CashFlowTransactions.DataSet);
    LCashFlowTransactions.First;
    while not LCashFlowTransactions.Eof do
    begin
      Result.cash_flow_transactions.Add(TCashFlowTransactionInputDTO.Create);
      With Result.cash_flow_transactions.Last do
        FromJSON(LCashFlowTransactions.ToJson);

      LCashFlowTransactions.Next;
      Application.ProcessMessages;
    end;
  Finally
    SetEvents;
    FCashFlowTransactionsViewModel.SetEvents;
  End;
end;

end.


