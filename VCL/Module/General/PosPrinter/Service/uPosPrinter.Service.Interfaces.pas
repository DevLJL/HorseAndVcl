unit uPosPrinter.Service.Interfaces;

interface

uses
  uBase.Service,
  uPosPrinter.Filter.DTO,
  uIndexResult,
  uPosPrinter.Show.DTO,
  uPosPrinter.Input.DTO,
  uEither;

type
  IPosPrinterService = Interface(IBaseService)
    ['{BBA08BB5-DC0B-431F-9781-D2949E958E32}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TPosPrinterFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TPosPrinterShowDTO;
    function StoreAndShow(AInput: TPosPrinterInputDTO): Either<String, TPosPrinterShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TPosPrinterInputDTO): Either<String, TPosPrinterShowDTO>;
  End;

implementation

end.
