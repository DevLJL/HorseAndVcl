unit uChartOfAccount.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uChartOfAccount.ViewModel.Interfaces,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.Input.DTO;

type
  TChartOfAccountViewModel = class(TInterfacedObject, IChartOfAccountViewModel)
  private
    FChartOfAccount: IZLMemTable;
    constructor Create;
  public
    class function Make: IChartOfAccountViewModel;
    function  FromShowDTO(AInput: TChartOfAccountShowDTO): IChartOfAccountViewModel;
    function  ToInputDTO: TChartOfAccountInputDTO;
    function  EmptyDataSets: IChartOfAccountViewModel;

    function  ChartOfAccount: IZLMemTable;

    function  SetEvents: IChartOfAccountViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TChartOfAccountViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TChartOfAccountViewModel.Create;
begin
  inherited Create;

  FChartOfAccount := TMemTableFactory.Make
    .AddField('id',                       ftLargeint)
    .AddField('name',                     ftString, 100)
    .AddField('hierarchy_code',           ftString, 100)
    .AddField('flg_analytical',           ftSmallint)
    .AddField('note',                     ftString, 5000)
    .AddField('created_at',               ftDateTime)
    .AddField('updated_at',               ftDateTime)
    .AddField('created_by_acl_user_id',   ftLargeint)
    .AddField('updated_by_acl_user_id',   ftLargeint)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FChartOfAccount.DataSet);
  SetEvents;
end;

procedure TChartOfAccountViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TChartOfAccountViewModel.SetEvents: IChartOfAccountViewModel;
begin
  Result := Self;
  FChartOfAccount.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FChartOfAccount.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TChartOfAccountViewModel.EmptyDataSets: IChartOfAccountViewModel;
begin
  Result := Self;
  FChartOfAccount.EmptyDataSet;
end;

function TChartOfAccountViewModel.ChartOfAccount: IZLMemTable;
begin
  Result := FChartOfAccount;
end;

procedure TChartOfAccountViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TChartOfAccountViewModel.FromShowDTO(AInput: TChartOfAccountShowDTO): IChartOfAccountViewModel;
begin
  Result := Self;

  FChartOfAccount.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TChartOfAccountViewModel.Make: IChartOfAccountViewModel;
begin
  Result := TChartOfAccountViewModel.Create;
end;

function TChartOfAccountViewModel.ToInputDTO: TChartOfAccountInputDTO;
begin
  FChartOfAccount.UnsignEvents;
  try
    Result := TChartOfAccountInputDTO.FromJSON(ChartOfAccount.ToJson);
  finally
    SetEvents;
  end;
end;

end.


