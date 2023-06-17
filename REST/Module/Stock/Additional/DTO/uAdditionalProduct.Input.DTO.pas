unit uAdditionalProduct.Input.DTO;

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
  TAdditionalProductInputDTO = class(TBaseDTO)
  private
    Fproduct_id: Int64;
  public
    [SwagNumber]
    [SwagProp('product_id', 'Produto (ID)', true)]
    property product_id: Int64 read Fproduct_id write Fproduct_id;
  end;

implementation

end.


