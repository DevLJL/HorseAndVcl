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
    ['{32133C5C-1CE2-4221-8FBC-5C0B01DD0E0C}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBankFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBankShowDTO;
    function StoreAndShow(AInput: TBankInputDTO): Either<String, TBankShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBankInputDTO): Either<String, TBankShowDTO>;
  End;

implementation

end.
