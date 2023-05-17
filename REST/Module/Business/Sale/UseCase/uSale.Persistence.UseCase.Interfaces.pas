unit uSale.Persistence.UseCase.Interfaces;

interface

uses
  uSale.Filter.DTO,
  uIndexResult,
  uSale.Show.DTO,
  uSale.Input.DTO,
  uFilter,
  uEither;

type
  ISalePersistenceUseCase = Interface
    ['{39E651D8-535C-47A9-80BF-689276680D6A}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TSaleFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TSaleShowDTO;
    function StoreAndShow(AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
    function Store(AInput: TSaleInputDTO): Int64;
    function Update(APK: Int64; AInput: TSaleInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TSaleInputDTO): Either<String, TSaleShowDTO>;
  end;


implementation

end.
