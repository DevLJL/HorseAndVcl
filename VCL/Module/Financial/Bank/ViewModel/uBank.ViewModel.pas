unit uBank.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uBank.ViewModel.Interfaces,
  uBank.Show.DTO,
  uBank.Input.DTO;

type
  TBankViewModel = class(TInterfacedObject, IBankViewModel)
  private
    FBank: IZLMemTable;
    constructor Create;
  public
    class function Make: IBankViewModel;
    function  FromShowDTO(AInput: TBankShowDTO): IBankViewModel;
    function  ToInputDTO: TBankInputDTO;
    function  EmptyDataSets: IBankViewModel;

    function  Bank: IZLMemTable;

    function  SetEvents: IBankViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TBankViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TBankViewModel.Create;
begin
  inherited Create;

  FBank := TMemTableFactory.Make
    .AddField('id',                       ftLargeint)
    .AddField('name',                     ftString, 255)
    .AddField('code',                     ftString, 3)
    .AddField('created_at',               ftDateTime)
    .AddField('updated_at',               ftDateTime)
    .AddField('created_by_acl_user_id',   ftLargeint)
    .AddField('updated_by_acl_user_id',   ftLargeint)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FBank.DataSet);
  SetEvents;
end;

procedure TBankViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TBankViewModel.SetEvents: IBankViewModel;
begin
  Result := Self;
  FBank.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FBank.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TBankViewModel.EmptyDataSets: IBankViewModel;
begin
  Result := Self;
  FBank.EmptyDataSet;
end;

function TBankViewModel.Bank: IZLMemTable;
begin
  Result := FBank;
end;

procedure TBankViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TBankViewModel.FromShowDTO(AInput: TBankShowDTO): IBankViewModel;
begin
  Result := Self;

  FBank.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TBankViewModel.Make: IBankViewModel;
begin
  Result := TBankViewModel.Create;
end;

function TBankViewModel.ToInputDTO: TBankInputDTO;
begin
  FBank.UnsignEvents;
  try
    Result := TBankInputDTO.FromJSON(Bank.ToJson);
  finally
    SetEvents;
  end;
end;

end.


