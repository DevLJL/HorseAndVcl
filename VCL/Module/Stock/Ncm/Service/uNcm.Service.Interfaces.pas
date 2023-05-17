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
    ['{A18ABA04-5EF0-4824-AE32-BA284E75D22A}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TNcmFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TNcmShowDTO;
    function StoreAndShow(AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
  End;

implementation

end.
