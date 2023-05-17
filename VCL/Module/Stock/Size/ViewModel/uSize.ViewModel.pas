unit uSize.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uSize.ViewModel.Interfaces,
  uSize.Show.DTO,
  uSize.Input.DTO;

type
  TSizeViewModel = class(TInterfacedObject, ISizeViewModel)
  private
    FSize: IZLMemTable;
    constructor Create;
  public
    class function Make: ISizeViewModel;
    function  FromShowDTO(AInput: TSizeShowDTO): ISizeViewModel;
    function  ToInputDTO: TSizeInputDTO;
    function  EmptyDataSets: ISizeViewModel;

    function  Size: IZLMemTable;

    function  SetEvents: ISizeViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TSizeViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TSizeViewModel.Create;
begin
  inherited Create;

  FSize := TMemTableFactory.Make
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
  FormatDataSet(FSize.DataSet);
  SetEvents;
end;

procedure TSizeViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TSizeViewModel.SetEvents: ISizeViewModel;
begin
  Result := Self;
  FSize.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FSize.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TSizeViewModel.EmptyDataSets: ISizeViewModel;
begin
  Result := Self;
  FSize.EmptyDataSet;
end;

function TSizeViewModel.Size: IZLMemTable;
begin
  Result := FSize;
end;

procedure TSizeViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TSizeViewModel.FromShowDTO(AInput: TSizeShowDTO): ISizeViewModel;
begin
  Result := Self;

  FSize.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TSizeViewModel.Make: ISizeViewModel;
begin
  Result := TSizeViewModel.Create;
end;

function TSizeViewModel.ToInputDTO: TSizeInputDTO;
begin
  FSize.UnsignEvents;
  try
    Result := TSizeInputDTO.FromJSON(Size.ToJson);
  finally
    SetEvents;
  end;
end;

end.


