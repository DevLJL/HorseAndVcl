unit uPriceList.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uPriceList.Show.DTO,
  uPriceList.Input.DTO,
  uZLMemTable.Interfaces;

type
  IPriceListViewModel = Interface(IBaseViewModel)
    ['{0FC72A6D-C011-42CC-B659-4652E642C13B}']
    function  FromShowDTO(AInput: TPriceListShowDTO): IPriceListViewModel;
    function  ToInputDTO: TPriceListInputDTO;
    function  EmptyDataSets: IPriceListViewModel;
    function  SetEvents: IPriceListViewModel;

    function  PriceList: IZLMemTable;
  end;

implementation

end.


