unit uCostCenter.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uCostCenter;

type
  ICostCenterRepository = interface(IBaseRepository)
    ['{E9951113-2905-4FF6-9DD8-F87FBC435779}']
    function Show(AId: Int64): TCostCenter;
  end;

implementation

end.


