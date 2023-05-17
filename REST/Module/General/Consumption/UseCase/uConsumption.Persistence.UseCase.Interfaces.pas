unit uConsumption.Persistence.UseCase.Interfaces;

interface

uses
  uConsumption.Filter.DTO,
  uIndexResult,
  uConsumption.Show.DTO,
  uConsumption.Input.DTO,
  uFilter,
  uEither;

type
  IConsumptionPersistenceUseCase = Interface
    ['{E78611B2-AE84-42FE-9F42-FB0327DCDC27}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TConsumptionFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TConsumptionShowDTO;
    function StoreAndShow(AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
    function Store(AInput: TConsumptionInputDTO): Int64;
    function Update(APK: Int64; AInput: TConsumptionInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
  end;


implementation

end.
