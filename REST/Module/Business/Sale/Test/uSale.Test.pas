unit uSale.Test;

interface

uses
  DUnitX.TestFramework,
  uSale.Persistence.UseCase.Interfaces,
  uSale.Persistence.UseCase,
  uSale.DataFactory,
  uCashFlow.Persistence.UseCase.Interfaces,
  uCashFlow.Persistence.UseCase,
  uProduct.Persistence.UseCase.Interfaces,
  uProduct.Persistence.UseCase,
  uSale.GenerateBilling.UseCase,
  uBillPayReceive.Persistence.UseCase.Interfaces,
  uBillPayReceive.Persistence.UseCase,
  uPerson.Persistence.UseCase.Interfaces,
  uPerson.Persistence.UseCase,
  uSale.Repository.Interfaces,
  uProduct.Repository.Interfaces,
  uBillPayReceive.Repository.Interfaces,
  uCashFlow.Repository.Interfaces,
  uPerson.Repository.Interfaces;

type
  [TestFixture]
  TSaleTest = class
  private
    FPersistence: ISalePersistenceUseCase;
    FDataFactory: ISaleDataFactory;

    FCashFlowPersistence: ICashFlowPersistenceUseCase;
    FProductPersistence: IProductPersistenceUseCase;
    FBillPayReceivePersistence: IBillPayReceivePersistenceUseCase;
    FPersonPersistence: IPersonPersistenceUseCase;

    FSaleRepository: ISaleRepository;
    FProductRepository: IProductRepository;
    FBillPayReceiveRepository: IBillPayReceiveRepository;
    FCashFlowRepository: ICashFlowRepository;
    FPersonRepository: IPersonRepository;
 public
    [Setup]
    procedure Setup;

    [Test]
    procedure should_delete_by_id;

    [Test]
    procedure should_find_by_id;

    [Test]
    procedure should_generate_pdf_report_by_id;

    [Test]
    procedure should_include;

    [Test]
    procedure should_list_records;

    [Test]
    procedure should_update_by_id;

    [Test]
    /// <summary>
    ///   Gerar e Faturar Venda
    ///   1-Incluir Venda (Sale)
    ///   2-Decrementar estoque (Product)
    ///   3-Gerar contas a receber (BillPayReceive)
    ///   4-Gerar valor no fluxo de caixa (CashFlow)
    ///   5-Aterar o status da venda para encerrada (Sale)
    ///   6-Conferir Valores
    /// </summary>
    procedure should_generate_and_billing_sale;

    [Test]
    /// <summary>
    ///   Estonar Venda
    ///   1-Gerar Venda e Faturar
    ///   2-Estornar Venda
    ///   3-Conferir Valores
    /// </summary>
    procedure should_revert_sale;
  end;

implementation

uses
  uRepository.Factory,
  uSmartPointer,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  uSale.Show.DTO,
  uSale.Filter.DTO,
  uTestConnection,
  uCashFlow.Input.DTO,
  uStation.Show.DTO,
  uStation.DataFactory,
  uPerson.Show.DTO,
  uPerson.DataFactory,
  uSale.Input.DTO,
  uSale.Types,
  uProduct.Input.DTO,
  uProduct.DataFactory,
  uProduct.Show.DTO,
  uSaleItem.Input.DTO,
  uSalePayment.Input.DTO,
  uPayment.Show.DTO,
  uPayment.DataFactory,
  uFaker,
  uProduct.Filter,
  uFilter.Types,
  uBillPayReceive.Filter,
  uCashFlow.Show.DTO,
  uIndexResult,
  uCashFlow.DataFactory,
  uSale.PdfReport.UseCase,
  uCashFlowTransaction.Types;

{ TSaleTest }

