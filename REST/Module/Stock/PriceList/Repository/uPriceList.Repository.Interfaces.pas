unit uPriceList.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uPriceList;

type
  IPriceListRepository = interface(IBaseRepository)
    ['{85B2E00B-C4E9-4D1D-8014-492BAD9F247A}']
    function Show(AId: Int64): TPriceList;
  end;

implementation

end.


