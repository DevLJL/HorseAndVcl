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
    ['{EAF1FEEA-F9DB-411C-9F3F-60CEAAA32230}']

    // SaleCheck
    function NextSaleCheckId: String;

    // Sale
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function SQLForReport(ASaleId: Int64): TSQLForReportOutput;

    // SaleItem
    function SelectSaleItemsBySaleId(ASaleId: Int64): String;
    function DeleteSaleItemsBySaleId(ASaleId: Int64): String;
    function InsertSaleItem(ASaleItem: TSaleItem): String;

    // SalePayment
    function SelectSalePaymentsBySaleId(ASaleId: Int64): String;
    function DeleteSalePaymentsBySaleId(ASaleId: Int64): String;
    function InsertSalePayment(ASalePayment: TSalePayment): String;
  end;

implementation

end.


