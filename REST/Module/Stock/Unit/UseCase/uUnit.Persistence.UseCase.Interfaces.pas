unit uUnit.Persistence.UseCase.Interfaces;

interface

uses
  uUnit.Filter.DTO,
  uFilter,
  uUnit.Input.DTO,
  uUnit.Show.DTO,
  uEither,
  uIndexResult;

type
  IUnitPersistenceUseCase = Interface
    ['{84F18592-BC05-4AFD-A0BF-D3E2F783B61E}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TUnitFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TUnitShowDTO;
    function StoreAndShow(AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
    function Store(AInput: TUnitInputDTO): Int64;
    function Update(APK: Int64; AInput: TUnitInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TUnitInputDTO): Either<String, TUnitShowDTO>;
  end;

implementation

end.
