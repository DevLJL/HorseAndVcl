unit uBank.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uBank;

type
  IBankRepository = interface(IBaseRepository)
    ['{64BE0B5C-EFBD-4ED8-BACD-28FAB8D0BEFD}']
    function Show(AId: Int64): TBank;
  end;

implementation

end.


