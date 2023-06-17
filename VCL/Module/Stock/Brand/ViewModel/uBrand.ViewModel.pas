unit uBrand.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uBrand.ViewModel.Interfaces,
  uBrand.Show.DTO,
  uBrand.Input.DTO;

type
  TBrandViewModel = class(TInterfacedObject, IBrandViewModel)
  private
    FBrand: IZLMemTable;
    constructor Create;
  public
    class function Make: IBrandViewModel;
    function  FromShowDTO(AInput: TBrandShowDTO): IBrandViewModel;
    function  ToInputDTO: TBrandInputDTO;
    function  EmptyDataSets: IBrandViewModel;

    function  Brand: IZLMemTable;

    function  SetEvents: IBrandViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TBrandViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TBrandViewModel.Create;
begin
  inherited Create;

  FBrand := TMemTableFactory.Make
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
  FormatDataSet(FBrand.DataSet);
  SetEvents;
end;

procedure TBrandViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TBrandViewModel.SetEvents: IBrandViewModel;
begin
  Result := Self;
  FBrand.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FBrand.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TBrandViewModel.EmptyDataSets: IBrandViewModel;
begin
  Result := Self;
  FBrand.EmptyDataSet;
end;

function TBrandViewModel.Brand: IZLMemTable;
begin
  Result := FBrand;
end;

procedure TBrandViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TBrandViewModel.FromShowDTO(AInput: TBrandShowDTO): IBrandViewModel;
begin
  Result := Self;

  FBrand.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TBrandViewModel.Make: IBrandViewModel;
begin
  Result := TBrandViewModel.Create;
end;

function TBrandViewModel.ToInputDTO: TBrandInputDTO;
begin
  FBrand.UnsignEvents;
  try
    Result := TBrandInputDTO.FromJSON(Brand.ToJson);
  finally
    SetEvents;
  end;
end;

end.


