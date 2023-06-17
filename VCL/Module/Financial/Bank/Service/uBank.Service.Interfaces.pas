unit uBank.Service.Interfaces;

interface

uses
  uBase.Service,
  uBank.Filter.DTO,
  uIndexResult,
  uBank.Show.DTO,
  uBank.Input.DTO,
  uEither;

type
  IBankService = Interface(IBaseService)
    ['{92269375-4D28-47C0-8859-47BA2879C10B}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBankFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBankShowDTO;
    function StoreAndShow(AInput: TBankInputDTO): Either<String, TBankShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBankInputDTO): Either<String, TBankShowDTO>;
  End;

implementation

end.
