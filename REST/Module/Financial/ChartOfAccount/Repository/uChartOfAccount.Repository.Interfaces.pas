unit uChartOfAccount.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uChartOfAccount;

type
  IChartOfAccountRepository = interface(IBaseRepository)
    ['{72E61A9C-858E-4A33-B39C-C7C1CED7EB9E}']
    function Show(AId: Int64): TChartOfAccount;
  end;

implementation

end.


