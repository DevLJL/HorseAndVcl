unit uProduct.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uProduct.ViewModel.Interfaces,
  uProduct.Show.DTO,
  uProduct.Input.DTO;

type
  TProductViewModel = class(TInterfacedObject, IProductViewModel)
  private
    FProduct: IZLMemTable;
    constructor Create;
  public
    class function Make: IProductViewModel;
    function  FromShowDTO(AInput: TProductShowDTO): IProductViewModel;
    function  ToInputDTO: TProductInputDTO;
    function  EmptyDataSets: IProductViewModel;

    function  Product: IZLMemTable;

    function  SetEvents: IProductViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure BrandIdSetText(Sender: TField; const Text: string);
    procedure CategoryIdSetText(Sender: TField; const Text: string);
    procedure NcmIdSetText(Sender: TField; const Text: string);
    procedure SizeIdSetText(Sender: TField; const Text: string);
    procedure StorageLocationIdSetText(Sender: TField; const Text: string);
    procedure UnitIdSetText(Sender: TField; const Text: string);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TProductViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject,
  uBrand.Show.DTO,
  uBrand.Service,
  uCategory.Show.DTO,
  uCategory.Service,
  uSize.Show.DTO,
  uSize.Service,
  uStorageLocation.Show.DTO,
  uStorageLocation.Service,
  uNcm.Show.DTO,
  uNcm.Service,
  uUnit.Show.DTO,
  uUnit.Service;

constructor TProductViewModel.Create;
begin
  inherited Create;

  FProduct := TMemTableFactory.Make
    .AddField('id',                       ftLargeint)
    .AddField('name',                     ftString, 255)
    .AddField('simplified_name',          ftString, 30)
    .AddField('type',                     ftSmallint)
    .AddField('sku_code',                 ftString, 45)
    .AddField('ean_code',                 ftString, 45)
    .AddField('manufacturing_code',       ftString, 45)
    .AddField('identification_code',      ftString, 45)
    .AddField('cost',                     ftFloat)
    .AddField('marketup',                 ftFloat)
    .AddField('price',                    ftFloat)
    .AddField('current_quantity',         ftFloat)
    .AddField('minimum_quantity',         ftFloat)
    .AddField('maximum_quantity',         ftFloat)
    .AddField('gross_weight',             ftFloat)
    .AddField('net_weight',               ftFloat)
    .AddField('packing_weight',           ftFloat)
    .AddField('flg_to_move_the_stock',     ftSmallint)
    .AddField('flg_product_for_scales',    ftSmallint)
    .AddField('internal_note',            ftString, 5000)
    .AddField('complement_note',          ftString, 5000)
    .AddField('flg_discontinued',          ftSmallint)
    .AddField('unit_id',                  ftInteger)
    .AddField('ncm_id',                   ftLargeint)
    .AddField('category_id',              ftLargeint)
    .AddField('brand_id',                 ftLargeint)
    .AddField('size_id',                  ftLargeint)
    .AddField('storage_location_id',      ftLargeint)
    .AddField('genre',                    ftSmallint)
    .AddField('created_at',               ftDateTime)
    .AddField('updated_at',               ftDateTime)
    .AddField('created_by_acl_user_id',   ftLargeint)
    .AddField('created_by_acl_user_name', ftString, 100)
    .AddField('updated_by_acl_user_id',   ftLargeint)
    .AddField('updated_by_acl_user_name', ftString, 100)
    .AddField('unit_name',                ftString, 10) {virtual}
    .AddField('ncm_code',                 ftString, 8) {virtual}
    .AddField('ncm_name',                 ftString, 255) {virtual}
    .AddField('category_name',            ftString, 100) {virtual}
    .AddField('brand_name',               ftString, 100) {virtual}
    .AddField('size_name',                ftString, 100) {virtual}
    .AddField('storage_location_name',    ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FProduct.DataSet);
  SetEvents;
end;

