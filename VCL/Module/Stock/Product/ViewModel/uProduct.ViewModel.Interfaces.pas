unit uProduct.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uProduct.Show.DTO,
  uProduct.Input.DTO,
  uZLMemTable.Interfaces;

type
  IProductViewModel = Interface(IBaseViewModel)
    ['{C246A232-20A6-41EB-B25D-37181BEC4175}']
    function  FromShowDTO(AInput: TProductShowDTO): IProductViewModel;
    function  ToInputDTO: TProductInputDTO;
    function  EmptyDataSets: IProductViewModel;
    function  SetEvents: IProductViewModel;

    function  Product: IZLMemTable;
    function  ProductPriceLists: IZLMemTable;
  end;

  IProductPriceListsViewModel = Interface
    ['{D0B3917E-1B66-4B29-8FD8-64710146E406}']
    function  ProductPriceLists: IZLMemTable;
    function  SetEvents: IProductPriceListsViewModel;
  End;

implementation

end.


