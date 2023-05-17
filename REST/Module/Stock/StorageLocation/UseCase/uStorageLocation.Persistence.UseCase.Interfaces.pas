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
    ['{6391C6D7-B5B0-41EF-9C46-4D7E004C1960}']
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
