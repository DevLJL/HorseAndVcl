unit uBillPayReceive.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uBillPayReceive;

type
  IBillPayReceiveRepository = interface(IBaseRepository)
    ['{5312B916-959F-4411-AD42-94C697C100D7}']
    function Show(AId: Int64): TBillPayReceive;
    function DeleteBySaleId(ASaleId: Int64): Boolean;
  end;

implementation

end.



