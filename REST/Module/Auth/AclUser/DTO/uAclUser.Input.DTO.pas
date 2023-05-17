unit uAclUser.Input.DTO;

interface

uses
  uBase.DTO,
  Horse.Request,
  GBSwagger.Model.Attributes,
  XSuperObject,
  uSmartPointer,
  uAppRest.Types;

type
  TAclUserInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Flogin_password: String;
    Fseller_id: Int64;
    Flogin: String;
    Facl_role_id: Int64;
    Fflg_superuser: SmallInt;
  public
    class function FromReq(AReq: THorseRequest): TAclUserInputDTO;

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagString(100)]
    [SwagProp('login', 'Login', true)]
    property login: String read Flogin write Flogin;

    [SwagString(100)]
    [SwagProp('login_password', 'Senha', true)]
    property login_password: String read Flogin_password write Flogin_password;

    [SwagNumber]
    [SwagProp('acl_role_id', 'ID do Perfil', true)]
    property acl_role_id: Int64 read Facl_role_id write Facl_role_id;

    [SwagNumber]
    [SwagProp('flg_superuser', 'Super Usuário', false)]
    property flg_superuser: SmallInt read Fflg_superuser write Fflg_superuser;

    [SwagNumber]
    [SwagProp('seller_id', 'Vendedor Padrão', false)]
    property seller_id: Int64 read Fseller_id write Fseller_id;
  end;

implementation

uses
  System.SysUtils;

{ TAclUserInputDTO }

class function TAclUserInputDTO.FromReq(AReq: THorseRequest): TAclUserInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result := TAclUserInputDTO.FromJSON(AReq.Body);
end;

end.

