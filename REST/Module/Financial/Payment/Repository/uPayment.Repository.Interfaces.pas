unit uPayment.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uPayment,
  uZLMemTable.Interfaces;

type
  IPaymentRepository = interface(IBaseRepository)
    ['{6E84641E-BB4D-4202-ADC1-6DA0F4CFF670}']
    function Show(AId: Int64): TPayment;
    function ListPaymentTerms(APaymentId: Int64): IZLMemTable;
  end;

implementation

end.



