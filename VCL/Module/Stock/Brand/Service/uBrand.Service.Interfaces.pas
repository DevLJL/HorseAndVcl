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
    ['{48E0A99F-B8C3-405B-BE22-38340337E207}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBrandFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBrandShowDTO;
    function StoreAndShow(AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
  End;

implementation

end.
