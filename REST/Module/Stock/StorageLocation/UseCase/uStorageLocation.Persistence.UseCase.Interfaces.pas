unit uStorageLocation.Persistence.UseCase.Interfaces;

interface

uses
  uStorageLocation.Filter.DTO,
  uIndexResult,
  uStorageLocation.Show.DTO,
  uStorageLocation.Input.DTO,
  uFilter,
  uEither;

type
  IStorageLocationPersistenceUseCase = Interface
    ['{A5F676C9-0E28-422D-9DDD-80B79C678624}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TStorageLocationFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TStorageLocationShowDTO;
    function StoreAndShow(AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
    function Store(AInput: TStorageLocationInputDTO): Int64;
    function Update(APK: Int64; AInput: TStorageLocationInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TStorageLocationInputDTO): Either<String, TStorageLocationShowDTO>;
  end;

implementation

end.
