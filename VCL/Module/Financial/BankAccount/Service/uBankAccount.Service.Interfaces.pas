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
    ['{0AB178F1-7646-4AF4-8CE7-ABF8474798E0}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBankAccountFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBankAccountShowDTO;
    function StoreAndShow(AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBankAccountInputDTO): Either<String, TBankAccountShowDTO>;
  End;

implementation

end.
