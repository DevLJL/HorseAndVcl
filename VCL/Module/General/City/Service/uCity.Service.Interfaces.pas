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
    ['{9821CEAD-4270-49C2-80D4-61BF7D64AF52}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCityFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCityShowDTO;
    function StoreAndShow(AInput: TCityInputDTO): Either<String, TCityShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCityInputDTO): Either<String, TCityShowDTO>;
  End;

implementation

end.
