unit uBrand.Persistence.UseCase.Interfaces;

interface

uses
  uBrand.Filter.DTO,
  uIndexResult,
  uBrand.Show.DTO,
  uBrand.Input.DTO,
  uFilter,
  uEither;

type
  IBrandPersistenceUseCase = Interface
    ['{05187FB2-4FF7-4D56-BF9F-D3DD8B3AF6AF}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TBrandFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TBrandShowDTO;
    function StoreAndShow(AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
    function Store(AInput: TBrandInputDTO): Int64;
    function Update(APK: Int64; AInput: TBrandInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TBrandInputDTO): Either<String, TBrandShowDTO>;
  end;

implementation

end.
