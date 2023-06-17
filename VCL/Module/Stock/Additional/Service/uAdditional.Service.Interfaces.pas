unit uAdditional.Service.Interfaces;

interface

uses
  uBase.Service,
  uAdditional.Filter.DTO,
  uIndexResult,
  uAdditional.Show.DTO,
  uAdditional.Input.DTO,
  uEither;

type
  IAdditionalService = Interface(IBaseService)
    ['{7DF4561F-632A-4C76-AD1D-08C245CED2C5}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TAdditionalFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TAdditionalShowDTO;
    function StoreAndShow(AInput: TAdditionalInputDTO): Either<String, TAdditionalShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TAdditionalInputDTO): Either<String, TAdditionalShowDTO>;
  End;

implementation

end.
