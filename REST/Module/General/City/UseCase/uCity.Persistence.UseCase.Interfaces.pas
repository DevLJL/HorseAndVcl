unit uCity.Persistence.UseCase.Interfaces;

interface

uses
  uCity.Filter.DTO,
  uIndexResult,
  uCity.Show.DTO,
  uCity.Input.DTO,
  uFilter,
  uEither;

type
  ICityPersistenceUseCase = Interface
    ['{17BBD409-6EFB-4DCE-9572-59597AAEDA14}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCityFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCityShowDTO;
    function StoreAndShow(AInput: TCityInputDTO): Either<String, TCityShowDTO>;
    function Store(AInput: TCityInputDTO): Int64;
    function Update(APK: Int64; AInput: TCityInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCityInputDTO): Either<String, TCityShowDTO>;
  end;

implementation

end.
