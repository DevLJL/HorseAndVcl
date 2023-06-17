unit uPosPrinter.Persistence.UseCase.Interfaces;

interface

uses
  uPosPrinter.Filter.DTO,
  uIndexResult,
  uPosPrinter.Show.DTO,
  uPosPrinter.Input.DTO,
  uFilter,
  uEither;

type
  IPosPrinterPersistenceUseCase = Interface
    ['{40A6E5BC-DFF1-4899-B065-79DFAC244269}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TPosPrinterFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TPosPrinterShowDTO;
    function StoreAndShow(AInput: TPosPrinterInputDTO): Either<String, TPosPrinterShowDTO>;
    function Store(AInput: TPosPrinterInputDTO): Int64;
    function Update(APK: Int64; AInput: TPosPrinterInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TPosPrinterInputDTO): Either<String, TPosPrinterShowDTO>;
  end;

implementation

end.
