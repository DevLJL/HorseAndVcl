unit uSaleItem.Show.DTO;

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
  uSaleItem.Input.DTO;

type
  TSaleItemShowDTO = class(TSaleItemInputDTO)
  private
    Fsale_id: Int64;
    Fid: Int64;
    Fsubtotal: Double;
    Ftotal: Double;
    Fproduct_unit_name: String;
    Fproduct_name: String;
    Fproduct_unit_id: Int64;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagNumber]
    [SwagProp('sale_id', 'Pagamento (ID)', true)]
    property sale_id: Int64 read Fsale_id write Fsale_id;

    [SwagString]
    [SwagProp('product_name', 'Produto (Nome)', true)]
    property product_name: String read Fproduct_name write Fproduct_name;

    [SwagNumber]
    [SwagProp('product_unit_id', 'Unidade de Medida (ID)', true)]
    property product_unit_id: Int64 read Fproduct_unit_id write Fproduct_unit_id;

    [SwagNumber]
    [SwagProp('product_unit_name', 'Unidade de Medida (Nome)', true)]
    property product_unit_name: String read Fproduct_unit_name write Fproduct_unit_name;

    [SwagNumber]
    [SwagProp('subtotal', 'Subtotal', true)]
    property subtotal: Double read Fsubtotal write Fsubtotal;

    [SwagNumber]
    [SwagProp('total', 'Total', true)]
    property total: Double read Ftotal write Ftotal;
  end;

implementation

end.


