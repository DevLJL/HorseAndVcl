unit uCity.Service.Interfaces;

interface

uses
  uBase.Service,
  uCity.Filter.DTO,
  uIndexResult,
  uCity.Show.DTO,
  uCity.Input.DTO,
  uEither;

type
  ICityService = Interface(IBaseService)
    ['{6CFF6182-3301-4209-B4F0-C6233A4B9B26}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCityFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCityShowDTO;
    function StoreAndShow(AInput: TCityInputDTO): Either<String, TCityShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCityInputDTO): Either<String, TCityShowDTO>;
  End;

implementation

end.
