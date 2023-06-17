unit uProductPriceLists.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uProduct.ViewModel.Interfaces;

type
  TProductPriceListsViewModel = class(TInterfacedObject, IProductPriceListsViewModel)
  private
    [weak]
    FOwner: IProductViewModel;
    FProductPriceLists: IZLMemTable;
    constructor Create(AOwner: IProductViewModel);
  public
    class function Make(AOwner: IProductViewModel): IProductPriceListsViewModel;
    function  ProductPriceLists: IZLMemTable;
    function  SetEvents: IProductPriceListsViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure PriceListIdSetText(Sender: TField; const Text: string);
  end;

implementation

{ TProductViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  uPriceList.Show.DTO,
  uPriceList.Service;

constructor TProductPriceListsViewModel.Create(AOwner: IProductViewModel);
begin
  inherited Create;
  FOwner := AOwner;

  FProductPriceLists := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('product_id', ftLargeint)
    .AddField('price_list_id', ftLargeint)
    .AddField('price', ftFloat)
    .AddField('price_list_name', ftString, 255)
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FProductPriceLists.DataSet);
  SetEvents;
end;

function TProductPriceListsViewModel.SetEvents: IProductPriceListsViewModel;
begin
  Result := Self;

  FProductPriceLists.DataSet.AfterInsert                    := AfterInsert;
  FProductPriceLists.FieldByName('price_list_id').OnSetText := PriceListIdSetText;
end;

procedure TProductPriceListsViewModel.PriceListIdSetText(Sender: TField; const Text: string);
begin
  Try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LPriceListShowDTO: SH<TPriceListShowDTO> = TPriceListService.Make.Show(Sender.AsLargeInt);
    if not Assigned(lPriceListShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('price_list_id').Clear;
      Sender.DataSet.FieldByName('price_list_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With lPriceListShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('price_list_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('price_list_name').AsString := name;
    end;
  Finally
    UnLockControl;
  End;
end;

function TProductPriceListsViewModel.ProductPriceLists: IZLMemTable;
begin
  Result := FProductPriceLists;
end;

procedure TProductPriceListsViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

class function TProductPriceListsViewModel.Make(AOwner: IProductViewModel): IProductPriceListsViewModel;
begin
  Result := Self.Create(AOwner);
end;

end.

