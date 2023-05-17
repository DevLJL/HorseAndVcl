unit uCompany.Persistence.UseCase.Interfaces;

interface

uses
  uCompany.Filter.DTO,
  uIndexResult,
  uCompany.Show.DTO,
  uCompany.Input.DTO,
  uFilter,
  uEither;

type
  ICompanyPersistenceUseCase = Interface
    ['{62CE57C0-02F8-4D3C-BE3C-281FF5D108A3}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TCompanyFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TCompanyShowDTO;
    function StoreAndShow(AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
    function Store(AInput: TCompanyInputDTO): Int64;
    function Update(APK: Int64; AInput: TCompanyInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TCompanyInputDTO): Either<String, TCompanyShowDTO>;
  end;


implementation

end.
