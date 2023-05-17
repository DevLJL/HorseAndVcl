unit uStation.Service.Interfaces;

interface

uses
  uBase.Service,
  uStation.Filter.DTO,
  uIndexResult,
  uStation.Show.DTO,
  uStation.Input.DTO,
  uEither;

type
  IStationService = Interface(IBaseService)
    ['{32133C5C-1CE2-4221-8FBC-5C0B01DD0E0C}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TStationFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TStationShowDTO;
    function StoreAndShow(AInput: TStationInputDTO): Either<String, TStationShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TStationInputDTO): Either<String, TStationShowDTO>;
  End;

implementation

end.
