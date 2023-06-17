unit uSize.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uSize;

type
  ISizeRepository = interface(IBaseRepository)
    ['{6195B320-A2FA-4077-9F75-B1D388889B69}']
    function Show(AId: Int64): TSize;
  end;

implementation

end.


