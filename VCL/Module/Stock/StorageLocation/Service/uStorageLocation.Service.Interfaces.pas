unit uStorageLocation.Service.Interfaces;

interface

uses
  uBase.Service,
  uStorageLocation.Filter.DTO,
  uIndexResult,
  uStorageLocation.Show.DTO,
  uStorageLocation.Input.DTO,
  uEither;

type
  IStorageLocationService = Interface(IBaseService)
    ['{6EA019A5-885B-427D-9AE8-099D0F8A8D19}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TStorageLocationFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TStorageLocationShowDTO;
    function StoreAndShow(AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
  End;

implementation

end.
