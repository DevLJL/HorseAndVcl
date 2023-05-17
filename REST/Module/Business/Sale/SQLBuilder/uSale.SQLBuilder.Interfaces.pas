unit uSale.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uSaleItem,
  uSalePayment;

type
  TSQLForReportOutput = record
    Sale: String;
    SaleItems: String;
    SalePayments: String;
  end;

  ISaleSQLBuilder = interface(IBaseSQLBuilder)
    ['{2F837ED8-7CA4-426B-8183-244F210CCC3F}']

    // Sale
    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function SQLForReport(ASaleId: Int64): TSQLForReportOutput;

    // SaleItem
    function ScriptCreateSaleItemTable: String;
    function SelectSaleItemsBySaleId(ASaleId: Int64): String;
    function DeleteSaleItemsBySaleId(ASaleId: Int64): String;
    function InsertSaleItem(ASaleItem: TSaleItem): String;

    // SalePayment
    function ScriptCreateSalePaymentTable: String;
    function SelectSalePaymentsBySaleId(ASaleId: Int64): String;
    function DeleteSalePaymentsBySaleId(ASaleId: Int64): String;
    function InsertSalePayment(ASalePayment: TSalePayment): String;
  end;

implementation

end.


