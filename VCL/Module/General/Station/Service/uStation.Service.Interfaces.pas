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
    ['{DAEEEAD7-1964-4D69-B032-20507221E5B5}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TStationFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TStationShowDTO;
    function StoreAndShow(AInput: TStationInputDTO): Either<String, TStationShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TStationInputDTO): Either<String, TStationShowDTO>;
  End;

implementation

end.
