unit uSalePayment.Input.DTO;

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
  System.Generics.Collections;

type
  TSalePaymentInputDTO = class(TBaseDTO)
  private
    Fbank_account_id: Int64;
    Fpayment_id: Int64;
    Fdue_date: TDateTime;
    Fcollection_uuid: String;
    Fnote: String;
    Famount: Double;
  public
    [SwagNumber]
    [SwagProp('collection_uuid', 'UUID', true)]
    property collection_uuid: String read Fcollection_uuid write Fcollection_uuid;

    [SwagNumber]
    [SwagProp('payment_id', 'Pagamento (ID)', true)]
    property payment_id: Int64 read Fpayment_id write Fpayment_id;

    [SwagNumber]
    [SwagProp('bank_account_id', 'Conta Bancária (ID)', true)]
    property bank_account_id: Int64 read Fbank_account_id write Fbank_account_id;

    [SwagNumber]
    [SwagProp('amount', 'Valor', true)]
    property amount: Double read Famount write Famount;

    [SwagString]
    [SwagProp('note', 'Observação', false)]
    property note: String read Fnote write Fnote;

    [SwagDate(DATE_DISPLAY_FORMAT)]
    [SwagProp('due_date', 'Vencimento', true)]
    property due_date: TDateTime read Fdue_date write Fdue_date;
  end;

implementation

end.


