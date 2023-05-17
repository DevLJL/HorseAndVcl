unit uAclUser.Auth.UseCase;

interface

uses
  uAclUser.Repository.Interfaces,
  uAclUser.Login.DTO,
  uAclUser.Show.DTO;

type
  IAclUserAuthUseCase = Interface
    ['{0F05AFCC-2EB6-4BEE-AF42-BBE7D9A61739}']
    function Login(AInput: TAclUserLoginDTO): TAclUserShowDTO;
  end;

  TAclUserAuthUseCase = class(TInterfacedObject, IAclUserAuthUseCase)
  private
    FRepository: IAclUserRepository;
    constructor Create(ARepository: IAclUserRepository);
  public
    class function Make(ARepository: IAclUserRepository): IAclUserAuthUseCase;
    function Login(AInput: TAclUserLoginDTO): TAclUserShowDTO;
  end;

implementation

{ TAclUserAuthUseCase }

uses
  JOSE.Core.Builder,
  JOSE.Core.JWT,
  uMyClaims,
  uAclUser,
  uSmartPointer,
  uAclUser.Filter,
  uFilter.Types,
  uHlp,
  uAppRest.Types,
  System.SysUtils,
  uTrans,
  System.DateUtils,
  uAclUser.Mapper;

constructor TAclUserAuthUseCase.Create(ARepository: IAclUserRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TAclUserAuthUseCase.Login(AInput: TAclUserLoginDTO): TAclUserShowDTO;
const
  l10_MIN_MARGIN_OF_ERROR = -10;
begin
  // Procurar por usuário
  const LIndexResult = FRepository.Index(
    TAclUserFilter.Make
      .Where (TParentheses.None, 'acl_user.login',          TCondition.Equal, AInput.login)
      .&And  (TParentheses.None, 'acl_user.login_password', TCondition.Equal, Encrypt(ENCRYPTATION_KEY, AInput.login_password))
  );
  if LIndexResult.Data.IsEmpty then
    raise Exception.Create(Trans.IncorrectCredentials);

  // Se existir token ativo, retorna o mesmo
  const AclUser: SH<TAclUser> = FRepository.Show(LIndexResult.Data.Fields[0].AsLargeInt);
  const LAux = AclUser.Value;
  if not AclUser.Value.last_token.Trim.IsEmpty then
  Begin
    const TokenIsExpired = (IncMinute(AclUser.Value.last_expiration, l10_MIN_MARGIN_OF_ERROR) < Now);
    if not TokenIsExpired then
    begin
      Result := TAclUserMapper.EntityToShow(AclUser);
      Exit;
    end;
  end;

  // Gerar novo token
  const lJWT: SH<TJWT> = TJWT.Create(TMyClaims);
  const lClaims = TMyClaims(lJWT.Value.Claims);
  lClaims.Id          := AclUser.Value.id.ToString;
  lClaims.Name        := AclUser.Value.name;
  lClaims.Login       := AclUser.Value.login;
  lClaims.AclRoleId   := AclUser.Value.acl_role_id.ToString;
  lClaims.IsSuperuser := AclUser.Value.flg_superuser.ToString;
  lClaims.Expiration  := IncHour(Now, 2);
  const lToken = TJOSE.SHA256CompactToken(JWT_KEY, lJWT);

  // Atualizar usuário com os dados do token
  AclUser.Value.last_token      := lToken;
  AclUser.Value.last_expiration := lClaims.Expiration;
  FRepository.Update(AclUser.Value.id, AclUser);

  // Retornar Usuário com Token
  Result := TAclUserMapper.EntityToShow(AclUser);
end;

class function TAclUserAuthUseCase.Make(ARepository: IAclUserRepository): IAclUserAuthUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
