unit uAclUser.Login.DTO;

interface

uses
  uBase.DTO,
  Horse.Request,
  GBSwagger.Model.Attributes,
  XSuperObject,
  uSmartPointer,
  uAppRest.Types;

type
  TAclUserLoginDTO = class(TBaseDTO)
  private
    Flogin_password: string;
    Flogin: string;
  public
    class function FromReq(AReq: THorseRequest): TAclUserLoginDTO;

    [SwagString(100)]
    [SwagProp('login', 'Login', true)]
    property login: string read Flogin write Flogin;

    [SwagString(100)]
    [SwagProp('login_password', 'Senha', true)]
    property login_password: string read Flogin_password write Flogin_password;
  end;

implementation

uses
  System.SysUtils;

{ TAclUserLoginDTO }

class function TAclUserLoginDTO.FromReq(AReq: THorseRequest): TAclUserLoginDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result := TAclUserLoginDTO.FromJSON(AReq.Body);
end;

end.

