unit uPriceList.Persistence.UseCase.Interfaces;

interface

uses
  uPriceList.Filter.DTO,
  uIndexResult,
  uPriceList.Show.DTO,
  uPriceList.Input.DTO,
  uFilter,
  uEither;

type
  IPriceListPersistenceUseCase = Interface
    ['{8683B4C8-2166-42E9-93E6-0E19073CD73B}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TPriceListFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TPriceListShowDTO;
    function StoreAndShow(AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
    function Store(AInput: TPriceListInputDTO): Int64;
    function Update(APK: Int64; AInput: TPriceListInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TPriceListInputDTO): Either<String, TPriceListShowDTO>;
  end;

implementation

end.
