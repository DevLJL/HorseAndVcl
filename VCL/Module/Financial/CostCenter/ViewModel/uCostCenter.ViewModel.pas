unit uCostCenter.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uCostCenter.ViewModel.Interfaces,
  uCostCenter.Show.DTO,
  uCostCenter.Input.DTO;

type
  TCostCenterViewModel = class(TInterfacedObject, ICostCenterViewModel)
  private
    FCostCenter: IZLMemTable;
    constructor Create;
  public
    class function Make: ICostCenterViewModel;
    function  FromShowDTO(AInput: TCostCenterShowDTO): ICostCenterViewModel;
    function  ToInputDTO: TCostCenterInputDTO;
    function  EmptyDataSets: ICostCenterViewModel;

    function  CostCenter: IZLMemTable;

    function  SetEvents: ICostCenterViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TCostCenterViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TCostCenterViewModel.Create;
begin
  inherited Create;

  FCostCenter := TMemTableFactory.Make
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
  FormatDataSet(FCostCenter.DataSet);
  SetEvents;
end;

procedure TCostCenterViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TCostCenterViewModel.SetEvents: ICostCenterViewModel;
begin
  Result := Self;
  FCostCenter.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FCostCenter.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TCostCenterViewModel.EmptyDataSets: ICostCenterViewModel;
begin
  Result := Self;
  FCostCenter.EmptyDataSet;
end;

function TCostCenterViewModel.CostCenter: IZLMemTable;
begin
  Result := FCostCenter;
end;

procedure TCostCenterViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TCostCenterViewModel.FromShowDTO(AInput: TCostCenterShowDTO): ICostCenterViewModel;
begin
  Result := Self;

  FCostCenter.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TCostCenterViewModel.Make: ICostCenterViewModel;
begin
  Result := TCostCenterViewModel.Create;
end;

function TCostCenterViewModel.ToInputDTO: TCostCenterInputDTO;
begin
  FCostCenter.UnsignEvents;
  try
    Result := TCostCenterInputDTO.FromJSON(CostCenter.ToJson);
  finally
    SetEvents;
  end;
end;

end.


