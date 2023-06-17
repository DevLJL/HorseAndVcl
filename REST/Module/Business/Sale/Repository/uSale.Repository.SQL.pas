unit uSale.Repository.SQL;

interface

uses
  uBase.Repository,
  uSale.Repository.Interfaces,
  uSale.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uSale,
  uSaleItem,
  uSalePayment,
  uZLMemTable.Interfaces,
  uSale.Types;

type
  TSaleRepositorySQL = class(TBaseRepository, ISaleRepository)
  private
    FSaleSQLBuilder: ISaleSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: ISaleSQLBuilder);
    function DataSetToEntity(ADtsSale: TDataSet): TBaseEntity; override;
    function DataSetToSaleItem(ADtsSaleItem: TDataSet): TSaleItem;
    function DataSetToSalePayment(ADtsSalePayment: TDataSet): TSalePayment;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: ISaleSQLBuilder): ISaleRepository;
    function Show(AId: Int64): TSale;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64; override;
    function Store(AEntity: TBaseEntity): Int64; override;
    function DataForReport(ASaleId: Int64): TDataForReportOutput;
    function ChangeStatus(ASaleId: Int64; AStatus: TSaleStatus): Boolean;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils,
  uZLQry.Interfaces,
  Vcl.Forms,
  uApplication.Exception,
  uQuotedStr,
  uTrans;

{ TSaleRepositorySQL }

class function TSaleRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: ISaleSQLBuilder): ISaleRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

function TSaleRepositorySQL.ChangeStatus(ASaleId: Int64; AStatus: TSaleStatus): Boolean;
begin
  FConn.MakeQry.ExecSQL(Format('update sale set sale.status = %s where sale.id = %s', [
    Ord(AStatus).ToString,
    ASaleId.ToString
  ]));

  Result := True;
end;

constructor TSaleRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: ISaleSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FSaleSQLBuilder    := ASQLBuilder;
  FManageTransaction := True;
end;

function TSaleRepositorySQL.DataForReport(ASaleId: Int64): TDataForReportOutput;
begin
  const lQry = FConn.MakeQry;
  const LSQL = FSaleSQLBuilder.SQLForReport(ASaleId);

  // Sale
  LQry.Open(LSQL.Sale);
  if LQry.DataSet.IsEmpty then raise Exception.Create('Record not found with id: ' + ASaleId.ToString);
  Result.Sale := FConn.MakeMemTable.FromDataSet(LQry.DataSet);

  // SaleItem
  LQry.Open(LSQL.SaleItems);
  Result.SaleItems := FConn.MakeMemTable.FromDataSet(LQry.DataSet);

  // SalePayment
  LQry.Open(LSQL.SalePayments);
  Result.SalePayments := FConn.MakeMemTable.FromDataSet(LQry.DataSet);
end;

function TSaleRepositorySQL.DataSetToEntity(ADtsSale: TDataSet): TBaseEntity;
begin
  const LSale = TSale.FromJSON(ADtsSale.ToJSONObjectString);

  // Tratar especificidades
  LSale.person.id                := ADtsSale.FieldByName('person_id').AsLargeInt;
  LSale.person.name              := ADtsSale.FieldByName('person_name').AsString;
  LSale.seller.id                := ADtsSale.FieldByName('seller_id').AsLargeInt;
  LSale.seller.name              := ADtsSale.FieldByName('seller_name').AsString;
  LSale.carrier.id               := ADtsSale.FieldByName('carrier_id').AsLargeInt;
  LSale.carrier.name             := ADtsSale.FieldByName('carrier_name').AsString;
  LSale.created_by_acl_user.id   := ADtsSale.FieldByName('created_by_acl_user_id').AsLargeInt;
  LSale.created_by_acl_user.name := ADtsSale.FieldByName('created_by_acl_user_name').AsString;
  LSale.updated_by_acl_user.id   := ADtsSale.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LSale.updated_by_acl_user.name := ADtsSale.FieldByName('updated_by_acl_user_name').AsString;

  Result := LSale;
end;

function TSaleRepositorySQL.DataSetToSaleItem(ADtsSaleItem: TDataSet): TSaleItem;
begin
  const LSaleItem = TSaleItem.FromJSON(ADtsSaleItem.ToJSONObjectString);

  // Tratar especificidades
  LSaleItem.product.id         := ADtsSaleItem.FieldByName('product_id').AsLargeInt;
  LSaleItem.product.name       := ADtsSaleItem.FieldByName('product_name').AsString;
  LSaleItem.product.unit_id    := ADtsSaleItem.FieldByName('product_unit_id').AsLargeInt;
  LSaleItem.product.&unit.id   := ADtsSaleItem.FieldByName('product_unit_id').AsLargeInt;
  LSaleItem.product.&unit.name := ADtsSaleItem.FieldByName('product_unit_name').AsString;

  Result := LSaleItem;
end;

