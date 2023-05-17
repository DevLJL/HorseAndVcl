unit uRouteApi.Auth;

interface

uses
  Horse;

type
  TRouteApiAuth = class
  public
    class procedure Registry;
  end;

implementation

uses
  Horse.GBSwagger.Register,
  uAclRole.Controller,
  uAclUser.Controller;

{ TRouteApiAuth }

class procedure TRouteApiAuth.Registry;
begin
  With THorseGBSwaggerRegister do
  begin
    RegisterPath(TAclRoleController);
    RegisterPath(TAclUserController);
  end;
end;

end.

