unit uPayment.Persistence.UseCase.Interfaces;

interface

uses
  uPayment.Filter.DTO,
  uIndexResult,
  uPayment.Show.DTO,
  uPayment.Input.DTO,
  uFilter,
  uEither;

type
  IPaymentPersistenceUseCase = Interface
    ['{1A86DD7E-E966-4D5F-BEC3-4284D220E0C3}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TPaymentFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TPaymentShowDTO;
    function StoreAndShow(AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
    function Store(AInput: TPaymentInputDTO): Int64;
    function Update(APK: Int64; AInput: TPaymentInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TPaymentInputDTO): Either<String, TPaymentShowDTO>;
  end;


implementation

end.
