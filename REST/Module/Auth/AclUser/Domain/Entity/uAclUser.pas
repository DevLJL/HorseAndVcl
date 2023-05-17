unit uAclUser;

interface

uses
  uAppRest.Types,
  uAclRole,
  uBase.Entity,
  System.Generics.Collections;

type
  TAclUser = class(TBaseEntity)
  private
    Fname: string;
    Flogin_password: string;
    Fid: Int64;
    Flogin: string;
    Facl_role_id: Int64;
    Fseller_id: Int64;
    Fflg_superuser: SmallInt;
    Flast_token: String;
    Flast_expiration: TDateTime;

    // OneToOne
    Facl_role: TAclRole;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property login: string read Flogin write Flogin;
    property login_password: string read Flogin_password write Flogin_password;
    property acl_role_id: Int64 read Facl_role_id write Facl_role_id;
    property seller_id: Int64 read Fseller_id write Fseller_id;
    property flg_superuser: SmallInt read Fflg_superuser write Fflg_superuser;
    property last_token: String read Flast_token write Flast_token;
    property last_expiration: TDateTime read Flast_expiration write Flast_expiration;

    // OneToOne
    property acl_role: TAclRole read Facl_role write Facl_role;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uEntityValidation.Exception,
  uTrans;

{ TAclUser }

constructor TAclUser.Create;
begin
  Facl_role := TAclRole.Create;
end;

destructor TAclUser.Destroy;
begin
  if Assigned(Facl_role) then Facl_role.Free;
  inherited;
end;

function TAclUser.Validate: String;
var
  LIsInserting: Boolean;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;

  if Flogin.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Login') + #13;

  if (Facl_role_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Perfil do Usuário') + #13;

  if (Flogin_password.Trim.IsEmpty) then
    Result := Result + Trans.FieldWasNotInformed('Senha') + #13;
end;

end.
