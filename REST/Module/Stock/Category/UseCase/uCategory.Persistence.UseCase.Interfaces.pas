unit uCategory.Persistence.UseCase.Interfaces;

interface

uses
  uCategory.Filter.DTO,
  uIndexResult,
  uCategory.Show.DTO,
  uCategory.Input.DTO,
  uFilter,
  uEither;

type
  ICategoryPersistenceUseCase = Interface
    ['{D3771CA0-140F-41D8-B923-A186B841A5EA}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCategoryFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCategoryShowDTO;
    function StoreAndShow(AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
    function Store(AInput: TCategoryInputDTO): Int64;
    function Update(APK: Int64; AInput: TCategoryInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCategoryInputDTO): Either<String, TCategoryShowDTO>;
  end;


implementation

end.
