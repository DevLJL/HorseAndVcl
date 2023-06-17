unit uChartOfAccount.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uChartOfAccount;

type
  IChartOfAccountRepository = interface(IBaseRepository)
    ['{9BB6BB36-A249-4806-8425-C22F5D5558A2}']
    function Show(AId: Int64): TChartOfAccount;
  end;

implementation

end.


