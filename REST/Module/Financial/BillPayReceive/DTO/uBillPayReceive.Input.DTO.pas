unit uBillPayReceive.Input.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.DTO,
  XSuperObject,
  uSmartPointer,
  uBillPayReceive.Types;

type
  TBillPayReceiveInputDTO = class(TBaseDTO)
  private
    Facl_user_id: Int64;
    Fperson_id: Int64;
    Fbank_account_id: Int64;
    Finstallment_number: SmallInt;
    Finstallment_quantity: SmallInt;
    Finterest_and_fine: Double;
    Fpayment_id: Int64;
    Fdue_date: TDate;
    Fdiscount: Double;
    Fnote: String;
    Fstatus: TBillPayReceiveStatus;
    Famount: Double;
    Fcost_center_id: Int64;
    Fnet_amount: Double;
    Ftype: TBillPayReceiveType;
    Fbatch: String;
    Fsale_id: Int64;
    Fshort_description: String;
    Fchart_of_account_id: Int64;
    Fpayment_date: TDate;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TBillPayReceiveInputDTO;
    {$ENDIF}

    [SwagString(36)]
    [SwagProp('batch', 'Lote', true)]
    property batch: String read Fbatch write Fbatch;

    [SwagNumber]
    [SwagProp('type', 'Tipo [0..1] 0-Débito, 1-Crédito', false)]
    property &type: TBillPayReceiveType read Ftype write Ftype;

    [SwagString(100)]
    [SwagProp('short_description', 'Descrição', true)]
    property short_description: String read Fshort_description write Fshort_description;

    [SwagNumber]
    [SwagProp('person_id', 'Pessoa (ID)', false)]
    property person_id: Int64 read Fperson_id write Fperson_id;

    [SwagNumber]
    [SwagProp('chart_of_account_id', 'Plano de Conta (ID)', false)]
    property chart_of_account_id: Int64 read Fchart_of_account_id write Fchart_of_account_id;

    [SwagNumber]
    [SwagProp('cost_center_id', 'Centro de Custo (ID)', false)]
    property cost_center_id: Int64 read Fcost_center_id write Fcost_center_id;

    [SwagNumber]
    [SwagProp('bank_account_id', 'Conta Bancária (ID)', true)]
    property bank_account_id: Int64 read Fbank_account_id write Fbank_account_id;

    [SwagNumber]
    [SwagProp('payment_id', 'Pagamento (ID)', true)]
    property payment_id: Int64 read Fpayment_id write Fpayment_id;

    [SwagDate(DATE_DISPLAY_FORMAT)]
    [SwagProp('due_date', 'Vencimento', true)]
    property due_date: TDate read Fdue_date write Fdue_date;

    [SwagNumber]
    [SwagProp('installment_quantity', 'Quantidade de Parcelas', true)]
    property installment_quantity: SmallInt read Finstallment_quantity write Finstallment_quantity;

    [SwagNumber]
    [SwagProp('installment_number', 'Número da Parcelas', true)]
    property installment_number: SmallInt read Finstallment_number write Finstallment_number;

    [SwagNumber]
    [SwagProp('amount', 'Valor', true)]
    property amount: Double read Famount write Famount;

    [SwagNumber]
    [SwagProp('discount', 'Desconto', false)]
    property discount: Double read Fdiscount write Fdiscount;

    [SwagNumber]
    [SwagProp('interest_and_fine', 'Multa e/ou Juros', false)]
    property interest_and_fine: Double read Finterest_and_fine write Finterest_and_fine;

    [SwagNumber]
    [SwagProp('net_amount', 'Saldo', false)]
    property net_amount: Double read Fnet_amount write Fnet_amount;

    [SwagNumber]
    [SwagProp('status', 'Status [0..2] bpPending, bpApproved, bpCanceled', false)]
    property status: TBillPayReceiveStatus read Fstatus write Fstatus;

    [SwagDate(DATE_DISPLAY_FORMAT)]
    [SwagProp('payment_date', 'Pagamento', false)]
    property payment_date: TDate read Fpayment_date write Fpayment_date;

    [SwagString]
    [SwagProp('note', 'Observação', false)]
    property note: String read Fnote write Fnote;

    [SwagNumber]
    [SwagProp('sale_id', 'Venda (ID)', false)]
    property sale_id: Int64 read Fsale_id write Fsale_id;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TBillPayReceiveInputDTO }

{$IFDEF APPREST}
class function TBillPayReceiveInputDTO.FromReq(AReq: THorseRequest): TBillPayReceiveInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TBillPayReceiveInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

