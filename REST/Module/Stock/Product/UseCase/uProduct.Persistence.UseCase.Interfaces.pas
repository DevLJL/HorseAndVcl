unit uProduct.Persistence.UseCase.Interfaces;

interface

uses
  uProduct.Filter.DTO,
  uIndexResult,
  uProduct.Show.DTO,
  uProduct.Input.DTO,
  uFilter,
  uEither;

type
  IProductPersistenceUseCase = Interface
    ['{2E7D1350-6D98-4CCD-9D4F-DDBC9C3DAACA}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TProductFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TProductShowDTO;
    function ShowByEanOrSkuCode(AValue: String): TProductShowDTO;
    function StoreAndShow(AInput: TProductInputDTO): Either<String, TProductShowDTO>;
    function Store(AInput: TProductInputDTO): Int64;
    function Update(APK: Int64; AInput: TProductInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TProductInputDTO): Either<String, TProductShowDTO>;
  end;


implementation

end.
