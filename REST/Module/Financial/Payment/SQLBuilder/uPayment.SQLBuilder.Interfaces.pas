unit uPayment.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uPaymentTerm;

type
  IPaymentSQLBuilder = interface(IBaseSQLBuilder)
    ['{0E7ABDE1-2998-4537-9F57-36BDCFEC9D53}']

    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;

    // PersonTerm
    function SelectPaymentsTermByPaymentId(APaymentId: Int64): String;
    function DeletePaymentsTermByPaymentId(APaymentId: Int64): String;
    function InsertPaymentTerm(APaymentTerm: TPaymentTerm): String;
  end;

implementation

end.