procedure TSaleTest.Setup;
begin
  // Repositories
  FSaleRepository           := TRepositoryFactory.Make(TestConnection.Conn).Sale;
  FProductRepository        := TRepositoryFactory.Make(TestConnection.Conn).Product;
  FBillPayReceiveRepository := TRepositoryFactory.Make(TestConnection.Conn).BillPayReceive;
  FCashFlowRepository       := TRepositoryFactory.Make(TestConnection.Conn).CashFlow;
  FPersonRepository         := TRepositoryFactory.Make(TestConnection.Conn).Person;

  // Persistences
  FPersistence               := TSalePersistenceUseCase.Make(FSaleRepository);
  FCashFlowPersistence       := TCashFlowPersistenceUseCase.Make(FCashFlowRepository);
  FProductPersistence        := TProductPersistenceUseCase.Make(FProductRepository);
  FBillPayReceivePersistence := TBillPayReceivePersistenceUseCase.Make(FBillPayReceiveRepository);
  FPersonPersistence         := TPersonPersistenceUseCase.Make(FPersonRepository);

  // DataFactory
  FDataFactory := TSaleDataFactory.Make(FPersistence);
end;

procedure TSaleTest.should_update_by_id;
begin
  // Inserir registro para posteriormente atualizar
  const LStored = FDataFactory.GenerateInsert;

  // Gerar dados aleatórios
  const LInput = FDataFactory.GenerateInput;

  // Atualizar e localizar registro atualizado
  const LUpdatedId = FPersistence.Update(LStored.id, LInput);
  const LFound = FPersistence.Show(LUpdatedId);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LInput.Free;
  LFound.Free;
end;

procedure TSaleTest.should_find_by_id;
begin
  // Inserir registro para posteriormente localizar
  const LStored = FDataFactory.GenerateInsert;

  // Localizar registro inserido
  const LFound = FPersistence.Show(LStored.id);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LFound.Free;
end;

procedure TSaleTest.should_generate_and_billing_sale;
const
  L_DISCOUNT = 5;
  L_QUANTITY_OF_SALE_ITEMS = 3;
  L_CURRENT_QUANTITY_OF_PRODUCTS = 10;
  L_QUANTITY_TO_DECREASE_ON_SALE = 3;
  L_EXPECTED_CURRENT_QUANTITY = '7';
var
  LIndexResult: IIndexResult;
  LCashFlowStored: SH<TCashFlowShowDTO>;
