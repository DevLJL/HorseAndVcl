unit uCategory.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uCategory.ViewModel.Interfaces,
  uCategory.Show.DTO,
  uCategory.Input.DTO;

type
  TCategoryViewModel = class(TInterfacedObject, ICategoryViewModel)
  private
    FCategory: IZLMemTable;
    constructor Create;
  public
    class function Make: ICategoryViewModel;
    function  FromShowDTO(AInput: TCategoryShowDTO): ICategoryViewModel;
    function  ToInputDTO: TCategoryInputDTO;
    function  EmptyDataSets: ICategoryViewModel;

    function  Category: IZLMemTable;

    function  SetEvents: ICategoryViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TCategoryViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TCategoryViewModel.Create;
begin
  inherited Create;

  FCategory := TMemTableFactory.Make
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
  FormatDataSet(FCategory.DataSet);
  SetEvents;
end;

procedure TCategoryViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TCategoryViewModel.SetEvents: ICategoryViewModel;
begin
  Result := Self;
  FCategory.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FCategory.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TCategoryViewModel.EmptyDataSets: ICategoryViewModel;
begin
  Result := Self;
  FCategory.EmptyDataSet;
end;

function TCategoryViewModel.Category: IZLMemTable;
begin
  Result := FCategory;
end;

procedure TCategoryViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TCategoryViewModel.FromShowDTO(AInput: TCategoryShowDTO): ICategoryViewModel;
begin
  Result := Self;

  FCategory.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TCategoryViewModel.Make: ICategoryViewModel;
begin
  Result := TCategoryViewModel.Create;
end;

function TCategoryViewModel.ToInputDTO: TCategoryInputDTO;
begin
  FCategory.UnsignEvents;
  try
    Result := TCategoryInputDTO.FromJSON(Category.ToJson);
  finally
    SetEvents;
  end;
end;

end.


