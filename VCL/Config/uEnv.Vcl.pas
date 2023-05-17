unit uEnv.Vcl;

interface

uses
  SysUtils,
  IniFiles,
  uZLConnection.Types;

type
  TENV_VCL = class(TIniFile)
  private
    procedure SetBaseURI(const Value: String);
    procedure SetLanguage(const Value: String);
    procedure SetLimitPerPage(const Value: Int64);
    procedure SetStationId(const Value: Int64);
    function  GetBaseURI: String;
    function  GetLanguage: String;
    function  GetLimitPerPage: Int64;
    function  GetStationId: Int64;
  public
    class function EnvName: String;
    procedure CreateFileIfNotExists;

    property  BaseURI: String read GetBaseURI write SetBaseURI;
    property  Language: String read GetLanguage write SetLanguage;
    property  LimitPerPage: Int64 read GetLimitPerPage write SetLimitPerPage;
    property  StationId: Int64 read GetStationId write SetStationId;
  end;

var
  ENV_VCL: TENV_VCL;
const
  ENV_VCL_PRODUCTION = 'env_vcl.ini';
  ENV_VCL_TEST = 'env_vcl_test.ini';
  SECTION_PREFIX = 'VCL_';

implementation

{ TENV_VCL }

procedure TENV_VCL.CreateFileIfNotExists;
begin
  // Criar arquivo se não existir
  if not FileExists(EnvName) then
  begin
    SetBaseURI('http://localhost:9123/api/v1');
    SetLanguage('PT-BR');
  end;
end;

class function TENV_VCL.EnvName: String;
begin
  {$IFDEF DUNITX}
    Result := ENV_VCL_TEST;
  {$ELSE}
    Result := ENV_VCL_PRODUCTION;
  {$ENDIF}
end;

function TENV_VCL.GetLanguage: String;
begin
  Result := ReadString(SECTION_PREFIX+'RESOURCE','LANGUAGE','').ToUpper;
end;

function TENV_VCL.GetLimitPerPage: Int64;
begin
  Result := ReadInt64(SECTION_PREFIX+'GENERAL','LIMIT_PER_PAGE', 50);
end;

function TENV_VCL.GetStationId: Int64;
begin
  Result := ReadInt64(SECTION_PREFIX+'GENERAL','STATION_ID', 50);
end;

function TENV_VCL.GetBaseURI: String;
begin
  Result := ReadString(SECTION_PREFIX+'GENERAL','BASE_URI','');
end;

procedure TENV_VCL.SetLanguage(const Value: String);
begin
  WriteString(SECTION_PREFIX+'RESOURCE','LANGUAGE',Value);
end;

procedure TENV_VCL.SetLimitPerPage(const Value: Int64);
begin
  WriteInt64(SECTION_PREFIX+'GENERAL','LIMIT_PER_PAGE',Value);
end;

procedure TENV_VCL.SetStationId(const Value: Int64);
begin
  WriteInt64(SECTION_PREFIX+'GENERAL','STATION_ID',Value);
end;

procedure TENV_VCL.SetBaseURI(const Value: String);
begin
  WriteString(SECTION_PREFIX+'GENERAL','BASE_URI',Value);
end;

initialization
  ENV_VCL := TENV_VCL.Create(ExtractFilePath(ParamStr(0)) + TENV_VCL.EnvName);
  ENV_VCL.CreateFileIfNotExists;

finalization
  FreeAndNil(ENV_VCL);

end.

