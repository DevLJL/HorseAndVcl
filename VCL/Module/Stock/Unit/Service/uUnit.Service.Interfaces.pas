unit uUnit.Service.Interfaces;

interface

uses
  uBase.Service,
  uUnit.Filter.DTO,
  uIndexResult,
  uUnit.Show.DTO,
  uUnit.Input.DTO,
  uEither;

type
  IUnitService = Interface(IBaseService)
    ['{E2413092-1EFD-4EA5-A90C-994A66FAF6E7}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TUnitFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TUnitShowDTO;
    function StoreAndShow(AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
  End;

implementation

end.
