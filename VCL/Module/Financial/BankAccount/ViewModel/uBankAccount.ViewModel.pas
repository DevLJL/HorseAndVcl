unit uBankAccount.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uBankAccount.ViewModel.Interfaces,
  uBankAccount.Show.DTO,
  uBankAccount.Input.DTO;

type
  TBankAccountViewModel = class(TInterfacedObject, IBankAccountViewModel)
  private
    FBankAccount: IZLMemTable;
    constructor Create;
  public
    class function Make: IBankAccountViewModel;
    function  FromShowDTO(AInput: TBankAccountShowDTO): IBankAccountViewModel;
    function  ToInputDTO: TBankAccountInputDTO;
    function  EmptyDataSets: IBankAccountViewModel;

    function  BankAccount: IZLMemTable;

    function  SetEvents: IBankAccountViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure BankIdSetText(Sender: TField; const Text: string);
  end;

implementation

{ TBankAccountViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject, uBank.Service, uBank.Show.DTO;

constructor TBankAccountViewModel.Create;
begin
  inherited Create;

  FBankAccount := TMemTableFactory.Make
    .AddField('id',                       ftLargeint)
    .AddField('name',                     ftString, 255)
    .AddField('bank_id',                  ftInteger)
    .AddField('note',                     ftString, 5000)
    .AddField('created_at',               ftDateTime)
    .AddField('updated_at',               ftDateTime)
    .AddField('created_by_acl_user_id',   ftLargeint)
    .AddField('updated_by_acl_user_id',   ftLargeint)
    .AddField('bank_name',                ftString, 100) {virtual}
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FBankAccount.DataSet);
  SetEvents;
end;

procedure TBankAccountViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TBankAccountViewModel.SetEvents: IBankAccountViewModel;
begin
  Result := Self;
  FBankAccount.DataSet.AfterInsert := AfterInsert;
  FBankAccount.FieldByName('bank_id').OnSetText := BankIdSetText;

  // Evitar Data Inválida
  for var LField in FBankAccount.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TBankAccountViewModel.EmptyDataSets: IBankAccountViewModel;
begin
  Result := Self;
  FBankAccount.EmptyDataSet;
end;

function TBankAccountViewModel.BankAccount: IZLMemTable;
begin
  Result := FBankAccount;
end;

procedure TBankAccountViewModel.BankIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LBankShowDTO: SH<TBankShowDTO> = TBankService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LBankShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('bank_id').Clear;
      Sender.DataSet.FieldByName('bank_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LBankShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('bank_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('bank_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

procedure TBankAccountViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TBankAccountViewModel.FromShowDTO(AInput: TBankAccountShowDTO): IBankAccountViewModel;
begin
  Result := Self;

  FBankAccount.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TBankAccountViewModel.Make: IBankAccountViewModel;
begin
  Result := TBankAccountViewModel.Create;
end;

function TBankAccountViewModel.ToInputDTO: TBankAccountInputDTO;
begin
  FBankAccount.UnsignEvents;
  try
    Result := TBankAccountInputDTO.FromJSON(BankAccount.ToJson);
  finally
    SetEvents;
  end;
end;

end.


