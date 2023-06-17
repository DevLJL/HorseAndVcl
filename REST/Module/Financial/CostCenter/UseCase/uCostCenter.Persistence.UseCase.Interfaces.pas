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
    ['{26A844BB-BEB9-475F-9966-432223F3D153}']
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
