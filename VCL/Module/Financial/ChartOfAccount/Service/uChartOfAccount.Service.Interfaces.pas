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
    ['{D3F0B28D-E7D8-4159-B280-E4B9AB7A02EC}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TChartOfAccountFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TChartOfAccountShowDTO;
    function StoreAndShow(AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
  End;

implementation

end.
