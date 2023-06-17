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
    ['{5F57E759-ABAF-4816-811B-47C9F4120E1B}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCostCenterFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCostCenterShowDTO;
    function StoreAndShow(AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
  End;

implementation

end.
