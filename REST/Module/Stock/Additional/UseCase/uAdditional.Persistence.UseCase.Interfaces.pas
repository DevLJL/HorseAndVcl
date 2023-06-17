unit uAdditional.Persistence.UseCase.Interfaces;

interface

uses
  uAdditional.Filter.DTO,
  uIndexResult,
  uAdditional.Show.DTO,
  uAdditional.Input.DTO,
  uFilter,
  uEither;

type
  IAdditionalPersistenceUseCase = Interface
    ['{B8DA33A1-2C65-4F28-A1DC-DDBEBCF84899}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TAdditionalFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TAdditionalShowDTO;
    function StoreAndShow(AInput: TAdditionalInputDTO): Either<String, TAdditionalShowDTO>;
    function Store(AInput: TAdditionalInputDTO): Int64;
    function Update(APK: Int64; AInput: TAdditionalInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TAdditionalInputDTO): Either<String, TAdditionalShowDTO>;
  end;

implementation

end.
