unit uSize.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uSize;

type
  ISizeRepository = interface(IBaseRepository)
    ['{D5C6C274-8D0F-4764-89FF-28890B2C0855}']
    function Show(AId: Int64): TSize;
  end;

implementation

end.


