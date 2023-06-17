unit uBankAccount.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uBankAccount;

type
  IBankAccountRepository = interface(IBaseRepository)
    ['{A234F254-364F-4C4D-9CD1-3EE5C8501278}']
    function Show(AId: Int64): TBankAccount;
  end;

implementation

end.


