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
    ['{975F0CA2-B5F5-4AFC-94F2-62A21B638B21}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TUnitFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TUnitShowDTO;
    function StoreAndShow(AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
  End;

implementation

end.
