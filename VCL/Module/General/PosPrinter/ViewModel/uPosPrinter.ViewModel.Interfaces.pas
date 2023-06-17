unit uPosPrinter.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uPosPrinter.Show.DTO,
  uPosPrinter.Input.DTO,
  uZLMemTable.Interfaces;

type
  IPosPrinterViewModel = Interface(IBaseViewModel)
    ['{0AB9E6B8-B063-48EE-B769-95D2A47600BD}']
    function  FromShowDTO(AInput: TPosPrinterShowDTO): IPosPrinterViewModel;
    function  ToInputDTO: TPosPrinterInputDTO;
    function  EmptyDataSets: IPosPrinterViewModel;
    function  SetEvents: IPosPrinterViewModel;

    function  PosPrinter: IZLMemTable;
  end;

implementation

end.


