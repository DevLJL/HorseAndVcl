unit uCategory.Service.Interfaces;

interface

uses
  uBase.Service,
  uCategory.Filter.DTO,
  uIndexResult,
  uCategory.Show.DTO,
  uCategory.Input.DTO,
  uEither;

type
  ICategoryService = Interface(IBaseService)
    ['{1789AEC8-CBD9-4B5E-84EA-820617FC1CD4}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCategoryFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCategoryShowDTO;
    function StoreAndShow(AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
  End;

implementation

end.
