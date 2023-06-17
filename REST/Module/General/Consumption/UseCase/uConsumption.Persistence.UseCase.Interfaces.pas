unit uConsumption.Persistence.UseCase.Interfaces;

interface

uses
  uConsumption.Filter.DTO,
  uIndexResult,
  uConsumption.Show.DTO,
  uConsumption.Input.DTO,
  uFilter,
  uEither,
  uConsumptionSale.Filter.DTO,
  uZLMemTable.Interfaces;

type
  IConsumptionPersistenceUseCase = Interface
    ['{231CC855-5CF0-497F-8868-4404E7138E45}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TConsumptionFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function IndexWithSale(AFilterSaleDTO: TConsumptionSaleFilterDTO): IZLMemTable overload;
    function Show(APK: Int64): TConsumptionShowDTO;
    function StoreAndShow(AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
    function Store(AInput: TConsumptionInputDTO): Int64;
    function Update(APK: Int64; AInput: TConsumptionInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TConsumptionInputDTO): Either<String, TConsumptionShowDTO>;
  end;


implementation

end.
