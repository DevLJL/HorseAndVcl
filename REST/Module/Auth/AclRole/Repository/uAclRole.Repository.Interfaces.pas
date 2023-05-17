unit uAclRole.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uAclRole;

type
  IAclRoleRepository = interface(IBaseRepository)
    ['{DCD0E82B-05E1-444C-9EE0-0FF6826AD51B}']
    function Show(AId: Int64): TAclRole;
  end;

implementation

end.


