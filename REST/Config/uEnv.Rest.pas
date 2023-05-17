unit uEnv.Rest;

interface

uses
  SysUtils,
  IniFiles,
  uZLConnection.Types;

type
  TEnvRest = class(TIniFile)
  private
    FStationId: Integer;
    procedure SetDatabase(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetPort(const Value: String);
    procedure SetServer(const Value: String);
    procedure SetUserName(const Value: String);
    procedure SetVendorLib(const Value: String);
    function GetDatabase: String;
    function GetPassword: String;
    function GetPort: String;
    function GetServer: String;
    function GetUserName: String;
    function GetVendorLib: String;
    procedure SetDriver(const Value: String);
    function GetDriver: String;
    function GetDefaultConnLibType: TZLConnLibType;
    procedure SetDefaultConnLibType(const Value: TZLConnLibType);
    function GetDefaultRepoType: TZLRepositoryType;
    procedure SetDefaultRepoType(const Value: TZLRepositoryType);
    procedure SetStationId(const Value: Integer);
    function GetStationId: Integer;
    function GetLanguage: String;
    procedure SetLanguage(const Value: String);
  public
    property Database: String read GetDatabase write SetDatabase;
    property UserName: String read GetUserName write SetUserName;
    property Password: String read GetPassword write SetPassword;
    property Server: String read GetServer write SetServer;
    property Port: String read GetPort write SetPort;
    property VendorLib: String read GetVendorLib write SetVendorLib;
    property Driver: String read GetDriver write SetDriver;
    property DefaultConnLibType: TZLConnLibType read GetDefaultConnLibType write SetDefaultConnLibType;
    property DefaultRepoType: TZLRepositoryType read GetDefaultRepoType write SetDefaultRepoType;
    property StationId: Integer read GetStationId write SetStationId;
    function DriverDB: TZLDriverDB;
    property Language: String read GetLanguage write SetLanguage;
    procedure CreateFileIfNotExists;
    class function EnvName: String;
  end;

var
  ENV_REST: TEnvRest;
const
  ENV_REST_PRODUCTION = 'env_rest.ini';
  ENV_REST_TEST = 'env_rest_test.ini';
  SECTION_PREFIX = 'REST_';

implementation

{ TEnvRest }

procedure TEnvRest.CreateFileIfNotExists;
begin
  // Criar arquivo se não existir
  if not FileExists(EnvName) then
  begin
    SetDatabase('dbase');
    SetUserName('root');
    SetPassword('root');
    SetServer('localhost');
    SetPort('3151');
    SetVendorLib('libmysql.dll');
    SetDriver('MySQL');
    SetDefaultConnLibType(TZLConnLibType.ctFireDAC);
    SetDefaultRepoType(TZLRepositoryType.rtSQL);
    SetStationId(1);
    SetLanguage('PT-BR');
  end;
end;

function TEnvRest.DriverDB: TZLDriverDB;
var
  lDriverStr: String;
begin
  lDriverStr := GetDriver.Trim.ToUpper;
  if (lDriverStr = 'MYSQL') then
    Result := TZLDriverDB.ddMySql;
end;

class function TEnvRest.EnvName: String;
begin
  {$IFDEF DUNITX}
    Result := ENV_REST_TEST;
  {$ELSE}
    Result := ENV_REST_PRODUCTION;
  {$ENDIF}
end;

function TEnvRest.GetDatabase: String;
begin
  Result := ReadString(SECTION_PREFIX+'CONNECTION','DATABASE','');
end;

function TEnvRest.GetDefaultConnLibType: TZLConnLibType;
var
  lLibType: String;
begin
  lLibType := ReadString(SECTION_PREFIX+'CONNECTION','LIBTYPE','FIREDAC').Trim.ToUpper;
  if (lLibType = 'FIREDAC') then
    Result := TZLConnLibType.ctFireDAC;
end;

function TEnvRest.GetDefaultRepoType: TZLRepositoryType;
var
  lRepoTypeStr: String;
begin
  lRepoTypeStr := ReadString(SECTION_PREFIX+'CONNECTION','REPOTYPE','SQL').Trim.ToUpper;
  if (lRepoTypeStr = 'SQL') then
    Result := TZLRepositoryType.rtSQL;
end;

function TEnvRest.GetDriver: String;
begin
  Result := ReadString(SECTION_PREFIX+'CONNECTION','DRIVER','');
end;

function TEnvRest.GetLanguage: String;
begin
  Result := ReadString(SECTION_PREFIX+'RESOURCE','LANGUAGE','').ToUpper;
end;

function TEnvRest.GetPassword: String;
begin
  Result := ReadString(SECTION_PREFIX+'CONNECTION','PASSWORD','');
end;

function TEnvRest.GetPort: String;
begin
  Result := ReadString(SECTION_PREFIX+'CONNECTION','PORT','');
end;

function TEnvRest.GetServer: String;
begin
  Result := ReadString(SECTION_PREFIX+'CONNECTION','SERVER','');
end;

function TEnvRest.GetStationId: Integer;
begin
  Result := ReadInteger(SECTION_PREFIX+'GENERAL','STATION_ID',1);
end;

function TEnvRest.GetUserName: String;
begin
  Result := ReadString(SECTION_PREFIX+'CONNECTION','USERNAME','');
end;

function TEnvRest.GetVendorLib: String;
begin
  Result := ReadString(SECTION_PREFIX+'CONNECTION','VENDORLIB','');
end;

procedure TEnvRest.SetDatabase(const Value: String);
begin
  WriteString(SECTION_PREFIX+'CONNECTION','DATABASE',Value);
end;

procedure TEnvRest.SetDefaultConnLibType(const Value: TZLConnLibType);
begin
  case Value of
    ctFireDAC: WriteString(SECTION_PREFIX+'CONNECTION','LIBTYPE','FIREDAC');
  end;
end;

procedure TEnvRest.SetDefaultRepoType(const Value: TZLRepositoryType);
var
  lRepoTypeStr: String;
begin
  case Value of
    rtDefault, rtSQL: lRepoTypeStr := 'SQL';
    rtMemory:         lRepoTypeStr := 'MEMORY';
    rtORMBr:          lRepoTypeStr := 'ORMBR';
    rtAurelius:       lRepoTypeStr := 'AURELIUS';
  end;
  WriteString(SECTION_PREFIX+'CONNECTION','REPOTYPE', lRepoTypeStr);
end;

procedure TEnvRest.SetDriver(const Value: String);
begin
  WriteString(SECTION_PREFIX+'CONNECTION','DRIVER',Value);
end;

procedure TEnvRest.SetLanguage(const Value: String);
begin
  WriteString(SECTION_PREFIX+'RESOURCE','LANGUAGE',Value);
end;

procedure TEnvRest.SetPassword(const Value: String);
begin
  WriteString(SECTION_PREFIX+'CONNECTION','PASSWORD',Value);
end;

procedure TEnvRest.SetPort(const Value: String);
begin
  WriteString(SECTION_PREFIX+'CONNECTION','PORT',Value);
end;

procedure TEnvRest.SetServer(const Value: String);
begin
  WriteString(SECTION_PREFIX+'CONNECTION','SERVER',Value);
end;

procedure TEnvRest.SetStationId(const Value: Integer);
begin
  WriteInteger(SECTION_PREFIX+'GENERAL','STATION_ID',Value);
end;

procedure TEnvRest.SetUserName(const Value: String);
begin
  WriteString(SECTION_PREFIX+'CONNECTION','USERNAME',Value);
end;

procedure TEnvRest.SetVendorLib(const Value: String);
begin
  WriteString(SECTION_PREFIX+'CONNECTION','VENDORLIB',Value);
end;

initialization
  ENV_REST := TEnvRest.Create(ExtractFilePath(ParamStr(0)) + TEnvRest.EnvName);
  ENV_REST.CreateFileIfNotExists;

finalization
  FreeAndNil(ENV_REST);

end.