procedure TProductViewModel.BrandIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LBrandShowDTO: SH<TBrandShowDTO> = TBrandService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LBrandShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('brand_id').Clear;
      Sender.DataSet.FieldByName('brand_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LBrandShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('brand_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('brand_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

procedure TProductViewModel.CategoryIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LCategoryShowDTO: SH<TCategoryShowDTO> = TCategoryService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LCategoryShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('category_id').Clear;
      Sender.DataSet.FieldByName('category_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LCategoryShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('category_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('category_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

procedure TProductViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TProductViewModel.SetEvents: IProductViewModel;
begin
  Result := Self;
  FProduct.DataSet.AfterInsert := AfterInsert;
  FProduct.FieldByName('unit_id').OnSetText             := UnitIdSetText;
  FProduct.FieldByName('ncm_id').OnSetText              := NcmIdSetText;
  FProduct.FieldByName('category_id').OnSetText         := CategoryIdSetText;
  FProduct.FieldByName('brand_id').OnSetText            := BrandIdSetText;
  FProduct.FieldByName('size_id').OnSetText             := SizeIdSetText;
  FProduct.FieldByName('storage_location_id').OnSetText := StorageLocationIdSetText;

  // Evitar Data Inválida
  for var LField in FProduct.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

procedure TProductViewModel.SizeIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LSizeShowDTO: SH<TSizeShowDTO> = TSizeService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LSizeShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('size_id').Clear;
      Sender.DataSet.FieldByName('size_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LSizeShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('size_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('size_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

procedure TProductViewModel.StorageLocationIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LStorageLocationShowDTO: SH<TStorageLocationShowDTO> = TStorageLocationService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LStorageLocationShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('storage_location_id').Clear;
      Sender.DataSet.FieldByName('storage_location_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LStorageLocationShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('storage_location_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('storage_location_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

function TProductViewModel.EmptyDataSets: IProductViewModel;
begin
  Result := Self;
  FProduct.EmptyDataSet;
end;

function TProductViewModel.Product: IZLMemTable;
begin
  Result := FProduct;
end;

procedure TProductViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
  DataSet.FieldByName('unit_id').AsInteger               := 1;
  DataSet.FieldByName('unit_name').AsString              := 'UN';
  DataSet.FieldByName('ncm_id').AsInteger                := 1;
  DataSet.FieldByName('ncm_code').AsString               := '99';
  DataSet.FieldByName('ncm_name').AsString               := 'Não Informado';
  DataSet.FieldByName('flg_to_move_the_stock').AsInteger  := 1;
end;

function TProductViewModel.FromShowDTO(AInput: TProductShowDTO): IProductViewModel;
begin
  Result := Self;

  FProduct.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TProductViewModel.Make: IProductViewModel;
begin
  Result := TProductViewModel.Create;
end;

procedure TProductViewModel.NcmIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LNcmShowDTO: SH<TNcmShowDTO> = TNcmService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LNcmShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('ncm_id').Clear;
      Sender.DataSet.FieldByName('ncm_code').Clear;
      Sender.DataSet.FieldByName('ncm_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LNcmShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('ncm_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('ncm_code').AsString := code;
      Sender.DataSet.FieldByName('ncm_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

function TProductViewModel.ToInputDTO: TProductInputDTO;
begin
  FProduct.UnsignEvents;
  try
    Result := TProductInputDTO.FromJSON(Product.ToJson);
  finally
    SetEvents;
  end;
end;

procedure TProductViewModel.UnitIdSetText(Sender: TField; const Text: string);
begin
  try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LUnitShowDTO: SH<TUnitShowDTO> = TUnitService.Make.Show(Sender.AsLargeInt);
    if not Assigned(LUnitShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('unit_id').Clear;
      Sender.DataSet.FieldByName('unit_name').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With LUnitShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('unit_id').AsLargeInt := id;
      Sender.DataSet.FieldByName('unit_name').AsString := name;
    end;
  finally
    UnlockControl;
  end;
end;

end.


