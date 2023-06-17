unit uSale.DataFactory;

interface

uses
  uBase.DataFactory,
  uSale.Show.DTO,
  uSale.Input.DTO,
  uSale.Persistence.UseCase.Interfaces,
  uSale.Persistence.UseCase;

type
  ISaleDataFactory = Interface
    ['{1FDB1DCE-9F4C-4849-845C-BF06623AAADD}']
    function GenerateInsert: TSaleShowDTO;
    function GenerateInput: TSaleInputDTO;
  End;

  TSaleDataFactory = class(TBaseDataFactory, ISaleDataFactory)
  private
    FPersistence: ISalePersistenceUseCase;
    constructor Create(APersistenceUseCase: ISalePersistenceUseCase);
  public
    class function Make(APersistenceUseCase: ISalePersistenceUseCase = nil): ISaleDataFactory;
    function GenerateInsert: TSaleShowDTO;
    function GenerateInput: TSaleInputDTO;
  end;

implementation

{ TSaleDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uHlp,
  uPerson.Show.DTO,
  uPerson.DataFactory,
  uSaleItem.Input.DTO,
  uSale.Types,
  uProduct.Show.DTO,
  uProduct.DataFactory,
  uPayment.Show.DTO,
  uPayment.DataFactory,
  uSalePayment.Input.DTO,
  uTestConnection;

constructor TSaleDataFactory.Create(APersistenceUseCase: ISalePersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TSalePersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Sale);
end;

function TSaleDataFactory.GenerateInput: TSaleInputDTO;
begin
  const PersonShowDTO: SH<TPersonShowDTO> = TPersonDataFactory.Make.GenerateInsert;
  const SellerShowDTO: SH<TPersonShowDTO> = TPersonDataFactory.Make.GenerateInsert(True);
  const CarrierShowDTO: SH<TPersonShowDTO> = TPersonDataFactory.Make.GenerateInsert(False, False, True);

  // Sale
  Result := TSaleInputDTO.Create;
  With Result do
  begin
    person_id                    := PersonShowDTO.Value.id;
    seller_id                    := SellerShowDTO.Value.id;
    carrier_id                   := CarrierShowDTO.Value.id;
    note                         := TFaker.LoremIpsum(255);
    internal_note                := TFaker.LoremIpsum(255);
    status                       := TSaleStatus.Pending;
    delivery_status              := TSaleDeliveryStatus.New;
    &type                        := TSaleType.Normal;
    flg_payment_requested        := Random(1);
    discount                     := 0;
    increase                     := 0;
    freight                      := 0;
    money_received               := 0;
    money_change                 := 0;
    amount_of_people             := Random(5);
    informed_legal_entity_number := TFaker.GenerateCNPJ;
    consumption_number           := Random(50);
    acl_user_id := 1;
  end;

  // SaleItem
  for var lI := 0 to 2 do
  begin
    Result.sale_items.Add(TSaleItemInputDTO.Create);
    With Result.sale_items.Last do
    begin
      const ProductShowDTO: SH<TProductShowDTO> = TProductDataFactory.Make.GenerateInsert;
      product_id      := ProductShowDTO.Value.id;
      quantity        := TFaker.NumberFloat(2);
      price           := TFaker.NumberFloat(2);
      unit_discount   := 0;
      seller_id       := Result.seller_id;
      note            := TFaker.LoremIpsum(255);
    end;
  end;

  // Pagamento
  Result.sale_payments.Add(TSalePaymentInputDTO.Create);
  With Result.sale_payments.Last do
  begin
    const PaymentShowDTO: SH<TPaymentShowDTO> = TPaymentDataFactory.Make.GenerateInsert;
    collection_uuid := TFaker.GenerateUUID;
    payment_id      := PaymentShowDTO.Value.id;
    bank_account_id := PaymentShowDTO.Value.bank_account_default_id;
    amount          := TFaker.NumberFloat;
    note            := TFaker.LoremIpsum(255);
    due_date        := now;
  end;
end;

function TSaleDataFactory.GenerateInsert: TSaleShowDTO;
begin
  const LInput: SH<TSaleInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TSaleDataFactory.Make(APersistenceUseCase: ISalePersistenceUseCase): ISaleDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
