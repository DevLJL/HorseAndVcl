unit uLoggedInUser;

interface

uses
  SysUtils,
  uAclUser,
  uZLMemTable.Interfaces,
  uAclRole.MTB;
  //uCompany,
  //uPosPrinter,
  //uPerson;

type
  TLoggedInUser = class
  private
    FUser: TAclUser;
    FAclRoleMTB: IAclRoleMTB;
    FAppParam: IZLMemTable;
    //FCompany: TCompany;
    //FPosPrinterDefault: TPosPrinter;
    //FSellerDefault: TPerson;
  public
    constructor Create;
    destructor Destroy; override;

    function Current: TAclUser; overload;
    function Current(AUser: TAclUser): TLoggedInUser; overload;
    function CurrentHasPermissionTo(AActionName: String; ADefault: Boolean = False): Boolean;
    function CurrentRefresh: TLoggedInUser;
    function GetParam(AActionName: String): String;
    function GetIntParam(AActionName: String; ADefault: Integer = 0): Integer;
    function GetBoolParam(AActionName: String; ADefault: Boolean = False): Boolean;
    function GetStrParam(AActionName: String; ADefault: String = ''): String;
//    function Company(ARefresh: Boolean = False): TCompany;
//    function SellerDefault(ARefresh: Boolean = False): TPerson;
//    function PosPrinterDefault(ARefresh: Boolean = False): TPosPrinter;
    function CurrentStationId: Int64; overload;
    function CurrentStationId(AValue: Int64): TLoggedInUser; overload;
  end;

var
  LoggedInUser: TLoggedInUser;

implementation

uses
  uAppParam,
  uMemTable.Factory,
  uController.Factory,
  System.Variants,
  Data.DB,
  uHlp,
  uEnv.Rest,
  XSuperObject,
  XSuperJSON,
  uRepository.Factory,
  uAppRest.Types;

{ TLoggedInUser }

function TLoggedInUser.Current: TAclUser;
begin
  Result := FUser;
end;

function TLoggedInUser.Current(AUser: TAclUser): TLoggedInUser;
begin
  Result := Self;
  if Assigned(FUser) then
    FreeAndNil(FUser);

  FUser       := AUser;
  FAppParam   := TControllerFactory.AppParam.Index(nil).Data;
  FAclRoleMTB := TControllerFactory.AclRole.Show(FUser.acl_role_id);
end;

function TLoggedInUser.CurrentHasPermissionTo(AActionName: String; ADefault: Boolean): Boolean;
var
  lValue: String;
begin
  // Super usuário
  if IntBool(FUser.flg_superuser) then
  begin
    Result := True;
    Exit;
  end;

  // Localizar parâmetro
  lValue := GetParam(AActionName);
  if lValue.Trim.IsEmpty then
  Begin
    Result := ADefault;
    Exit;
  End;

  Result := IntBool(StrInt(lValue));
end;

function TLoggedInUser.CurrentRefresh: TLoggedInUser;
var
  LAclUser: TAclUser;
begin
  LAclUser := TControllerFactory.AclUser.Login(FUser.login, FUser.login_password);
  Current(LAclUser);
end;

function TLoggedInUser.CurrentStationId(AValue: Int64): TLoggedInUser;
begin
  Result := Self;
  ENV_REST.StationId := AValue;
end;

function TLoggedInUser.CurrentStationId: Int64;
begin
  Result := ENV_REST.StationId;
end;

destructor TLoggedInUser.Destroy;
begin
  if Assigned(FUser)              then FUser.Free;
  if Assigned(FCompany)           then FCompany.Free;
  if Assigned(FPosPrinterDefault) then FPosPrinterDefault.Free;
  if Assigned(FSellerDefault)     then FSellerDefault.Free;
  inherited;
end;

function TLoggedInUser.GetBoolParam(AActionName: String; ADefault: Boolean): Boolean;
var
  lValue: String;
