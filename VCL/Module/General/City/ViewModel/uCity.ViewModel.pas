unit uCity.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uCity.ViewModel.Interfaces,
  uCity.Show.DTO,
  uCity.Input.DTO;

type
  TCityViewModel = class(TInterfacedObject, ICityViewModel)
  private
    FCity: IZLMemTable;
    constructor Create;
  public
    class function Make: ICityViewModel;
    function  FromShowDTO(AInput: TCityShowDTO): ICityViewModel;
    function  ToInputDTO: TCityInputDTO;
    function  EmptyDataSets: ICityViewModel;

    function  City: IZLMemTable;

    function  SetEvents: ICityViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TCityViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TCityViewModel.Create;
begin
  inherited Create;

  FCity := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('name', ftString, 100)
    .AddField('state', ftString, 2)
    .AddField('country', ftString, 100)
    .AddField('ibge_code', ftString, 30)
    .AddField('country_ibge_code', ftString, 30)
    .AddField('identification', ftString, 100)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeint)
    .AddField('updated_by_acl_user_id', ftLargeint)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FCity.DataSet);
  SetEvents;
end;

procedure TCityViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TCityViewModel.SetEvents: ICityViewModel;
begin
  Result := Self;
  FCity.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FCity.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TCityViewModel.EmptyDataSets: ICityViewModel;
begin
  Result := Self;
  FCity.EmptyDataSet;
end;

function TCityViewModel.City: IZLMemTable;
begin
  Result := FCity;
end;

procedure TCityViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TCityViewModel.FromShowDTO(AInput: TCityShowDTO): ICityViewModel;
begin
  Result := Self;

  FCity.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TCityViewModel.Make: ICityViewModel;
begin
  Result := Self.Create;
end;

function TCityViewModel.ToInputDTO: TCityInputDTO;
begin
  FCity.UnsignEvents;
  try
    Result := TCityInputDTO.FromJSON(City.ToJson);
  finally
    SetEvents;
  end;
end;

end.
