unit uCostCenter.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uCostCenter;

type
  ICostCenterRepository = interface(IBaseRepository)
    ['{ADB69843-F719-4E93-9D3F-E630AD7AC6C3}']
    function Show(AId: Int64): TCostCenter;
  end;

implementation

end.


