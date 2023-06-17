unit uAclUser.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uAclUser;

type
  IAclUserRepository = interface(IBaseRepository)
    ['{4C2B0991-FB8D-482E-9E0D-FF5D25FFD7B8}']
    function Show(AId: Int64): TAclUser;
  end;

implementation

end.