begin
  // ---------------------------------------------------------------------------
  // ABERTURA DE CAIXA
  // ---------------------------------------------------------------------------
  LCashFlowStored := TCashFlowDataFactory.Make.GenerateInsert;
  // --------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // GERAR VENDA
  // ---------------------------------------------------------------------------
  // Cabeçalho da venda
  const LPersonShowDTO: SH<TPersonShowDTO> = TPersonDataFactory.Make.GenerateInsert;
  const LSellerShowDTO: SH<TPersonShowDTO> = TPersonDataFactory.Make.GenerateInsert(True);
  const LSaleInputDTO: SH<TSaleInputDTO> = TSaleInputDTO.Create;
  With LSaleInputDTO.Value do
  begin
    person_id   := LPersonShowDTO.Value.id;
    seller_id   := LSellerShowDTO.Value.id;
    &type       := TSaleType.Normal;
    discount    := L_DISCOUNT;
    acl_user_id := 1;
  end;

  // Produtos da Venda
  var LExpectedSumSaleItemTotal: Double    := 0;
  var LExpectedSumSaleItemQuantity: Double := 0;
  var LExpectedSaleTotal: Double           := 0;
  var LUsedProductsOnSale: String          := '';
  for var lI := 1 to L_QUANTITY_OF_SALE_ITEMS do
  begin
    const LProductInputDTO: SH<TProductInputDTO> = TProductDataFactory.Make.GenerateInput;
    With LProductInputDTO.Value do
    begin
      current_quantity      := L_CURRENT_QUANTITY_OF_PRODUCTS;
      flg_to_move_the_stock := 1;
      flg_discontinued      := 0;
    end;
    const LProductShowDTO: SH<TProductShowDTO> = FProductPersistence.StoreAndShow(LProductInputDTO).Right;
    LUsedProductsOnSale := LUsedProductsOnSale + LProductShowDTO.Value.id.ToString + ', ';

    LSaleInputDTO.Value.sale_items.Add(TSaleItemInputDTO.Create);
    With LSaleInputDTO.Value.sale_items.Last do
    begin
      product_id := LProductShowDTO.Value.id;
      quantity   := L_QUANTITY_TO_DECREASE_ON_SALE;
      price      := LProductShowDTO.Value.price+L_DISCOUNT; // Garantir valor no mínimo de 5,00 ao somar L_DISCOUNT
      seller_id  := LSellerShowDTO.Value.id;

      // Incrementar Valores Esperados
      LExpectedSumSaleItemTotal    := LExpectedSumSaleItemTotal + (quantity * price);
      LExpectedSumSaleItemQuantity := LExpectedSumSaleItemQuantity + quantity;
    end;
  end;
  LExpectedSaleTotal  := LExpectedSumSaleItemTotal-L_DISCOUNT;
  LUsedProductsOnSale := Copy(LUsedProductsOnSale, 1, Length(LUsedProductsOnSale)-2);

  // Pagamento da Venda
  LSaleInputDTO.Value.sale_payments.Add(TSalePaymentInputDTO.Create);
  With LSaleInputDTO.Value.sale_payments.Last do
  begin
    const LPaymentShowDTO: SH<TPaymentShowDTO> = TPaymentDataFactory.Make.GenerateInsert;
    collection_uuid := TFaker.GenerateUUID;
    payment_id      := LPaymentShowDTO.Value.id;
    bank_account_id := LPaymentShowDTO.Value.bank_account_default_id;
    amount          := LExpectedSaleTotal;
    due_date        := now;
  end;

  // Incluir Venda no Banco de dados
  const LSaleIdStored = FPersistence.Store(LSaleInputDTO);

  // ------------------------------------------------------------------------------------------------------------------
  // FATURAR VENDA (Descontar itens do estoque, gerar contas a receber, gerar fluxo de caixa e alterar status da venda)
  // ------------------------------------------------------------------------------------------------------------------
  const LSaleBilled = TSaleGenerateBillingUseCase.Make(
    TRepositoryFactory.Make(FSaleRepository.Conn),
    LSaleIdStored,
    LCashFlowStored.Value.station_id,
    TSaleGenerateBillingOperation.Approve
  ).Execute;
  // ------------------------------------------------------------------------------------------------------------------


  // ---------------------------------------------------------------------------
  // CONFIRMAR VALORES
  // ---------------------------------------------------------------------------
  Assert.IsTrue(LSaleBilled.total = LExpectedSaleTotal); // Todal da Venda
  Assert.IsTrue(LSaleBilled.sum_sale_item_total = LExpectedSumSaleItemTotal); // Total dos Itens
  Assert.IsTrue(LSaleBilled.sum_sale_item_quantity = LExpectedSumSaleItemQuantity); // Total de quantidade de itens
  Assert.IsTrue(LSaleBilled.status = TSaleStatus.Approved); // Status aprovada

  // Verificar decremento do estoque
  LIndexResult := FProductPersistence.Index(
    TProductFilter.Make
      .WherePkIn(lUsedProductsOnSale)
      .Where(TParentheses.None, 'product.current_quantity', TCondition.Equal, L_EXPECTED_CURRENT_QUANTITY)
  );
  Assert.IsTrue(LIndexResult.Data.RecordCount = L_QUANTITY_OF_SALE_ITEMS);

  // Verificar Contas a Receber
  LIndexResult := FBillPayReceivePersistence.Index(
    TBillPayReceiveFilter.Make
      .Where(TParentheses.None, 'bill_pay_receive.sale_id', TCondition.Equal, LSaleBilled.id.ToString)
  );
  Assert.IsTrue(LIndexResult.Data.RecordCount = 1); // Apenas um único pagamento
  Assert.IsTrue(LIndexResult.Data.FieldByName('net_amount').AsFloat = LExpectedSaleTotal); // Valor do Pagamento

  // Verificar Fluxo de Caixa
  LCashFlowStored := FCashFlowPersistence.Show(LCashFlowStored.Value.id);
  With LCashFlowStored.Value.cash_flow_transactions.Last do
  begin
    Assert.IsTrue(amount = LExpectedSaleTotal);
    Assert.IsTrue(sale_id = LSaleBilled.id);
    Assert.IsTrue(person_id = LSaleBilled.person_id);
    Assert.IsTrue(&type = TCashFlowTransactionType.Credit);
  end;

  // ---------------------------------------------------------------------------
  // LIMPAR DADOS
  // ---------------------------------------------------------------------------
  // Estornar Venda
  TSaleGenerateBillingUseCase.Make(
    TRepositoryFactory.Make(FSaleRepository.Conn),
    LSaleIdStored,
    LCashFlowStored.Value.station_id,
    TSaleGenerateBillingOperation.Revert
  )
  .Execute(False);

  // Apagar dados que não serão mais utilizados
  FCashFlowPersistence.Delete(LCashFlowStored.Value.id);
  FPersistence.Delete(LSaleIdStored);
  FProductPersistence.DeleteByIdRange(lUsedProductsOnSale);
  FPersonPersistence.DeleteByIdRange(LSaleBilled.person_id.ToString + ', ' + LSaleBilled.seller_id.ToString);
  LSaleBilled.Free;
  // ---------------------------------------------------------------------------
