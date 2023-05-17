unit uBillPayReceive.Service.Interfaces;

interface

uses
  uBase.Service,
  uBillPayReceive.Filter.DTO,
  uIndexResult,
  uBillPayReceive.Show.DTO,
  uBillPayReceive.Input.DTO,
  uEither;

type
  IBillPayReceiveService = Interface(IBaseService)
    ['{32133C5C-1CE2-4221-8FBC-5C0B01DD0E0C}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBillPayReceiveFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBillPayReceiveShowDTO;
    function StoreAndShow(AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
  End;

implementation

end.
