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
    ['{19537FB3-0298-423A-B5D3-2D3A997FA84C}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TStorageLocationFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TStorageLocationShowDTO;
    function StoreAndShow(AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
  End;

implementation

end.
