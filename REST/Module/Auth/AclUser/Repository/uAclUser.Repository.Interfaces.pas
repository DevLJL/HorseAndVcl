unit uAclUser.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uAclUser;

type
  IAclUserRepository = interface(IBaseRepository)
    ['{2F49C0ED-1D79-4C6A-AA40-AA7B807F2CC0}']
    function Show(AId: Int64): TAclUser;
  end;

implementation

end.