function TSaleRepositorySQL.DataSetToSalePayment(ADtsSalePayment: TDataSet): TSalePayment;
begin
  const LSalePayment = TSalePayment.FromJSON(ADtsSalePayment.ToJSONObjectString);

  // Tratar especificidades
  LSalePayment.payment.id                  := ADtsSalePayment.FieldByName('payment_id').AsLargeInt;
  LSalePayment.payment.name                := ADtsSalePayment.FieldByName('payment_name').AsString;
  LSalePayment.payment.flg_post_as_received := ADtsSalePayment.FieldByName('payment_flg_post_as_received').AsInteger;
  LSalePayment.bank_account.id             := ADtsSalePayment.FieldByName('bank_account_id').AsLargeInt;
  LSalePayment.bank_account.name           := ADtsSalePayment.FieldByName('bank_account_name').AsString;

  Result := LSalePayment;
end;

function TSaleRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FSaleSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TSaleRepositorySQL.Show(AId: Int64): TSale;
begin
  Result := Nil;
  const LQry = FConn.MakeQry;

  // Sale
  const LSale = inherited ShowById(AId) as TSale;
  if not assigned(LSale) then
    Exit;

  // SaleItem
  LQry.Open(FSaleSQLBuilder.SelectSaleItemsBySaleId(AId));
  LQry.First;
  while not LQry.Eof do
  begin
    LSale.sale_items.Add(DataSetToSaleItem(LQry.DataSet));
    LQry.Next;
  end;

  // SalePayment
  LQry.Open(FSaleSQLBuilder.SelectSalePaymentsBySaleId(AId));
  LQry.First;
  while not LQry.Eof do
  begin
    LSale.sale_payments.Add(DataSetToSalePayment(LQry.DataSet));
    LQry.Next;
  end;

  Result := LSale;
end;

function TSaleRepositorySQL.Store(AEntity: TBaseEntity): Int64;
var
  LStoredId: Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Sale
    LStoredId := inherited Store(AEntity);
    const LSale = AEntity as TSale;

    // SaleItems
    for var LSaleItem in LSale.sale_items do
    begin
      LSaleItem.sale_id := LStoredId;
      LQry.ExecSQL(FSaleSQLBuilder.InsertSaleItem(LSaleItem))
    end;

    // SalePayments
    for var LSalePayment in LSale.sale_payments do
    begin
      LSalePayment.sale_id := LStoredId;
      LQry.ExecSQL(FSaleSQLBuilder.InsertSalePayment(LSalePayment))
    end;

    {TODO -oOwner -cGeneral : Refatorar esse código, levar sql para SQLBuilder}
    // SaleCheckId
    const LSaleCheckId = LQry
      .ExecSQL (FSaleSQLBuilder.NextSaleCheckId)
      .Open    (FSaleSQLBuilder.LastInsertId)
      .DataSet.Fields[0].AsLargeInt;
    LQry.ExecSQL(Format('update sale set sale_check_id = %s where id = %s', [
      Q(LSaleCheckId),
      Q(LStoredId)
    ]));

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

function TSaleRepositorySQL.Update(AId: Int64; AEntity: TBaseEntity): Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Sale
    inherited Update(AId, AEntity);
    const LSale = AEntity as TSale;

    // SaleItems
    LQry.ExecSQL(FSaleSQLBuilder.DeleteSaleItemsBySaleId(AId));
    for var LSaleItem in LSale.sale_items do
    begin
      LSaleItem.sale_id := AId;
      LQry.ExecSQL(FSaleSQLBuilder.InsertSaleItem(LSaleItem))
    end;

    // SalePayment
    LQry.ExecSQL(FSaleSQLBuilder.DeleteSalePaymentsBySaleId(AId));
    for var LSalePayment in LSale.sale_payments do
    begin
      LSalePayment.sale_id := AId;
      LQry.ExecSQL(FSaleSQLBuilder.InsertSalePayment(LSalePayment))
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

procedure TSaleRepositorySQL.Validate(AEntity: TBaseEntity);
begin
  var LErrors := EmptyStr;
  const LSale = AEntity as TSale;

  // Verificar se Número de Consumo está disponível
  if (LSale.consumption_number > 0) then
  begin
    {TODO -oOwner -cGeneral : Refatorar, levar esse sql para sqlbuilder}
    var LSQL := ' select * from sale '+
                '  where status = %s '+
                '    and type = %s '+
                '    and consumption_number = %s '+
                '    and id <> %s ';
    LSQL := Format(LSQL, [
      Q(Ord(TSaleStatus.Pending)),
      Q(Ord(TSaleType.Consumption)),
      Q(LSale.consumption_number),
      Q(LSale.id)
    ]);
    const LConsumptionNumberIsBusy = not FConn.MakeQry.Open(LSQL).IsEmpty;
    if LConsumptionNumberIsBusy then
      LErrors := LErrors + Trans.FieldWithValueIsInUse('Número de Consumo', LSale.consumption_number.ToString) + #13;
  end;

  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);
end;

end.



