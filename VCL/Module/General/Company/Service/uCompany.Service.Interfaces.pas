unit uCompany.Service.Interfaces;

interface

uses
  uBase.Service,
  uCompany.Filter.DTO,
  uIndexResult,
  uCompany.Show.DTO,
  uCompany.Input.DTO,
  uEither;

type
  ICompanyService = Interface(IBaseService)
    ['{F36BC81A-5920-413D-B883-7714BD7A0E11}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TCompanyFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TCompanyShowDTO;
    function StoreAndShow(AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
  End;

implementation

end.
