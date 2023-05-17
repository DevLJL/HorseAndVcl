unit uPaymentTerm.Show.DTO;

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
  uPaymentTerm.Input.DTO;

type
  TPaymentTermShowDTO = class(TPaymentTermInputDTO)
  private
    Fpayment_id: Int64;
    Fid: Int64;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagNumber]
    [SwagProp('payment_id', 'Pagamento (ID)', true)]
    property payment_id: Int64 read Fpayment_id write Fpayment_id;
  end;

implementation

end.


