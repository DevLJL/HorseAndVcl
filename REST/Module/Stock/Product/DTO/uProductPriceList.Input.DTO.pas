unit uProductPriceList.Input.DTO;

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
  TProductPriceListInputDTO = class(TBaseDTO)
  private
    Fprice: Double;
    Fprice_list_id: Int64;
  public
    [SwagNumber]
    [SwagProp('price_list_id', 'Lista de Preço (ID)', true)]
    property price_list_id: Int64 read Fprice_list_id write Fprice_list_id;

    [SwagNumber]
    [SwagProp('price', 'Preço', true)]
    property price: Double read Fprice write Fprice;
  end;

implementation

end.


