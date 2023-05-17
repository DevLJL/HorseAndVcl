unit uProduct.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uProduct.Show.DTO,
  uProduct.Input.DTO,
  uZLMemTable.Interfaces;

type
  IProductViewModel = Interface(IBaseViewModel)
    ['{B401D167-8DB4-489F-AB15-149ADD62971B}']
    function  FromShowDTO(AInput: TProductShowDTO): IProductViewModel;
    function  ToInputDTO: TProductInputDTO;
    function  EmptyDataSets: IProductViewModel;
    function  SetEvents: IProductViewModel;

    function  Product: IZLMemTable;
  end;

implementation

end.


