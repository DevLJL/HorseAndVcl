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
    ['{B65E72C8-0831-4BA8-B65C-6E63F2ED4B75}']
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
