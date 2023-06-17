unit uTenant.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uTenant;

type
  ITenantRepository = interface(IBaseRepository)
    ['{B806766C-C6A8-4B78-9B1A-8F5DFAE0D761}']
    function Show(AId: Int64): TTenant;
  end;

implementation

end.


