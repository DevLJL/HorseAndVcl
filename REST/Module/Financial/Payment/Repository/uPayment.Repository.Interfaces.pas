unit uPayment.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uPayment,
  uZLMemTable.Interfaces;

type
  IPaymentRepository = interface(IBaseRepository)
    ['{476166E8-C700-4643-A698-F0E478D4BABA}']
    function Show(AId: Int64): TPayment;
    function ListPaymentTerms(APaymentId: Int64): IZLMemTable;
  end;

implementation

end.



