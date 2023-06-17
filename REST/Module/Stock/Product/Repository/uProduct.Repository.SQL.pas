unit uProduct.Repository.SQL;

interface

uses
  uBase.Repository,
  uProduct.Repository.Interfaces,
  uProduct.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uProduct,
  uProduct.Types,
  uProductPriceList;

type
  TProductRepositorySQL = class(TBaseRepository, IProductRepository)
  private
    FProductSQLBuilder: IProductSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IProductSQLBuilder);
    function DataSetToEntity(ADtsProduct: TDataSet): TBaseEntity; override;
    function DataSetToProductPriceList(ADtsProductPriceList: TDataSet): TProductPriceList;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
    function FieldExists(AColumName, AColumnValue: String; AId: Int64): Boolean;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IProductSQLBuilder): IProductRepository;
    function Show(AId: Int64): TProduct;
    function ShowByEanOrSkuCode(AValue: String): TProduct;
    function MoveProduct(AProductId: Int64; AIncOrDecQuantity: Double; AMovType: TProductMovStock): IProductRepository;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64; override;
    function Store(AEntity: TBaseEntity): Int64; override;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils,
  uAppRest.Types,
  uApplication.Exception,
  uTrans;

{ TProductRepositorySQL }

class function TProductRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IProductSQLBuilder): IProductRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

function TProductRepositorySQL.MoveProduct(AProductId: Int64; AIncOrDecQuantity: Double; AMovType: TProductMovStock): IProductRepository;
var
  LOperator: String;
begin
  Result := Self;

  case AMovType of
    TProductMovStock.Increment: LOperator := '+';
    TProductMovStock.Decrement: LOperator := '-';
  end;

  var LSQL := ' UPDATE product                                            '+
              ' SET                                                       '+
              '   product.current_quantity = product.current_quantity%s%s '+
              ' WHERE                                                     '+
              '   product.id = %s                                         '+
              ' AND                                                       '+
              '   product.flg_discontinued <> 1                           '+
              ' AND                                                       '+
              '   product.flg_to_move_the_stock = 1                       ';

  lSQL := Format(lSQL, [
    LOperator,
    AIncOrDecQuantity.ToString,
    AProductId.ToString
  ]);

  FConn.MakeQry.ExecSQL(lSQL);
end;

constructor TProductRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IProductSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FProductSQLBuilder := ASQLBuilder;
  FManageTransaction := True;
end;

function TProductRepositorySQL.DataSetToEntity(ADtsProduct: TDataSet): TBaseEntity;
begin
  const LProduct = TProduct.FromJSON(ADtsProduct.ToJSONObjectString);

  // Tratar especificidades
  LProduct.&unit.id                 := ADtsProduct.FieldByName('unit_id').AsLargeInt;
  LProduct.&unit.name               := ADtsProduct.FieldByName('unit_name').AsString;
  LProduct.ncm.id                   := ADtsProduct.FieldByName('ncm_id').AsLargeInt;
  LProduct.ncm.code                 := ADtsProduct.FieldByName('ncm_code').AsString;
  LProduct.ncm.name                 := ADtsProduct.FieldByName('ncm_name').AsString;
  LProduct.category.id              := ADtsProduct.FieldByName('category_id').AsLargeInt;
  LProduct.category.name            := ADtsProduct.FieldByName('category_name').AsString;
  LProduct.brand.id                 := ADtsProduct.FieldByName('brand_id').AsLargeInt;
  LProduct.brand.name               := ADtsProduct.FieldByName('brand_name').AsString;
  LProduct.size.id                  := ADtsProduct.FieldByName('size_id').AsLargeInt;
  LProduct.size.name                := ADtsProduct.FieldByName('size_name').AsString;
  LProduct.storage_location.id      := ADtsProduct.FieldByName('storage_location_id').AsLargeInt;
  LProduct.storage_location.name    := ADtsProduct.FieldByName('storage_location_name').AsString;
  LProduct.created_by_acl_user.id   := ADtsProduct.FieldByName('created_by_acl_user_id').AsLargeInt;
  LProduct.created_by_acl_user.name := ADtsProduct.FieldByName('created_by_acl_user_name').AsString;
  LProduct.updated_by_acl_user.id   := ADtsProduct.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LProduct.updated_by_acl_user.name := ADtsProduct.FieldByName('updated_by_acl_user_name').AsString;

  Result := LProduct;
