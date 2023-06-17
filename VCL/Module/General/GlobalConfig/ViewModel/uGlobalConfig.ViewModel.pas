unit uGlobalConfig.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uGlobalConfig.ViewModel.Interfaces,
  uGlobalConfig.Show.DTO,
  uGlobalConfig.Input.DTO;

type
  TGlobalConfigViewModel = class(TInterfacedObject, IGlobalConfigViewModel)
  private
    FGlobalConfig: IZLMemTable;
    constructor Create;
  public
    class function Make: IGlobalConfigViewModel;
    function  FromShowDTO(AInput: TGlobalConfigShowDTO): IGlobalConfigViewModel;
    function  ToInputDTO: TGlobalConfigInputDTO;
    function  EmptyDataSets: IGlobalConfigViewModel;
    function  GlobalConfig: IZLMemTable;
    function  SetEvents: IGlobalConfigViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TGlobalConfigViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TGlobalConfigViewModel.Create;
begin
  inherited Create;

  FGlobalConfig := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('pdv_edit_item_before_register', ftSmallint)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeInt)
    .AddField('updated_by_acl_user_id', ftLargeInt)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FGlobalConfig.DataSet);
  SetEvents;
end;

procedure TGlobalConfigViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TGlobalConfigViewModel.SetEvents: IGlobalConfigViewModel;
begin
  Result := Self;

  FGlobalConfig.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FGlobalConfig.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TGlobalConfigViewModel.EmptyDataSets: IGlobalConfigViewModel;
begin
  Result := Self;
  FGlobalConfig.EmptyDataSet;
end;

function TGlobalConfigViewModel.GlobalConfig: IZLMemTable;
begin
  Result := FGlobalConfig;
end;

procedure TGlobalConfigViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TGlobalConfigViewModel.FromShowDTO(AInput: TGlobalConfigShowDTO): IGlobalConfigViewModel;
begin
  Result := Self;

  // GlobalConfig
  FGlobalConfig.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TGlobalConfigViewModel.Make: IGlobalConfigViewModel;
begin
  Result := Self.Create;
end;

function TGlobalConfigViewModel.ToInputDTO: TGlobalConfigInputDTO;
begin
  Try
    FGlobalConfig.UnsignEvents;

    // GlobalConfig
    Result := TGlobalConfigInputDTO.FromJSON(GlobalConfig.ToJson);
  Finally
    SetEvents;
  End;
end;

end.


