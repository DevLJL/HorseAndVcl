unit uChartOfAccount.Service.Interfaces;

interface

uses
  uBase.Service,
  uChartOfAccount.Filter.DTO,
  uIndexResult,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.Input.DTO,
  uEither;

type
  IChartOfAccountService = Interface(IBaseService)
    ['{32133C5C-1CE2-4221-8FBC-5C0B01DD0E0C}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TChartOfAccountFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TChartOfAccountShowDTO;
    function StoreAndShow(AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
  End;

implementation

end.