end;

function TProductRepositorySQL.DataSetToProductPriceList(ADtsProductPriceList: TDataSet): TProductPriceList;
begin
  Result := TProductPriceList.FromJSON(ADtsProductPriceList.ToJSONObjectString);

  // Tratar especificidades
  Result.price_list.id   := ADtsProductPriceList.FieldByName('price_list_id').AsLargeInt;
  Result.price_list.name := ADtsProductPriceList.FieldByName('price_list_name').AsString;
end;

function TProductRepositorySQL.FieldExists(AColumName, AColumnValue: String; AId: Int64): Boolean;
begin
  Result := not FConn.MakeQry.Open(
    FProductSQLBuilder.RegisteredFields(AColumName, AColumnValue, AId)
  ).DataSet.IsEmpty;
end;

function TProductRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FProductSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TProductRepositorySQL.Show(AId: Int64): TProduct;
begin
  Result := nil;
  const LQry = FConn.MakeQry;

  // Product
  const LProduct = inherited ShowById(AId) as TProduct;
  if not assigned(LProduct) then
    Exit;

  // ProductPriceList
  LQry.Open(FProductSQLBuilder.SelectProductPriceListsByProductId(AId));
  LQry.First;
  while not LQry.Eof do
  begin
    LProduct.product_price_lists.Add(DataSetToProductPriceList(LQry.DataSet));
    LQry.Next;
  end;

  Result := LProduct;
end;

function TProductRepositorySQL.ShowByEanOrSkuCode(AValue: String): TProduct;
begin
  Result := nil;
  With FConn.MakeQry.Open(FProductSQLBuilder.SelectByEanOrSkuCode(AValue)) do
  begin
    if DataSet.IsEmpty then Exit;
    Result := DataSetToEntity(DataSet) as TProduct;
  end;
end;

function TProductRepositorySQL.Store(AEntity: TBaseEntity): Int64;
var
  LStoredId: Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Product
    LStoredId := inherited Store(AEntity);
    const LProduct = AEntity as TProduct;

    // ProductPriceLists
    for var LProductPriceList in LProduct.product_price_lists do
    begin
      LProductPriceList.product_id := LStoredId;
      LQry.ExecSQL(FProductSQLBuilder.InsertProductPriceList(LProductPriceList))
    end;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := LStoredId;
end;

function TProductRepositorySQL.Update(AId: Int64; AEntity: TBaseEntity): Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Product
    inherited Update(AId, AEntity);
    const LProduct = AEntity as TProduct;

    // ProductPriceLists
    LQry.ExecSQL(FProductSQLBuilder.DeleteProductPriceListsByProductId(AId));
    for var LProductPriceList in LProduct.product_price_lists do
    begin
      LProductPriceList.product_id := AId;
      LQry.ExecSQL(FProductSQLBuilder.InsertProductPriceList(LProductPriceList))
    end;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := AId;
end;

procedure TProductRepositorySQL.Validate(AEntity: TBaseEntity);
begin
  var LErrors := EmptyStr;
  const LProduct = AEntity as TProduct;

  // Verificar se sku_code já existe
  if not LProduct.sku_code.Trim.IsEmpty then
  begin
    if FieldExists('product.sku_code', LProduct.sku_code, LProduct.id) then
      LErrors := LErrors + Trans.FieldWithValueIsInUse('Cód. de Referência', LProduct.sku_code) + #13;
  end;

  // Verificar se ean_code já existe
  if not LProduct.ean_code.Trim.IsEmpty then
  begin
    if FieldExists('product.ean_code', LProduct.ean_code, LProduct.id) then
      LErrors := LErrors + Trans.FieldWithValueIsInUse('Cód. de Barras', LProduct.ean_code) + #13;
  end;

  // Verificar se manufacturing_code já existe
  if not LProduct.manufacturing_code.Trim.IsEmpty then
  begin
    if FieldExists('product.manufacturing_code', LProduct.manufacturing_code, LProduct.id) then
      LErrors := LErrors + Trans.FieldWithValueIsInUse('Cód. de Fábrica', LProduct.manufacturing_code) + #13;
  end;

  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);
end;


end.



