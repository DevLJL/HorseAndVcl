unit uAclUser;

interface

uses
  uBase.Entity,
  uAclRole;

type
  TAclUser = class(TBaseEntity)
  private
    Fname: string;
    Flogin_password: string;
    Fid: Int64;
    Flogin: string;
    Facl_role_id: Int64;
    Fis_superuser: SmallInt;
    Flast_token: string;
    Flast_expiration: TDateTime;
    Fseller_id: Int64;
    Facl_role: TAclRole;
  public
    constructor Create;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property login: string read Flogin write Flogin;
    property login_password: string read Flogin_password write Flogin_password;
    property acl_role_id: Int64 read Facl_role_id write Facl_role_id;
    property is_superuser: SmallInt read Fis_superuser write Fis_superuser;
    property seller_id: Int64 read Fseller_id write Fseller_id;
    property last_token: string read Flast_token write Flast_token;
    property last_expiration: TDateTime read Flast_expiration write Flast_expiration;
    property acl_role: TAclRole read Facl_role write Facl_role;
  end;

implementation

{ TAclUser }

constructor TAclUser.Create;
begin
  inherited Create;
  Facl_role := TAclRole.Create;
end;

destructor TAclUser.Destroy;
begin
  if Assigned(Facl_role) then Facl_role.Free;
  inherited;
end;

end.
