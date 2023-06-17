unit uSize.Persistence.UseCase.Interfaces;

interface

uses
  uSize.Filter.DTO,
  uIndexResult,
  uSize.Show.DTO,
  uSize.Input.DTO,
  uFilter,
  uEither;

type
  ISizePersistenceUseCase = Interface
    ['{7C8A650C-CC9D-4DE3-A5BD-5A269322669C}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TSizeFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TSizeShowDTO;
    function StoreAndShow(AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
    function Store(AInput: TSizeInputDTO): Int64;
    function Update(APK: Int64; AInput: TSizeInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TSizeInputDTO): Either<String, TSizeShowDTO>;
  end;


implementation

end.
