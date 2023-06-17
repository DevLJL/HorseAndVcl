unit uConsumption.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uConsumption.ViewModel.Interfaces,
  uConsumption.Show.DTO,
  uConsumption.Input.DTO;

type
  TConsumptionViewModel = class(TInterfacedObject, IConsumptionViewModel)
  private
    FConsumption: IZLMemTable;
    constructor Create;
  public
    class function Make: IConsumptionViewModel;
    function  FromShowDTO(AInput: TConsumptionShowDTO): IConsumptionViewModel;
    function  ToInputDTO: TConsumptionInputDTO;
    function  EmptyDataSets: IConsumptionViewModel;

    function  Consumption: IZLMemTable;

    function  SetEvents: IConsumptionViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TConsumptionViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TConsumptionViewModel.Create;
begin
  inherited Create;

  FConsumption := TMemTableFactory.Make
    .AddField('id',                       ftLargeint)
    .AddField('number',                   ftSmallint)
    .AddField('flg_active',               ftSmallint)
    .AddField('created_at',               ftDateTime)
    .AddField('updated_at',               ftDateTime)
    .AddField('created_by_acl_user_id',   ftLargeint)
    .AddField('updated_by_acl_user_id',   ftLargeint)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FConsumption.DataSet);
  SetEvents;
end;

procedure TConsumptionViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TConsumptionViewModel.SetEvents: IConsumptionViewModel;
begin
  Result := Self;
  FConsumption.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FConsumption.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TConsumptionViewModel.EmptyDataSets: IConsumptionViewModel;
begin
  Result := Self;
  FConsumption.EmptyDataSet;
end;

function TConsumptionViewModel.Consumption: IZLMemTable;
begin
  Result := FConsumption;
end;

procedure TConsumptionViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
  DataSet.FieldByName('flg_active').AsInteger := 1;
end;

function TConsumptionViewModel.FromShowDTO(AInput: TConsumptionShowDTO): IConsumptionViewModel;
begin
  Result := Self;

  FConsumption.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TConsumptionViewModel.Make: IConsumptionViewModel;
begin
  Result := TConsumptionViewModel.Create;
end;

function TConsumptionViewModel.ToInputDTO: TConsumptionInputDTO;
begin
  FConsumption.UnsignEvents;
  try
    Result := TConsumptionInputDTO.FromJSON(Consumption.ToJson);
  finally
    SetEvents;
  end;
end;

end.


