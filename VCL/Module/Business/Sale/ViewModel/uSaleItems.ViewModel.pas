unit uSaleItems.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uSale.ViewModel.Interfaces;

type
  TSaleItemsViewModel = class(TInterfacedObject, ISaleItemsViewModel)
  private
    [weak]
    FOwner: ISaleViewModel;
    FSaleItems: IZLMemTable;
    constructor Create(AOwner: ISaleViewModel);
  public
    class function Make(AOwner: ISaleViewModel): ISaleItemsViewModel;
    function  SaleItems: IZLMemTable;
    function  SetEvents: ISaleItemsViewModel;
    function  CurrentCalcFields: ISaleItemsViewModel;
    procedure QuantityPriceUnitDiscountSetText(Sender: TField; const Text: string);
    procedure AfterInsert(DataSet: TDataSet);
    procedure BeforePost(DataSet: TDataSet);
    procedure AfterPostDelete(DataSet: TDataSet);
  end;

implementation

{ TSaleViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils;

procedure TSaleItemsViewModel.AfterPostDelete(DataSet: TDataSet);
begin
  FOwner.CalcFields;
end;

procedure TSaleItemsViewModel.BeforePost(DataSet: TDataSet);
begin
  CurrentCalcFields;
end;

constructor TSaleItemsViewModel.Create(AOwner: ISaleViewModel);
begin
  inherited Create;
  FOwner := AOwner;

  FSaleItems := TMemTableFactory.Make
    .AddField('id', ftLargeInt)
    .AddField('sale_id', ftLargeInt)
    .AddField('product_id', ftLargeInt)
    .AddField('quantity', ftFloat)
    .AddField('price', ftFloat)
    .AddField('unit_discount', ftFloat)
    .AddField('subtotal', ftFloat)
    .AddField('total', ftFloat)
    .AddField('seller_id', ftLargeInt)
    .AddField('note', ftString, 5000)
    .AddField('product_name', ftString, 255) {virtual}
    .AddField('product_unit_name', ftString, 10) {virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FSaleItems.DataSet);
  SetEvents;
end;

function TSaleItemsViewModel.CurrentCalcFields: ISaleItemsViewModel;
begin
  const LKeepGoing = FSaleItems.Active and (FSaleItems.State in [dsInsert, dsEdit]);
  if not LKeepGoing then
    Exit;

  With FSaleItems do
  begin
    FieldByName('subtotal').AsFloat := FieldByName('quantity').AsFloat * FieldByName('price').AsFloat;
    FieldByName('total').AsFloat    := FieldByName('subtotal').AsFloat - (FieldByName('quantity').AsFloat * FieldByName('unit_discount').AsFloat);
  end;
end;

function TSaleItemsViewModel.SetEvents: ISaleItemsViewModel;
begin
  Result := Self;
  FSaleItems.DataSet.AfterInsert                    := AfterInsert;
  FSaleItems.DataSet.BeforePost                     := BeforePost;
  FSaleItems.DataSet.AfterPost                      := AfterPostDelete;
  FSaleItems.DataSet.AfterDelete                    := AfterPostDelete;
  FSaleItems.FieldByName('quantity').OnSetText      := QuantityPriceUnitDiscountSetText;
  FSaleItems.FieldByName('price').OnSetText         := QuantityPriceUnitDiscountSetText;
  FSaleItems.FieldByName('unit_discount').OnSetText := QuantityPriceUnitDiscountSetText;
end;

function TSaleItemsViewModel.SaleItems: IZLMemTable;
begin
  Result := FSaleItems;
end;

procedure TSaleItemsViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

class function TSaleItemsViewModel.Make(AOwner: ISaleViewModel): ISaleItemsViewModel;
begin
  Result := Self.Create(AOwner);
end;

procedure TSaleItemsViewModel.QuantityPriceUnitDiscountSetText(Sender: TField; const Text: string);
begin
  Sender.AsFloat := StrFloat(Text);
  CurrentCalcFields;
end;

end.

