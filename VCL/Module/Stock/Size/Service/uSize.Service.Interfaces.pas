unit uSize.Service.Interfaces;

interface

uses
  uBase.Service,
  uSize.Filter.DTO,
  uIndexResult,
  uSize.Show.DTO,
  uSize.Input.DTO,
  uEither;

type
  ISizeService = Interface(IBaseService)
    ['{6E08ED8A-83F1-4A2C-9009-3366F1D0F194}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TSizeFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TSizeShowDTO;
    function StoreAndShow(AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
  End;

implementation

end.
