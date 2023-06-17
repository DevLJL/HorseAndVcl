unit uBank.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uBank;

type
  IBankRepository = interface(IBaseRepository)
    ['{EC645968-8AD2-4776-BE14-0DF7881D288C}']
    function Show(AId: Int64): TBank;
  end;

implementation

end.


