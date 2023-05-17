unit uSale.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uSale,
  uZLMemTable.Interfaces,
  uSale.Types;

type
  TDataForReportOutput = record
    Sale: IZLMemTable;
    SaleItems: IZLMemTable;
    SalePayments: IZLMemTable;
  end;

  ISaleRepository = interface(IBaseRepository)
    ['{8F4C18F5-1A37-4FE4-A89A-D95854B41CB7}']
    function Show(AId: Int64): TSale;
    function DataForReport(ASaleId: Int64): TDataForReportOutput;
    function ChangeStatus(ASaleId: Int64; AStatus: TSaleStatus): Boolean;
  end;

implementation

end.



