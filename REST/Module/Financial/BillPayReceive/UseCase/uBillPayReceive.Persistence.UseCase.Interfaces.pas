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
    ['{6298D5C9-A26A-4436-A58B-C4FB4C510121}']
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
