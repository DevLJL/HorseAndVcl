unit uStation.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uStation.ViewModel.Interfaces,
  uStation.Show.DTO,
  uStation.Input.DTO;

type
  TStationViewModel = class(TInterfacedObject, IStationViewModel)
  private
    FStation: IZLMemTable;
    constructor Create;
  public
    class function Make: IStationViewModel;
    function  FromShowDTO(AInput: TStationShowDTO): IStationViewModel;
    function  ToInputDTO: TStationInputDTO;
    function  EmptyDataSets: IStationViewModel;

    function  Station: IZLMemTable;

    function  SetEvents: IStationViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TStationViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TStationViewModel.Create;
begin
  inherited Create;

  FStation := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('name', ftString, 100)
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FStation.DataSet);
  SetEvents;
end;

procedure TStationViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TStationViewModel.SetEvents: IStationViewModel;
begin
  Result := Self;
  FStation.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FStation.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TStationViewModel.EmptyDataSets: IStationViewModel;
begin
  Result := Self;
  FStation.EmptyDataSet;
end;

function TStationViewModel.Station: IZLMemTable;
begin
  Result := FStation;
end;

procedure TStationViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TStationViewModel.FromShowDTO(AInput: TStationShowDTO): IStationViewModel;
begin
  Result := Self;

  FStation.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TStationViewModel.Make: IStationViewModel;
begin
  Result := TStationViewModel.Create;
end;

function TStationViewModel.ToInputDTO: TStationInputDTO;
begin
  FStation.UnsignEvents;
  try
    Result := TStationInputDTO.FromJSON(Station.ToJson);
  finally
    SetEvents;
  end;
end;

end.


