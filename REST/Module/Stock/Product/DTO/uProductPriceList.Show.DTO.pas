unit uProductPriceList.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  XSuperObject,
  uAppRest.Types,
  {$ENDIF}
  uSmartPointer,
  System.Generics.Collections,
  uProductPriceList.Input.DTO;

type
  TProductPriceListShowDTO = class(TProductPriceListInputDTO)
  private
    Fproduct_id: Int64;
    Fid: Int64;
    Fprice_list_name: String;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagNumber]
    [SwagProp('product_id', 'Pessoa (ID)', true)]
    property product_id: Int64 read Fproduct_id write Fproduct_id;

    [SwagString]
    [SwagProp('price_list_name', 'Lista de Preço (Nome)', true)]
    property price_list_name: String read Fprice_list_name write Fprice_list_name;
  end;

implementation

end.


