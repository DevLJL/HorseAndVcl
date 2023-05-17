unit uProduct.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uProduct,
  uProduct.Types;

type
  IProductRepository = interface(IBaseRepository)
    ['{ED041641-24CE-4AB5-B463-E0A964928866}']
    function Show(AId: Int64): TProduct;
    function MoveProduct(AProductId: Int64; AIncOrDecQuantity: Double; AMovType: TProductMovStock): IProductRepository;
    function ShowByEanOrSkuCode(AValue: String): TProduct;
  end;

implementation

end.