begin
  // Localizar parâmetro
  lValue := GetParam(AActionName);
  if lValue.Trim.IsEmpty then
  begin
    Result := ADefault;
    Exit;
  end;

  Result := IntBool(StrInt(lValue));
end;

function TLoggedInUser.GetIntParam(AActionName: String; ADefault: Integer): Integer;
var
  lValue: String;
begin
  // Localizar parâmetro
  lValue := GetParam(AActionName);
  if lValue.Trim.IsEmpty then
  begin
    Result := ADefault;
    Exit;
  end;

  Result := StrInt(lValue);
end;

function TLoggedInUser.GetParam(AActionName: String): String;
var
  lAppParam: TAppParam;
  lFound: Boolean;
begin
  Result      := EmptyStr;
  AActionName := AActionName.Trim.ToLower;

  // Tentar localizar parâmetro por perfil de usuário
  lFound := FAclRoleMTB.AclRoleParamList.First.Locate('action_name;acl_role_id', VarArrayOf([AActionName, FUser.acl_role_id]));
  if lFound then
  begin
    Result := FAclRoleMTB.AclRoleParamList.FieldByName('value').AsString;
    Exit;
  end;

  // Tentar localizar por parâmetro local (estacao atual)
  lFound := FAppParam.First.Locate('action_name;station_id', VarArrayOf([AActionName, ENV_REST.StationId]));
  if lFound then
  begin
    Result := FAppParam.FieldByName('value').AsString;
    Exit;
  end;


  // Tentar localizar por parâmetro global
  lFound := FAppParam.First.Locate('action_name;station_id', VarArrayOf([AActionName, Null]));
  if lFound then
  begin
    Result := FAppParam.FieldByName('value').AsString;
    Exit;
  end;
end;

function TLoggedInUser.GetStrParam(AActionName, ADefault: String): String;
var
  lValue: String;
begin
  // Localizar parâmetro
  lValue := GetParam(AActionName);
  if lValue.Trim.IsEmpty then
  begin
    Result := ADefault;
    Exit;
  end;

  Result := lValue;
end;

function TLoggedInUser.PosPrinterDefault(ARefresh: Boolean): TPosPrinter;
begin
  if ARefresh and Assigned(FPosPrinterDefault) then
    FreeAndNil(FPosPrinterDefault);

  if not Assigned(FPosPrinterDefault) then
    FPosPrinterDefault := TRepositoryFactory.Make(TestConnection.Conn).PosPrinter.Show(GetIntParam(GERAL_POS_PRINTER_ID));

  Result := FPosPrinterDefault;
end;

function TLoggedInUser.SellerDefault(ARefresh: Boolean): TPerson;
begin
  Result := nil;
  if (FUser.seller_id <= 0) then
    Exit;

  if ARefresh and Assigned(FSellerDefault) then
    FreeAndNil(FSellerDefault);

  if not Assigned(FSellerDefault) then
    FSellerDefault := TRepositoryFactory.Make(TestConnection.Conn).Person.Show(FUser.seller_id);

  Result := FSellerDefault;
end;

function TLoggedInUser.Company(ARefresh: Boolean): TCompany;
begin
  if ARefresh and Assigned(FCompany) then
    FreeAndNil(FCompany);

  if not Assigned(FCompany) then
    FCompany := TRepositoryFactory.Make(TestConnection.Conn).Company.Show(1);

  // Configuração do Disparo de E-mail
  if IntBool(FCompany.send_email_app_default) then
  begin
    FCompany.send_email_email    := 'naoresponda@albsys.com.br';
    FCompany.send_email_user     := 'apikey';
    FCompany.send_email_password := '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';
    FCompany.send_email_smtp     := 'smtp.sendgrid.net';
    FCompany.send_email_port     := '587';
    FCompany.send_email_ssl      := 0;
    FCompany.send_email_tls      := 1;
  end;

  Result := FCompany;
end;

constructor TLoggedInUser.Create;
begin
  inherited Create;
end;


initialization
  LoggedInUser := TLoggedInUser.Create;
finalization
  FreeAndNil(LoggedInUser);

end.

