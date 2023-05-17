unit uBankAccount.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uBankAccount;

type
  IBankAccountRepository = interface(IBaseRepository)
    ['{C7929A04-022E-4888-A7AF-48CAA7CDB3E1}']
    function Show(AId: Int64): TBankAccount;
  end;

implementation

end.


