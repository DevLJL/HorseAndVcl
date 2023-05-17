unit uChartOfAccount.Persistence.UseCase.Interfaces;

interface

uses
  uChartOfAccount.Filter.DTO,
  uIndexResult,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.Input.DTO,
  uFilter,
  uEither;

type
  IChartOfAccountPersistenceUseCase = Interface
    ['{3A7916A8-3B15-468D-961E-FF4221FDC9D2}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TChartOfAccountFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TChartOfAccountShowDTO;
    function StoreAndShow(AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
    function Store(AInput: TChartOfAccountInputDTO): Int64;
    function Update(APK: Int64; AInput: TChartOfAccountInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TChartOfAccountInputDTO): Either<String, TChartOfAccountShowDTO>;
  end;


implementation

end.
