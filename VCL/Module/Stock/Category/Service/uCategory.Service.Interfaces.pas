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
    ['{EEB8866C-A33C-4DC5-80A2-D210B38B1B3E}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCategoryFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCategoryShowDTO;
    function StoreAndShow(AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
  End;

implementation

end.
