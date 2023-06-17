unit uPosPrinter.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uPosPrinter;

type
  IPosPrinterRepository = interface(IBaseRepository)
    ['{DDBB5613-8AE3-4EED-9578-198BD50626A5}']
    function Show(AId: Int64): TPosPrinter;
  end;

implementation

end.


