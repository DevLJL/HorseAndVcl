unit uSale.GenerateCashFlowTransactionsBySale;

interface

uses
  uSale,
  uCashFlowTransaction,
  uCashFlowTransaction.Types,
  System.Generics.Collections;

type
  ISaleGenerateCashFlowTransactionsBySale = Interface
    ['{9A174889-A6C0-47E8-B551-F1DDBC828F05}']
    function Execute(ASale: TSale; ACashFlowID: Int64; AType: TCashFlowTransactionType): TObjectList<TCashFlowTransaction>;
  End;

  TSaleGenerateCashFlowTransactionsBySale = class(TInterfacedObject, ISaleGenerateCashFlowTransactionsBySale)
  public
    class function Make: ISaleGenerateCashFlowTransactionsBySale;
    function Execute(ASale: TSale; ACashFlowID: Int64; AType: TCashFlowTransactionType): TObjectList<TCashFlowTransaction>;
  end;

implementation

{ TSaleGenerateCashFlowTransactionsBySale }

uses
  uHlp,
  System.Classes,
  System.SysUtils;

function TSaleGenerateCashFlowTransactionsBySale.Execute(ASale: TSale; ACashFlowID: Int64; AType: TCashFlowTransactionType): TObjectList<TCashFlowTransaction>;
var
  LHistory: String;
begin
  Result := TObjectList<TCashFlowTransaction>.Create;

  // Definir Histórico e Tipo de transação
  case AType of
    TCashFlowTransactionType.Credit: LHistory := 'Venda';
    TCashFlowTransactionType.Debit:  LHistory := 'Venda (Estorno)';
  end;

  // Gerar Transações para fluxo de caixa a partir dos pagamentos da venda
  for var LSalePayment in ASale.sale_payments do
  begin
    const LCashFlowTransaction = TCashFlowTransaction.Create;
    With LCashFlowTransaction do
    begin
      cash_flow_id           := ACashFlowID;
      flg_manual_transaction := 0;
      transaction_date       := now;
      history                := LHistory;
      &type                  := AType;
      amount                 := LSalePayment.amount;
      payment_id             := LSalePayment.payment_id;
      note                   := EmptyStr;
      sale_id                := ASale.id;
      person_id              := ASale.person_id;
    end;
    Result.Add(LCashFlowTransaction);
  end;
end;

class function TSaleGenerateCashFlowTransactionsBySale.Make: ISaleGenerateCashFlowTransactionsBySale;
begin
  Result := Self.Create;
end;

end.

