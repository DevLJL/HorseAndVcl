unit uUserLogged;

interface

uses
  SysUtils,
  uAclUser,
  uGlobalConfig.Show.DTO,
  uTenant.Show.DTO;

type
  TUserLogged = class
  private
    FUser: TAclUser;
    FTenant: TTenantShowDTO;
    FGlobalConfig: TGlobalConfigShowDTO;
  public
    constructor Create;
    destructor Destroy; override;

    // Usuário Logado
    function Current: TAclUser; overload;
    function Current(AUser: TAclUser; ALoadTenantAndGlobalConfig: Boolean = True): TUserLogged; overload;

    // Dados da Empresa
    function Tenant: TTenantShowDTO; overload;
    function Tenant(ATenant: TTenantShowDTO): TUserLogged; overload;

    // Configuração Global
    function GlobalConfig: TGlobalConfigShowDTO; overload;
    function GlobalConfig(AGlobalConfig: TGlobalConfigShowDTO): TUserLogged; overload;
  end;

var
  UserLogged: TUserLogged;

implementation

uses
  System.Variants,
  Data.DB,
  uHlp,
  uTenant.Service,
  uGlobalConfig.Service;

{ TUserLogged }

function TUserLogged.Current: TAclUser;
begin
  Result := FUser;
end;

function TUserLogged.Current(AUser: TAclUser; ALoadTenantAndGlobalConfig: Boolean): TUserLogged;
begin
  Result := Self;
  if Assigned(FUser) then
    FreeAndNil(FUser);
  FUser := AUser;

  // Carregar dados da Empresa e Configuração Global
  if ALoadTenantAndGlobalConfig then
  begin
    Self.Tenant       (TTenantService.Make.Show);
    Self.GlobalConfig (TGlobalConfigService.Make.Show);
  end;
end;

Destructor TUserLogged.Destroy;
begin
  if Assigned(FUser)         then FUser.Free;
  if Assigned(FTenant)       then FTenant.Free;
  if Assigned(FGlobalConfig) then FGlobalConfig.Free;
  inherited;
end;

function TUserLogged.GlobalConfig(AGlobalConfig: TGlobalConfigShowDTO): TUserLogged;
begin
  Result := Self;
  if Assigned(FGlobalConfig) then
    FreeAndNil(FGlobalConfig);

  FGlobalConfig := AGlobalConfig;
end;

function TUserLogged.Tenant(ATenant: TTenantShowDTO): TUserLogged;
begin
  Result := Self;
  if Assigned(FTenant) then
    FreeAndNil(FTenant);

  FTenant := ATenant;
end;

function TUserLogged.Tenant: TTenantShowDTO;
begin
  Result := FTenant;
end;

function TUserLogged.GlobalConfig: TGlobalConfigShowDTO;
begin
  Result := FGlobalConfig;
end;

constructor TUserLogged.Create;
begin
  inherited Create;
end;


initialization
  UserLogged := TUserLogged.Create;
finalization
  FreeAndNil(UserLogged);

end.

