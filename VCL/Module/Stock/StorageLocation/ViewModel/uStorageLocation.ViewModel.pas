unit uStorageLocation.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uStorageLocation.ViewModel.Interfaces,
  uStorageLocation.Show.DTO,
  uStorageLocation.Input.DTO;

type
  TStorageLocationViewModel = class(TInterfacedObject, IStorageLocationViewModel)
  private
    FStorageLocation: IZLMemTable;
    constructor Create;
  public
    class function Make: IStorageLocationViewModel;
    function  FromShowDTO(AInput: TStorageLocationShowDTO): IStorageLocationViewModel;
    function  ToInputDTO: TStorageLocationInputDTO;
    function  EmptyDataSets: IStorageLocationViewModel;

    function  StorageLocation: IZLMemTable;

    function  SetEvents: IStorageLocationViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TStorageLocationViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TStorageLocationViewModel.Create;
begin
  inherited Create;

  FStorageLocation := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('name', ftString, 100)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeInt)
    .AddField('updated_by_acl_user_id', ftLargeInt)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FStorageLocation.DataSet);
  SetEvents;
end;

procedure TStorageLocationViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TStorageLocationViewModel.SetEvents: IStorageLocationViewModel;
begin
  Result := Self;
  FStorageLocation.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FStorageLocation.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TStorageLocationViewModel.EmptyDataSets: IStorageLocationViewModel;
begin
  Result := Self;
  FStorageLocation.EmptyDataSet;
end;

function TStorageLocationViewModel.StorageLocation: IZLMemTable;
begin
  Result := FStorageLocation;
end;

procedure TStorageLocationViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TStorageLocationViewModel.FromShowDTO(AInput: TStorageLocationShowDTO): IStorageLocationViewModel;
begin
  Result := Self;

  FStorageLocation.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TStorageLocationViewModel.Make: IStorageLocationViewModel;
begin
  Result := TStorageLocationViewModel.Create;
end;

function TStorageLocationViewModel.ToInputDTO: TStorageLocationInputDTO;
begin
  FStorageLocation.UnsignEvents;
  try
    Result := TStorageLocationInputDTO.FromJSON(StorageLocation.ToJson);
  finally
    SetEvents;
  end;
end;

end.