end;

procedure TSaleTest.should_generate_pdf_report_by_id;
begin
  // Gerar Venda
  const LSaleShowDTO: SH<TSaleShowDTO> = TSaleDataFactory.Make.GenerateInsert;

  // Gerar Stream de relatório
  const LOutPutFileStream = TSalePdfReportUseCase.Make(FSaleRepository).Execute(LSaleShowDTO.Value.id);

  // Verificar existência e extensão de relatório
  Assert.IsTrue(FileExists(LOutPutFileStream.FilePath));
  Assert.IsTrue(ExtractFileExt(LOutPutFileStream.FilePath) = '.pdf');

  // Limpar dados
  FPersistence.Delete(LSaleShowDTO.Value.id);
end;

procedure TSaleTest.should_delete_by_id;
begin
  // Inserir registro para posteriormente deletar
  const LStored = FDataFactory.GenerateInsert;

  // Deletar registro
  FPersistence.Delete(LStored.id);

  // Tentar localizar registro deletado
  const LFound = FPersistence.Show(LStored.id);

  // Confirmar Valores
  Assert.IsTrue(not Assigned(LFound));

  // Destruir Objetos
  LStored.Free;
  LFound.Free;
end;

procedure TSaleTest.should_include;
begin
  // Inserir registro
  const LStored = FDataFactory.GenerateInsert;

  // Localizar registro inserido
  const LFound = FPersistence.Show(LStored.id);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LFound.Free;
end;

procedure TSaleTest.should_list_records;
const
  EXPECTED_COUNT = 3;
  EXPECTED_FIELDS: TArray<String> = [
    'id',
    'person_id',
    'seller_id',
    'carrier_id',
    'note',
    'internal_note',
    'status',
    'delivery_status',
    'type',
    'flg_payment_requested',
    'sum_sale_item_total',
    'discount',
    'increase',
    'freight',
    'cover_charge',
    'service_charge',
    'total',
    'money_received',
    'money_change',
    'amount_of_people',
    'informed_legal_entity_number',
    'consumption_number',
    'sale_check_id',
    'sale_check_name',
    'created_at',
    'updated_at',
    'created_by_acl_user_id',
    'updated_by_acl_user_id',
    'created_by_acl_user_name',
    'updated_by_acl_user_name',
    'person_name',
    'seller_name',
    'carrier_name'
  ];

