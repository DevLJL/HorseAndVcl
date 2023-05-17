unit uBrand.Service.Interfaces;

interface

uses
  uBase.Service,
  uBrand.Filter.DTO,
  uIndexResult,
  uBrand.Show.DTO,
  uBrand.Input.DTO,
  uEither;

type
  IBrandService = Interface(IBaseService)
    ['{32133C5C-1CE2-4221-8FBC-5C0B01DD0E0C}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBrandFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBrandShowDTO;
    function StoreAndShow(AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
  End;

implementation

end.
