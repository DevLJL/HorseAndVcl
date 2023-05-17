unit uAclUser.Login.UseCase;

interface

uses
  uAclUser,
  uAclUser.Repository.Interfaces;

type
  IAclUserLoginUseCase = Interface
    ['{F43E4E7F-1782-49BA-AFE6-254DDAFB697B}']
    function Execute(ALogin, ALoginPassword: String): TAclUser;
  End;

  TAclUserLoginUseCase = class(TInterfacedObject, IAclUserLoginUseCase)
  private
    FRepository: IAclUserRepository;
    constructor Create(ARepository: IAclUserRepository);
  public
    class function Make(ARepository: IAclUserRepository): IAclUserLoginUseCase;
    function Execute(ALogin, ALoginPassword: String): TAclUser;
  end;

implementation

uses
  uAclUser.Filter,
  uFilter.Types,
  uAppRest.Types,
  uHlp;

{ TAclUserLoginUseCase }

constructor TAclUserLoginUseCase.Create(ARepository: IAclUserRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TAclUserLoginUseCase.Execute(ALogin, ALoginPassword: String): TAclUser;
begin
  Result := nil;
  With FRepository.Index(
    TAclUserFilter.Make
      .Where(TParentheses.None, 'acl_user.login',          TCondition.Equal, ALogin)
      .&And(TParentheses.None,  'acl_user.login_password', TCondition.Equal, Encrypt(ENCRYPTATION_KEY, ALoginPassword))
  ) do
  begin
    if Data.IsEmpty then
      Exit;

    Result := FRepository.Show(Data.FieldByName('id').AsLargeInt);
  end;
end;

class function TAclUserLoginUseCase.Make(ARepository: IAclUserRepository): IAclUserLoginUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
