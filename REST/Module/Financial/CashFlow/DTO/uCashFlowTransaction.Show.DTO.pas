unit uCashFlowTransaction.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  GBSwagger.Model.Attributes,
  Horse.Request,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uCashFlowTransaction.Input.DTO;

type
  TCashFlowTransactionShowDTO = class(TCashFlowTransactionInputDTO)
  private
    Fcash_flow_id: Int64;
    Fid: Int64;
    Fperson_name: String;
    Fpayment_name: String;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagNumber]
    [SwagProp('cash_flow_id', 'Pagamento (ID)', true)]
    property cash_flow_id: Int64 read Fcash_flow_id write Fcash_flow_id;

    [SwagString]
    [SwagProp('payment_name', 'Pagamento (Nome)', true)]
    property payment_name: String read Fpayment_name write Fpayment_name;

    [SwagString]
    [SwagProp('person_name', 'Pessoa (Nome)', true)]
    property person_name: String read Fperson_name write Fperson_name;
  end;

implementation

end.


