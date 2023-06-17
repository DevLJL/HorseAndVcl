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
    ['{26CED9AB-CDEE-40A5-9176-94A49F4C5910}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TProductFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TProductShowDTO;
    function ShowByEanOrSkuCode(AValue: String): TProductShowDTO;
    function StoreAndShow(AInput: TProductInputDTO): Either<String, TProductShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TProductInputDTO): Either<String, TProductShowDTO>;
  End;

implementation

end.
