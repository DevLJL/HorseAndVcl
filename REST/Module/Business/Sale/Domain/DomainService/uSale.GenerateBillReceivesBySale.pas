unit uSale.GenerateBillReceivesBySale;

interface

uses
  uSale,
  uBillPayReceive,
  System.Generics.Collections;

type
  ISaleGenerateBillReceivesBySale = Interface
    ['{0DED83DA-B40E-418B-B53E-2D16BE12F944}']
    function Execute(ASale: TSale): TObjectList<TBillPayReceive>;
  End;

  TSaleGenerateBillReceivesBySale = class(TInterfacedObject, ISaleGenerateBillReceivesBySale)
  private
  public
    class function Make: ISaleGenerateBillReceivesBySale;
    function Execute(ASale: TSale): TObjectList<TBillPayReceive>;
  end;

implementation

{ TSaleGenerateBillReceivesBySale }

uses
  uHlp,
  uSalePayment,
  uBillPayReceive.Types,
  System.Classes,
  System.SysUtils;

function TSaleGenerateBillReceivesBySale.Execute(ASale: TSale): TObjectList<TBillPayReceive>;
begin
  Result := TObjectList<TBillPayReceive>.Create;

  var   lCont: Integer := 0;
  const lBatch = NextUUID;
  for var LSalePayment in ASale.sale_payments do
  begin
    Inc(lCont);
    const LBillPayReceive = TBillPayReceive.Create;
    LBillPayReceive.batch                  := lBatch;
    LBillPayReceive.&type                  := TBillPayReceiveType.Credit;
    LBillPayReceive.short_description      := 'Venda Nº ' + ASale.id.ToString + ' realizada em ' + DateTimeToStr(now);
    LBillPayReceive.person_id              := ASale.person_id;
    LBillPayReceive.chart_of_account_id    := 0;
    LBillPayReceive.cost_center_id         := 0;
    LBillPayReceive.bank_account_id        := LSalePayment.bank_account_id;
    LBillPayReceive.payment_id             := LSalePayment.payment_id;
    LBillPayReceive.due_date               := LSalePayment.due_date;
    LBillPayReceive.installment_quantity   := ASale.sale_payments.Count;
    LBillPayReceive.installment_number     := lCont;
    LBillPayReceive.amount                 := LSalePayment.amount;
    LBillPayReceive.discount               := 0;
    LBillPayReceive.interest_and_fine      := 0;
    LBillPayReceive.note                   := '';
    LBillPayReceive.sale_id                := ASale.id;
    LBillPayReceive.created_by_acl_user_id := ASale.created_by_acl_user_id;

    // Lan�ar Documento como recebido dependendo da configuracao do pagamento
    case IntBool(LSalePayment.payment.flg_post_as_received) of
      True: Begin
        LBillPayReceive.status       := TBillPayReceiveStatus.Approved;
        LBillPayReceive.payment_date := now;
      end;
      False: LBillPayReceive.status := TBillPayReceiveStatus.Pending;
    end;

    // Validar
    const lError = LBillPayReceive.Validate;
    if not lError.Trim.IsEmpty then
      raise Exception.Create('Falha na validação dos dados: ' + lError);

    // Incluir no retorno (Listagem de BillPayReceive)
    Result.Add(LBillPayReceive);
  end;
end;

class function TSaleGenerateBillReceivesBySale.Make: ISaleGenerateBillReceivesBySale;
begin
  Result := Self.Create;
end;

end.

