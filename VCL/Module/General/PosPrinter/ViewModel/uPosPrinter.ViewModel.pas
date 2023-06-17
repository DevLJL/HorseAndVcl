unit uPosPrinter.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uPosPrinter.ViewModel.Interfaces,
  uPosPrinter.Show.DTO,
  uPosPrinter.Input.DTO;

type
  TPosPrinterViewModel = class(TInterfacedObject, IPosPrinterViewModel)
  private
    FPosPrinter: IZLMemTable;
    constructor Create;
  public
    class function Make: IPosPrinterViewModel;
    function  FromShowDTO(AInput: TPosPrinterShowDTO): IPosPrinterViewModel;
    function  ToInputDTO: TPosPrinterInputDTO;
    function  EmptyDataSets: IPosPrinterViewModel;

    function  PosPrinter: IZLMemTable;

    function  SetEvents: IPosPrinterViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TPosPrinterViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TPosPrinterViewModel.Create;
begin
  inherited Create;

  FPosPrinter := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('name', ftString, 100)
    .AddField('model', ftSmallint)
    .AddField('port', ftString, 100)
    .AddField('columns', ftSmallint)
    .AddField('space_between_lines', ftSmallint)
    .AddField('buffer', ftSmallint)
    .AddField('font_size', ftSmallint)
    .AddField('blank_lines_to_end', ftSmallint)
    .AddField('flg_port_control', ftSmallint)
    .AddField('flg_translate_tags', ftSmallint)
    .AddField('flg_ignore_tags', ftSmallint)
    .AddField('flg_paper_cut', ftSmallint)
    .AddField('flg_partial_paper_cut', ftSmallint)
    .AddField('flg_send_cut_written_command', ftSmallint)
    .AddField('page_code', ftSmallint)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeint)
    .AddField('updated_by_acl_user_id', ftLargeint)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FPosPrinter.DataSet);
  SetEvents;
end;

procedure TPosPrinterViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TPosPrinterViewModel.SetEvents: IPosPrinterViewModel;
begin
  Result := Self;
  FPosPrinter.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FPosPrinter.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TPosPrinterViewModel.EmptyDataSets: IPosPrinterViewModel;
begin
  Result := Self;
  FPosPrinter.EmptyDataSet;
end;

function TPosPrinterViewModel.PosPrinter: IZLMemTable;
begin
  Result := FPosPrinter;
end;

procedure TPosPrinterViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
  DataSet.FieldByName('columns').AsInteger             := 48;
  DataSet.FieldByName('space_between_lines').AsInteger := 5;
  DataSet.FieldByName('font_size').AsInteger           := 1;
  DataSet.FieldByName('blank_lines_to_end').AsInteger  := 4;
  DataSet.FieldByName('flg_translate_tags').AsInteger  := 1;
  DataSet.FieldByName('page_code').AsInteger           := 6;
end;

function TPosPrinterViewModel.FromShowDTO(AInput: TPosPrinterShowDTO): IPosPrinterViewModel;
begin
  Result := Self;

  FPosPrinter.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TPosPrinterViewModel.Make: IPosPrinterViewModel;
begin
  Result := TPosPrinterViewModel.Create;
end;

function TPosPrinterViewModel.ToInputDTO: TPosPrinterInputDTO;
begin
  FPosPrinter.UnsignEvents;
  try
    Result := TPosPrinterInputDTO.FromJSON(PosPrinter.ToJson);
  finally
    SetEvents;
  end;
end;

end.


