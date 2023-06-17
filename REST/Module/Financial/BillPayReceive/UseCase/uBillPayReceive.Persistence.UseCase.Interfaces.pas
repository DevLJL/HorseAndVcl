unit uBillPayReceive.Persistence.UseCase.Interfaces;

interface

uses
  uBillPayReceive.Filter.DTO,
  uIndexResult,
  uBillPayReceive.Show.DTO,
  uBillPayReceive.Input.DTO,
  uFilter,
  uEither;

type
  IBillPayReceivePersistenceUseCase = Interface
    ['{1B6FD610-907B-490B-9B40-7D86FA71392B}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TBillPayReceiveFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TBillPayReceiveShowDTO;
    function StoreAndShow(AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
    function Store(AInput: TBillPayReceiveInputDTO): Int64;
    function Update(APK: Int64; AInput: TBillPayReceiveInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
  end;

implementation

end.
