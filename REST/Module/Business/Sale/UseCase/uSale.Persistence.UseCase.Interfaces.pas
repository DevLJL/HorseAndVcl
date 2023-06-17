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
    ['{89DC90C3-26AC-47B4-8974-BF2C5602A2CA}']
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
