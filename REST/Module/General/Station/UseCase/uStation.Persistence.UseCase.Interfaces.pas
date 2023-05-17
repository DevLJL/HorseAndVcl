unit uStation.Persistence.UseCase.Interfaces;

interface

uses
  uStation.Filter.DTO,
  uIndexResult,
  uStation.Show.DTO,
  uStation.Input.DTO,
  uFilter,
  uEither;

type
  IStationPersistenceUseCase = Interface
    ['{AA62F082-9D94-4A35-9268-020503A32C96}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TStationFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TStationShowDTO;
    function StoreAndShow(AInput: TStationInputDTO): Either<String, TStationShowDTO>;
    function Store(AInput: TStationInputDTO): Int64;
    function Update(APK: Int64; AInput: TStationInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TStationInputDTO): Either<String, TStationShowDTO>;
  end;

implementation

end.
