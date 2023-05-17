unit uPayment.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uPaymentTerm;

type
  IPaymentSQLBuilder = interface(IBaseSQLBuilder)
    ['{5B0698AC-CEAB-4528-8D36-C843815ABC34}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;

    // PersonTerm
    function ScriptCreatePaymentTermTable: String;
    function SelectPaymentsTermByPaymentId(APaymentId: Int64): String;
    function DeletePaymentsTermByPaymentId(APaymentId: Int64): String;
    function InsertPaymentTerm(APaymentTerm: TPaymentTerm): String;
  end;

implementation

end.


