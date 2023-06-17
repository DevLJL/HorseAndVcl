unit uUnit.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uUnit;

type
  IUnitRepository = interface(IBaseRepository)
    ['{CE543FFF-185B-4B33-AC5F-A46A4A8E955F}']
    function Show(AId: Int64): TUnit;
  end;

implementation

end.


