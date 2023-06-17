unit uPriceList.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uPriceList.ViewModel.Interfaces,
  uPriceList.Show.DTO,
  uPriceList.Input.DTO;

type
  TPriceListViewModel = class(TInterfacedObject, IPriceListViewModel)
  private
    FPriceList: IZLMemTable;
    constructor Create;
  public
    class function Make: IPriceListViewModel;
    function  FromShowDTO(AInput: TPriceListShowDTO): IPriceListViewModel;
    function  ToInputDTO: TPriceListInputDTO;
    function  EmptyDataSets: IPriceListViewModel;

    function  PriceList: IZLMemTable;

    function  SetEvents: IPriceListViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TPriceListViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TPriceListViewModel.Create;
begin
  inherited Create;

  FPriceList := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('name', ftString, 100)
    .AddField('short_description', ftString, 100)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeInt)
    .AddField('updated_by_acl_user_id', ftLargeInt)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FPriceList.DataSet);
  SetEvents;
end;

procedure TPriceListViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TPriceListViewModel.SetEvents: IPriceListViewModel;
begin
  Result := Self;
  FPriceList.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FPriceList.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TPriceListViewModel.EmptyDataSets: IPriceListViewModel;
begin
  Result := Self;
  FPriceList.EmptyDataSet;
end;

function TPriceListViewModel.PriceList: IZLMemTable;
begin
  Result := FPriceList;
end;

procedure TPriceListViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TPriceListViewModel.FromShowDTO(AInput: TPriceListShowDTO): IPriceListViewModel;
begin
  Result := Self;

  FPriceList.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TPriceListViewModel.Make: IPriceListViewModel;
begin
  Result := TPriceListViewModel.Create;
end;

function TPriceListViewModel.ToInputDTO: TPriceListInputDTO;
begin
  FPriceList.UnsignEvents;
  try
    Result := TPriceListInputDTO.FromJSON(PriceList.ToJson);
  finally
    SetEvents;
  end;
end;

end.


