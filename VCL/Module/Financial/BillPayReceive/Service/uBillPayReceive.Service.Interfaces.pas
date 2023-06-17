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
    ['{2B48E9D5-D4A1-4542-8D3F-1C8CB5C93426}']
    function Delete(AId: Int64): Boolean;
    function Index(AFilter: TBillPayReceiveFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64): TBillPayReceiveShowDTO;
    function StoreAndShow(AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
    function UpdateAndShow(AId: Int64; AInput: TBillPayReceiveInputDTO): Either<String, TBillPayReceiveShowDTO>;
  End;

implementation

end.