begin
  // Inserir registros
  var LPks := '';
  for var I := 1 to EXPECTED_COUNT do
  begin
    const LStored: SH<TSaleShowDTO> = FDataFactory.GenerateInsert;
    LPks := LPks + LStored.Value.id.ToString + ', ';
  end;
  LPks := Copy(LPks, 1, Length(LPks)-2);

  // Listar registros
  const SaleFilterDTO: SH<TSaleFilterDTO> = TSaleFilterDTO.Create;
  SaleFilterDTO.Value.where_pk_in := LPks;
  const LIndexResult = FPersistence.Index(SaleFilterDTO);

  // Verificar se foram inseridos 3 registros
  Assert.IsTrue(LIndexResult.AllPagesRecordCount = EXPECTED_COUNT);

  // Verificar existência dos campos
  for var CurrentField in EXPECTED_FIELDS do
    Assert.IsTrue(Assigned(LIndexResult.Data.FindField(CurrentField)), 'Campo não encontrado: ' + CurrentField);

  // Verificar quantidade de campos retornados
  Assert.IsTrue(Length(EXPECTED_FIELDS) = LIndexResult.Data.FieldCount);

  // Limpar Dados
  FPersistence.DeleteByIdRange(LPks);
end;

procedure TSaleTest.should_revert_sale;
const
  L_DISCOUNT = 5;
  L_QUANTITY_OF_SALE_ITEMS = 3;
  L_CURRENT_QUANTITY_OF_PRODUCTS = 10;
  L_QUANTITY_TO_DECREASE_ON_SALE = 3;
var
  LIndexResult: IIndexResult;
  LCashFlowStored: SH<TCashFlowShowDTO>;
