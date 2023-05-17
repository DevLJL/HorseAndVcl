unit uUnit.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uUnit.ViewModel.Interfaces,
  uUnit.Show.DTO,
  uUnit.Input.DTO;

type
  TUnitViewModel = class(TInterfacedObject, IUnitViewModel)
  private
    FUnit: IZLMemTable;
    constructor Create;
  public
    class function Make: IUnitViewModel;
    function  FromShowDTO(AInput: TUnitShowDTO): IUnitViewModel;
    function  ToInputDTO: TUnitInputDTO;
    function  EmptyDataSets: IUnitViewModel;

    function  &Unit: IZLMemTable;

    function  SetEvents: IUnitViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TUnitViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TUnitViewModel.Create;
begin
  inherited Create;

  FUnit := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('name', ftString, 10)
    .AddField('description', ftString, 100)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeInt)
    .AddField('updated_by_acl_user_id', ftLargeInt)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FUnit.DataSet);
  SetEvents;
end;

procedure TUnitViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TUnitViewModel.SetEvents: IUnitViewModel;
begin
  Result := Self;
  FUnit.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FUnit.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TUnitViewModel.EmptyDataSets: IUnitViewModel;
begin
  Result := Self;
  FUnit.EmptyDataSet;
end;

function TUnitViewModel.&Unit: IZLMemTable;
begin
  Result := FUnit;
end;

procedure TUnitViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TUnitViewModel.FromShowDTO(AInput: TUnitShowDTO): IUnitViewModel;
begin
  Result := Self;

  FUnit.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TUnitViewModel.Make: IUnitViewModel;
begin
  Result := TUnitViewModel.Create;
end;

function TUnitViewModel.ToInputDTO: TUnitInputDTO;
begin
  FUnit.UnsignEvents;
  try
    Result := TUnitInputDTO.FromJSON(&Unit.ToJson);
  finally
    SetEvents;
  end;
end;

end.


