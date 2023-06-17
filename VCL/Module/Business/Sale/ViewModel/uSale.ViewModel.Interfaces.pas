unit uSale.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uSale.Show.DTO,
  uSale.Input.DTO,
  uZLMemTable.Interfaces;

type
  ISaleViewModel = Interface(IBaseViewModel)
    ['{EA4AEF75-D617-468E-9E0E-E9605DFFAE94}']
    function  FromShowDTO(AInput: TSaleShowDTO): ISaleViewModel;
    function  ToInputDTO: TSaleInputDTO;
    function  EmptyDataSets: ISaleViewModel;
    function  CalcFields: ISaleViewModel;
    function  SetEvents: ISaleViewModel;

    function  Sale: IZLMemTable;
    function  SaleItems: IZLMemTable;
    function  SalePayments: IZLMemTable;
  end;

  ISaleItemsViewModel = Interface
    ['{2D90578A-4BC3-41BC-81F0-D65314B18FC9}']
    function  SaleItems: IZLMemTable;
    function  SetEvents: ISaleItemsViewModel;
  End;

  ISalePaymentsViewModel = Interface
    ['{9DBE7594-A1AC-4DA3-834C-A252CBFBD69A}']
    function  SalePayments: IZLMemTable;
    function  SetEvents: ISalePaymentsViewModel;
  End;

implementation

end.
