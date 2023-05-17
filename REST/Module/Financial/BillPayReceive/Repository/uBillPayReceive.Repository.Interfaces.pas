unit uBillPayReceive.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uBillPayReceive;

type
  IBillPayReceiveRepository = interface(IBaseRepository)
    ['{650A2A0F-BCFD-4173-9E34-0E07529758F9}']
    function Show(AId: Int64): TBillPayReceive;
    function DeleteBySaleId(ASaleId: Int64): Boolean;
  end;

implementation

end.



