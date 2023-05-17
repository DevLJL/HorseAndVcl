unit uSale.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uSale.Show.DTO,
  uSale.Input.DTO,
  uZLMemTable.Interfaces;

type
  ISaleViewModel = Interface(IBaseViewModel)
    ['{DFFE2945-2496-4373-B50B-4ED3D293B2A0}']
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
    ['{A22A23BD-BBAD-461F-9BDB-E46E3CE68CF3}']
    function  SaleItems: IZLMemTable;
    function  SetEvents: ISaleItemsViewModel;
  End;

  ISalePaymentsViewModel = Interface
    ['{A22A23BD-BBAD-461F-9BDB-E46E3CE68CF3}']
    function  SalePayments: IZLMemTable;
    function  SetEvents: ISalePaymentsViewModel;
  End;

implementation

end.
