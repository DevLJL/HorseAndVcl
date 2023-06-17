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
    ['{ACA70BF9-A68D-4830-B55C-4C6C3FDB934B}']
    function Show(AId: Int64): TSale;
    function DataForReport(ASaleId: Int64): TDataForReportOutput;
    function ChangeStatus(ASaleId: Int64; AStatus: TSaleStatus): Boolean;
  end;

implementation

end.



