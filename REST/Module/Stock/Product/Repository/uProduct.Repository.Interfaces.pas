unit uProduct.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uProduct,
  uProduct.Types;

type
  IProductRepository = interface(IBaseRepository)
    ['{6FBF62B4-5ECA-45C6-A050-958C2EB023AC}']
    function Show(AId: Int64): TProduct;
    function MoveProduct(AProductId: Int64; AIncOrDecQuantity: Double; AMovType: TProductMovStock): IProductRepository;
    function ShowByEanOrSkuCode(AValue: String): TProduct;
  end;

implementation

end.



