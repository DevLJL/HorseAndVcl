unit uBankAccount.Service.Interfaces;

interface

uses
  uBase.Service,
  uBankAccount.Filter.DTO,
  uIndexResult,
  uBankAccount.Show.DTO,
  uBankAccount.Input.DTO,
  uEither;

type
  IBankAccountService = Interface(IBaseService)
    ['{32133C5C-1CE2-4221-8FBC-5C0B01DD0E0C}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBankAccountFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBankAccountShowDTO;
    function StoreAndShow(AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
  End;

implementation

end.
