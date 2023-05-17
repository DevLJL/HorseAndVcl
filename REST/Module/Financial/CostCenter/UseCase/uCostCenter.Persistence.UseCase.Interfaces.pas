unit uCostCenter.Persistence.UseCase.Interfaces;

interface

uses
  uCostCenter.Filter.DTO,
  uIndexResult,
  uCostCenter.Show.DTO,
  uCostCenter.Input.DTO,
  uFilter,
  uEither;

type
  ICostCenterPersistenceUseCase = Interface
    ['{17655ED3-913D-4FDD-8C02-5A2AEC9855B6}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCostCenterFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCostCenterShowDTO;
    function StoreAndShow(AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
    function Store(AInput: TCostCenterInputDTO): Int64;
    function Update(APK: Int64; AInput: TCostCenterInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCostCenterInputDTO): Either<String, TCostCenterShowDTO>;
  end;


implementation

end.
