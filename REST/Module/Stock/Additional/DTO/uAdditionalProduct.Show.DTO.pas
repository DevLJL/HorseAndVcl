unit uAdditionalProduct.Show.DTO;

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
  uAdditionalProduct.Input.DTO;

type
  TAdditionalProductShowDTO = class(TAdditionalProductInputDTO)
  private
    Fproduct_name: String;
  public
    [SwagString]
    [SwagProp('product_name', 'Produto (Nome)', true)]
    property product_name: String read Fproduct_name write Fproduct_name;
  end;

implementation

end.


