unit uCostCenter.Service.Interfaces;

interface

uses
  uBase.Service,
  uCostCenter.Filter.DTO,
  uIndexResult,
  uCostCenter.Show.DTO,
  uCostCenter.Input.DTO,
  uEither;

type
  ICostCenterService = Interface(IBaseService)
    ['{32133C5C-1CE2-4221-8FBC-5C0B01DD0E0C}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCostCenterFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCostCenterShowDTO;
    function StoreAndShow(AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
  End;

implementation

end.
