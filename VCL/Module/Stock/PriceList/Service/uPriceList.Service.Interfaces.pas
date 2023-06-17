unit uPriceList.Service.Interfaces;

interface

uses
  uBase.Service,
  uPriceList.Filter.DTO,
  uIndexResult,
  uPriceList.Show.DTO,
  uPriceList.Input.DTO,
  uEither;

type
  IPriceListService = Interface(IBaseService)
    ['{44432E0E-0A9E-4159-A8D4-594CEEC9CD40}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TPriceListFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TPriceListShowDTO;
    function StoreAndShow(AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
  End;

implementation

end.
