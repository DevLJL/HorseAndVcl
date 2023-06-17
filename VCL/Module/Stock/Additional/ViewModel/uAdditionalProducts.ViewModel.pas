unit uAdditionalProducts.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uAdditional.ViewModel.Interfaces;

type
  TAdditionalProductsViewModel = class(TInterfacedObject, IAdditionalProductsViewModel)
  private
    [weak]
    FOwner: IAdditionalViewModel;
    FAdditionalProducts: IZLMemTable;
    constructor Create(AOwner: IAdditionalViewModel);
  public
    class function Make(AOwner: IAdditionalViewModel): IAdditionalProductsViewModel;
    function  AdditionalProducts: IZLMemTable;
    function  SetEvents: IAdditionalProductsViewModel;
    procedure AfterInsert(DataSet: TDataSet);
  end;

implementation

{ TAdditionalViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils;

constructor TAdditionalProductsViewModel.Create(AOwner: IAdditionalViewModel);
begin
  inherited Create;
  FOwner := AOwner;

  FAdditionalProducts := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('additional_id', ftLargeint)
    .AddField('product_id', ftLargeint)
    .AddField('product_name', ftString, 255) {Virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FAdditionalProducts.DataSet);
  SetEvents;
end;

function TAdditionalProductsViewModel.SetEvents: IAdditionalProductsViewModel;
begin
  Result := Self;

  FAdditionalProducts.DataSet.AfterInsert := AfterInsert;
end;

function TAdditionalProductsViewModel.AdditionalProducts: IZLMemTable;
begin
  Result := FAdditionalProducts;
end;

procedure TAdditionalProductsViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

class function TAdditionalProductsViewModel.Make(AOwner: IAdditionalViewModel): IAdditionalProductsViewModel;
begin
  Result := Self.Create(AOwner);
end;

end.

