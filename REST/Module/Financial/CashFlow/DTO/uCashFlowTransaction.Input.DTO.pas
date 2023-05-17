unit uCashFlowTransaction.Input.DTO;

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
  System.Generics.Collections,
  uCashFlowTransaction.Types;

type
  TCashFlowTransactionInputDTO = class(TBaseDTO)
  private
    Fperson_id: Int64;
    Fhistory: String;
    Ftransaction_date: TDateTime;
    Fpayment_id: Int64;
    Fnote: String;
    Famount: Double;
    Fflg_manual_transaction: SmallInt;
    Ftype: TCashFlowTransactionType;
    Fsale_id: Int64;
  public
    [SwagNumber]
    [SwagProp('flg_manual_transaction', 'Transação Manual', false)]
    property flg_manual_transaction: SmallInt read Fflg_manual_transaction write Fflg_manual_transaction;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('transaction_date', 'Transação Manual', true)]
    property transaction_date: TDateTime read Ftransaction_date write Ftransaction_date;

    [SwagString(80)]
    [SwagProp('history', 'Histórico', true)]
    property history: String read Fhistory write Fhistory;

    [SwagNumber]
    [SwagProp('type', 'Tipo [0..1] 0-Debito, 1-Credito', false)]
    property &type: TCashFlowTransactionType read Ftype write Ftype;

    [SwagNumber]
    [SwagProp('amount', 'Valor', false)]
    property amount: Double read Famount write Famount;

    [SwagNumber]
    [SwagProp('payment_id', 'Pagamento (ID)', true)]
    property payment_id: Int64 read Fpayment_id write Fpayment_id;

    [SwagString]
    [SwagProp('note', 'Observação', false)]
    property note: String read Fnote write Fnote;

    [SwagNumber]
    [SwagProp('sale_id', 'Venda (ID)', false)]
    property sale_id: Int64 read Fsale_id write Fsale_id;

    [SwagNumber]
    [SwagProp('person_id', 'Pessoa (ID)', false)]
    property person_id: Int64 read Fperson_id write Fperson_id;
  end;

implementation

end.


