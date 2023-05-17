unit uSaleItem.Input.DTO;

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
  TSaleItemInputDTO = class(TBaseDTO)
  private
    Funit_discount: Double;
    Fproduct_id: Int64;
    Fprice: Double;
    Fnote: String;
    Fquantity: Double;
    Fseller_id: Int64;
  public
    [SwagNumber]
    [SwagProp('product_id', 'Produto (ID)', true)]
    property product_id: Int64 read Fproduct_id write Fproduct_id;

    [SwagNumber]
    [SwagProp('quantity', 'Quantidade', true)]
    property quantity: Double read Fquantity write Fquantity;

    [SwagNumber]
    [SwagProp('price', 'Preço', true)]
    property price: Double read Fprice write Fprice;

    [SwagNumber]
    [SwagProp('unit_discount', 'Desconto Unitário', false)]
    property unit_discount: Double read Funit_discount write Funit_discount;

    [SwagNumber]
    [SwagProp('seller_id', 'Vendedor (ID)', true)]
    property seller_id: Int64 read Fseller_id write Fseller_id;

    [SwagString]
    [SwagProp('note', 'Observação', false)]
    property note: String read Fnote write Fnote;
  end;

implementation

end.


