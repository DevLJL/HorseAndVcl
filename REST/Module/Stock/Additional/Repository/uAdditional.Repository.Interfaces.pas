unit uAdditional.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uAdditional;

type
  IAdditionalRepository = interface(IBaseRepository)
    ['{8FA213E7-5C7C-4915-8752-83610595A398}']
    function Show(AId: Int64): TAdditional;
  end;

implementation

end.


