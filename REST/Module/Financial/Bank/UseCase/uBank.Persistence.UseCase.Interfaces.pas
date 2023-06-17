unit uBank.Persistence.UseCase.Interfaces;

interface

uses
  uBank.Filter.DTO,
  uIndexResult,
  uBank.Show.DTO,
  uBank.Input.DTO,
  uFilter,
  uEither;

type
  IBankPersistenceUseCase = Interface
    ['{CC85D95F-2903-469F-974E-3E51F91CBD4E}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TBankFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TBankShowDTO;
    function StoreAndShow(AInput: TBankInputDTO): Either<String, TBankShowDTO>;
    function Store(AInput: TBankInputDTO): Int64;
    function Update(APK: Int64; AInput: TBankInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TBankInputDTO): Either<String, TBankShowDTO>;
  end;


implementation

end.