begin
  // ---------------------------------------------------------------------------
  // ABERTURA DE CAIXA
  // ---------------------------------------------------------------------------
  LCashFlowStored := TCashFlowDataFactory.Make.GenerateInsert;
  // --------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // GERAR VENDA
  // ---------------------------------------------------------------------------
  // Cabeçalho da venda
  const LPersonShowDTO: SH<TPersonShowDTO> = TPersonDataFactory.Make.GenerateInsert;
  const LSellerShowDTO: SH<TPersonShowDTO> = TPersonDataFactory.Make.GenerateInsert(True);
  const LSaleInputDTO: SH<TSaleInputDTO> = TSaleInputDTO.Create;
  With LSaleInputDTO.Value do
  begin
    person_id   := LPersonShowDTO.Value.id;
    seller_id   := LSellerShowDTO.Value.id;
    &type       := TSaleType.Normal;
    discount    := L_DISCOUNT;
    acl_user_id := 1;
  end;

  // Produtos da Venda
  var LExpectedSumSaleItemTotal: Double    := 0;
  var LExpectedSumSaleItemQuantity: Double := 0;
  var LExpectedSaleTotal: Double           := 0;
  var LUsedProductsOnSale: String          := '';
  for var lI := 1 to L_QUANTITY_OF_SALE_ITEMS do
  begin
    const LProductInputDTO: SH<TProductInputDTO> = TProductDataFactory.Make.GenerateInput;
    With LProductInputDTO.Value do
    begin
      current_quantity      := L_CURRENT_QUANTITY_OF_PRODUCTS;
      flg_to_move_the_stock := 1;
      flg_discontinued      := 0;
    end;
    const LProductShowDTO: SH<TProductShowDTO> = FProductPersistence.StoreAndShow(LProductInputDTO).Right;
    LUsedProductsOnSale := LUsedProductsOnSale + LProductShowDTO.Value.id.ToString + ', ';

    LSaleInputDTO.Value.sale_items.Add(TSaleItemInputDTO.Create);
    With LSaleInputDTO.Value.sale_items.Last do
    begin
      product_id := LProductShowDTO.Value.id;
      quantity   := L_QUANTITY_TO_DECREASE_ON_SALE;
      price      := LProductShowDTO.Value.price+L_DISCOUNT; // Garantir valor no mínimo de 5,00 ao somar L_DISCOUNT
      seller_id  := LSellerShowDTO.Value.id;

      // Incrementar Valores Esperados
      LExpectedSumSaleItemTotal    := LExpectedSumSaleItemTotal + (quantity * price);
      LExpectedSumSaleItemQuantity := LExpectedSumSaleItemQuantity + quantity;
    end;
  end;
  LExpectedSaleTotal  := LExpectedSumSaleItemTotal-L_DISCOUNT;
  LUsedProductsOnSale := Copy(LUsedProductsOnSale, 1, Length(LUsedProductsOnSale)-2);

  // Pagamento da Venda
  LSaleInputDTO.Value.sale_payments.Add(TSalePaymentInputDTO.Create);
  With LSaleInputDTO.Value.sale_payments.Last do
  begin
    const LPaymentShowDTO: SH<TPaymentShowDTO> = TPaymentDataFactory.Make.GenerateInsert;
    collection_uuid := TFaker.GenerateUUID;
    payment_id      := LPaymentShowDTO.Value.id;
    bank_account_id := LPaymentShowDTO.Value.bank_account_default_id;
    amount          := LExpectedSaleTotal;
    due_date        := now;
  end;

  // Incluir Venda no Banco de dados
  const LSaleIdStored = FPersistence.Store(LSaleInputDTO);

  // ------------------------------------------------------------------------------------------------------------------
  // FATURAR VENDA (Descontar itens do estoque, gerar contas a receber, gerar fluxo de caixa e alterar status da venda)
  // ------------------------------------------------------------------------------------------------------------------
  const LSaleBilled = TSaleGenerateBillingUseCase.Make(
    TRepositoryFactory.Make(FSaleRepository.Conn),
    LSaleIdStored,
    LCashFlowStored.Value.station_id,
    TSaleGenerateBillingOperation.Approve
  ).Execute;
  // ------------------------------------------------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // ESTORNAR VENDA
  // ---------------------------------------------------------------------------
  TSaleGenerateBillingUseCase.Make(
    TRepositoryFactory.Make(FSaleRepository.Conn),
    LSaleIdStored,
    LCashFlowStored.Value.station_id,
    TSaleGenerateBillingOperation.Revert
  )
  .Execute(False);
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // CONFIRMAR VALORES
  // ---------------------------------------------------------------------------
  // Verificar se retornou itens para o estoque após estorno
  LIndexResult := FProductPersistence.Index(
    TProductFilter.Make
      .WherePkIn(lUsedProductsOnSale)
      .Where(TParentheses.None, 'product.current_quantity', TCondition.Equal, L_CURRENT_QUANTITY_OF_PRODUCTS.ToString)
  );
  Assert.IsTrue(LIndexResult.Data.RecordCount = L_QUANTITY_OF_SALE_ITEMS);

  // Verificar se apagou Contas a Receber relacionado a venda
  LIndexResult := FBillPayReceivePersistence.Index(
    TBillPayReceiveFilter.Make
      .Where(TParentheses.None, 'bill_pay_receive.sale_id', TCondition.Equal, LSaleBilled.id.ToString)
  );
  Assert.IsTrue(LIndexResult.Data.RecordCount = 0); // Não pode retornar registros

  // Verificar se gerou estorno em Fluxo de Caixa
  LCashFlowStored := FCashFlowPersistence.Show(LCashFlowStored.Value.id);
  With LCashFlowStored.Value.cash_flow_transactions.Last do
  begin
    Assert.IsTrue(amount = LExpectedSaleTotal);
    Assert.IsTrue(sale_id = LSaleBilled.id);
    Assert.IsTrue(person_id = LSaleBilled.person_id);
    Assert.IsTrue(&type = TCashFlowTransactionType.Debit);
    Assert.IsTrue(Pos('estorno', history.ToLower) > 0);
  end;

  // ---------------------------------------------------------------------------
  // LIMPAR DADOS
  // ---------------------------------------------------------------------------
  FCashFlowPersistence.Delete(LCashFlowStored.Value.id);
  FPersistence.Delete(LSaleIdStored);
  FProductPersistence.DeleteByIdRange(lUsedProductsOnSale);
  FPersonPersistence.DeleteByIdRange(LSaleBilled.person_id.ToString + ', ' + LSaleBilled.seller_id.ToString);
  LSaleBilled.Free;
  // ---------------------------------------------------------------------------
end;

initialization
  TDUnitX.RegisterTestFixture(TSaleTest);
end.
