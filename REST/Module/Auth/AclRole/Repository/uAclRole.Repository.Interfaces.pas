unit uAclRole.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uAclRole;

type
  IAclRoleRepository = interface(IBaseRepository)
    ['{7B97B511-7C6F-4A95-9056-D29B2D4D34C9}']
    function Show(AId: Int64): TAclRole;
  end;

implementation

end.


