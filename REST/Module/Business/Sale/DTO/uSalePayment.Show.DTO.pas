unit uSalePayment.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uSalePayment.Input.DTO;

type
  TSalePaymentShowDTO = class(TSalePaymentInputDTO)
  private
    Fbank_account_name: String;
    Fpayment_name: String;
  public
    [SwagString]
    [SwagProp('payment_name', 'Pagamento (Nome)', true)]
    property payment_name: String read Fpayment_name write Fpayment_name;

    [SwagString]
    [SwagProp('bank_account_name', 'Conta Bancária (Nome)', true)]
    property bank_account_name: String read Fbank_account_name write Fbank_account_name;
  end;

implementation

end.


