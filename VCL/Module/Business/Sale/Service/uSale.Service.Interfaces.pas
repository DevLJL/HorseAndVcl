unit uSale.Service.Interfaces;

interface

uses
  uBase.Service,
  uSale.Filter.DTO,
  uIndexResult,
  uSale.Show.DTO,
  uSale.Input.DTO,
  uEither,
  uSale.Types;

type
  ISaleService = Interface(IBaseService)
    ['{9C50D5DC-B425-4D70-9B5D-7D9758436A8B}']
    function Delete(AId: Int64): Boolean;
    function GenerateBilling(AId: Int64; AOperation: TSaleGenerateBillingOperation): Either<String, TSaleShowDTO>;
    function Index(AFilter: TSaleFilterDTO = nil): Either<String, IIndexResult>;
    function PdfReport(AId: Int64): ISaleService;
    function SendPdfReport(AId: Int64): Boolean;
    function Show(AId: Int64): TSaleShowDTO;
    function StoreAndGenerateBilling(AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
    function StoreAndShow(AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
  End;

implementation

end.
