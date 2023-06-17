unit uConsumptionSale.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uConsumptionSale.ViewModel.Interfaces;

type
  TConsumptionSaleViewModel = class(TInterfacedObject, IConsumptionSaleViewModel)
  private
    FConsumptionSale: IZLMemTable;
    constructor Create;
  public
    class function Make: IConsumptionSaleViewModel;
    function  EmptyDataSets: IConsumptionSaleViewModel;
    function  ConsumptionSale: IZLMemTable;
    function  SetEvents: IConsumptionSaleViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure SaleTotalGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure SaleAmountOfPeopleGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure NumberGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TConsumptionSaleViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TConsumptionSaleViewModel.Create;
begin
  inherited Create;

  FConsumptionSale := TMemTableFactory.Make
    .AddField('number', ftSmallint)
    .AddField('flg_active', ftSmallint)
    .AddField('sale_id', ftLargeint)
    .AddField('sale_amount_of_people', ftSmallint)
    .AddField('sale_total', ftFloat)
    .AddField('sale_created_at', ftDateTime)
    .AddField('sale_status', ftSmallint)
    .AddField('sale_type', ftSmallint)
    .AddField('sale_flg_payment_requested', ftSmallint)
    .AddField('sale_updated_at', ftDateTime)
    .AddField('sale_dwell_time_in_minutes', ftString)
    .AddField('sale_last_update_in_minutes', ftString)
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FConsumptionSale.DataSet);
  SetEvents;
end;

procedure TConsumptionSaleViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

procedure TConsumptionSaleViewModel.SaleAmountOfPeopleGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := Format('%2.2d', [Sender.AsInteger]);
end;

procedure TConsumptionSaleViewModel.SaleTotalGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := Format('R$ %.2n', [Sender.AsFloat]);
end;

function TConsumptionSaleViewModel.SetEvents: IConsumptionSaleViewModel;
begin
  Result := Self;
  FConsumptionSale.DataSet.AfterInsert := AfterInsert;
  FConsumptionSale.FieldByName('sale_total').OnGetText            := SaleTotalGetText;
  FConsumptionSale.FieldByName('sale_amount_of_people').OnGetText := SaleAmountOfPeopleGetText;
  FConsumptionSale.FieldByName('number').OnGetText                := NumberGetText;

  // Evitar Data Inválida
  for var LField in FConsumptionSale.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TConsumptionSaleViewModel.EmptyDataSets: IConsumptionSaleViewModel;
begin
  Result := Self;
  FConsumptionSale.EmptyDataSet;
end;

function TConsumptionSaleViewModel.ConsumptionSale: IZLMemTable;
begin
  Result := FConsumptionSale;
end;

procedure TConsumptionSaleViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
  DataSet.FieldByName('sale_amount_of_people').AsInteger := 1;
end;

class function TConsumptionSaleViewModel.Make: IConsumptionSaleViewModel;
begin
  Result := TConsumptionSaleViewModel.Create;
end;

procedure TConsumptionSaleViewModel.NumberGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := Format('%3.3d', [Sender.AsInteger]);
end;

end.


