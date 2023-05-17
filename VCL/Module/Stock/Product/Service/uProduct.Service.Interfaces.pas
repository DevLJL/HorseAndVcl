unit uProduct.Service.Interfaces;

interface

uses
  uBase.Service,
  uProduct.Filter.DTO,
  uIndexResult,
  uProduct.Show.DTO,
  uProduct.Input.DTO,
  uEither;

type
  IProductService = Interface(IBaseService)
    ['{03E3F7CB-4193-4072-B585-A0DA6BF89534}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TProductFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TProductShowDTO;
    function StoreAndShow(AInput: TProductInputDTO): Either<String, TProductShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TProductInputDTO): Either<String, TProductShowDTO>;
  End;

implementation

end.
