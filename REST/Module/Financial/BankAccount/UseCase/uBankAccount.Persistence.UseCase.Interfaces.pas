unit uBankAccount.Persistence.UseCase.Interfaces;

interface

uses
  uBankAccount.Filter.DTO,
  uIndexResult,
  uBankAccount.Show.DTO,
  uBankAccount.Input.DTO,
  uFilter,
  uEither;

type
  IBankAccountPersistenceUseCase = Interface
    ['{9BC7BAD6-95B3-4050-950D-1EDE72D76409}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TBankAccountFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TBankAccountShowDTO;
    function StoreAndShow(AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
    function Store(AInput: TBankAccountInputDTO): Int64;
    function Update(APK: Int64; AInput: TBankAccountInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
  end;


implementation

end.
