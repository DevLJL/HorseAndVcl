unit uSale.BeforeSave;

interface

uses
  uSale,
  uAppRest.Types;

type
  ISaleBeforeSave = Interface
    ['{582F3604-7F89-4BBE-B542-5011E1A689DE}']
    function Execute: ISaleBeforeSave;
  end;

  TSaleBeforeSave = class(TInterfacedObject, ISaleBeforeSave)
  private
    FEntity: TSale;
    FState: TEntityState;
    constructor Create(AEntity: TSale; AStateEnum: TEntityState);
    function HandleSale: ISaleBeforeSave;
    function HandleSalePayments: ISaleBeforeSave;
    function HandleSaleItems: ISaleBeforeSave;
  public
    class function Make(AEntity: TSale; AStateEnum: TEntityState): ISaleBeforeSave;
    function Execute: ISaleBeforeSave;
  end;

implementation

uses
  uHlp,
  System.SysUtils,
  uSalePayment,
  uSaleItem,
  uSale.Types;

{ TSaleBeforeSave }

constructor TSaleBeforeSave.Create(AEntity: TSale; AStateEnum: TEntityState);
begin
  inherited Create;
  FEntity := AEntity;
  FState  := AStateEnum;
end;

function TSaleBeforeSave.Execute: ISaleBeforeSave;
begin
  Result := Self;

  HandleSale;
  HandleSaleItems;
  HandleSalePayments;
end;

function TSaleBeforeSave.HandleSale: ISaleBeforeSave;
begin
  Result := Self;

  // Valores Padrão para inserção
  if (FState = TEntityState.Store) then
  begin
    FEntity.status                := TSaleStatus.Pending;
    FEntity.delivery_status       := TSaleDeliveryStatus.New;
    FEntity.flg_payment_requested := 0;
  end;
end;

function TSaleBeforeSave.HandleSaleItems: ISaleBeforeSave;
begin
  Result := Self;

  for var LSaleItem in FEntity.sale_items do
  begin
    if (LSaleItem.seller_id <= 0) then
      LSaleItem.seller_id := FEntity.seller_id;
  end;
end;

function TSaleBeforeSave.HandleSalePayments: ISaleBeforeSave;
begin
  // Se houver valor adicional em pagamentos, será realizado o abatimento na ultima parcela
  const LSumSalePaymentAmount: Double = FEntity.sum_sale_payment_amount;
  const LTotal: Double = FEntity.total;
  if (LSumSalePaymentAmount > LTotal) then
  begin
    var lSlaughterValue: Double := LSumSalePaymentAmount - LTotal;
    const LSalePayment = FEntity.sale_payments.Last;

    LSalePayment.amount := LSalePayment.amount - lSlaughterValue;
    if (LSalePayment.amount <= 0) then
      FEntity.sale_payments.Remove(LSalePayment);
  end;
end;

class function TSaleBeforeSave.Make(AEntity: TSale; AStateEnum: TEntityState): ISaleBeforeSave;
begin
  Result := Self.Create(AEntity, AStateEnum);
end;

end.


