unit uUnit.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uUnit;

type
  IUnitRepository = interface(IBaseRepository)
    ['{449D8855-F377-4BCB-842E-93D3F9AFA6FB}']
    function Show(AId: Int64): TUnit;
  end;

implementation

end.


