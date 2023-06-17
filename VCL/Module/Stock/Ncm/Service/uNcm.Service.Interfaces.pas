unit uNcm.Service.Interfaces;

interface

uses
  uBase.Service,
  uNcm.Filter.DTO,
  uIndexResult,
  uNcm.Show.DTO,
  uNcm.Input.DTO,
  uEither;

type
  INcmService = Interface(IBaseService)
    ['{F79C4032-8FB6-45A9-871A-E0BFF84C0D13}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TNcmFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TNcmShowDTO;
    function StoreAndShow(AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
  End;

implementation

end.
