unit uEnv.Vcl;

interface

uses
  SysUtils,
  IniFiles,
  uZLConnection.Types;

type
  {$SCOPEDENUMS ON}
  TPdvTicketOption = (NoPrint, Print, Optional);
  TENV_VCL = class(TIniFile)
  private
    // SETS
    procedure SetBaseURI(const Value: String);
    procedure SetLanguage(const Value: String);
    procedure SetLimitPerPage(const Value: Int64);
    procedure SetStationId(const Value: Int64);
    procedure SetPosPrinterIdDefault(const Value: Int64);
    procedure SetPosPrinterURI(const Value: String);
    procedure SetPdvTicketOption(const Value: TPdvTicketOption);
    procedure SetPdvTicketCopies(const Value: SmallInt);
    // GETS
    function GetBaseURI: String;
    function GetLanguage: String;
    function GetLimitPerPage: Int64;
    function GetStationId: Int64;
    function GetPosPrinterIdDefault: Int64;
    function GetPosPrinterURI: String;
    function GetPdvTicketOption: TPdvTicketOption;
    function GetPdvTicketCopies: SmallInt;
  public
    class function EnvName: String;
    procedure CreateFileIfNotExists;

    property  BaseURI: String read GetBaseURI write SetBaseURI;
    property  Language: String read GetLanguage write SetLanguage;
    property  LimitPerPage: Int64 read GetLimitPerPage write SetLimitPerPage;
    property  StationId: Int64 read GetStationId write SetStationId;
    property  PosPrinterIdDefault: Int64 read GetPosPrinterIdDefault write SetPosPrinterIdDefault;
    property  PosPrinterURI: String read GetPosPrinterURI write SetPosPrinterURI;
    property  PdvTicketOption: TPdvTicketOption read GetPdvTicketOption write SetPdvTicketOption;
    property  PdvTicketCopies: SmallInt read GetPdvTicketCopies write SetPdvTicketCopies;
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
    SetLimitPerPage(150);
    SetStationId(1);
    SetPosPrinterIdDefault(1);
    SetPdvTicketOption(TPdvTicketOption.NoPrint);
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

function TENV_VCL.GetPosPrinterURI: String;
begin
  Result := ReadString(SECTION_PREFIX+'GENERAL','POS_PRINTER_URI', '');
  if Result.Trim.IsEmpty then
    Result := GetBaseURI;
end;

function TENV_VCL.GetStationId: Int64;
begin
  Result := ReadInt64(SECTION_PREFIX+'GENERAL','STATION_ID', 1);
end;

function TENV_VCL.GetBaseURI: String;
begin
  Result := ReadString(SECTION_PREFIX+'GENERAL','BASE_URI','');
end;

function TENV_VCL.GetPdvTicketCopies: SmallInt;
begin
  Result := ReadInteger(SECTION_PREFIX+'GENERAL','PDV_TICKET_COPIES',1);
end;

function TENV_VCL.GetPdvTicketOption: TPdvTicketOption;
begin
  Result := TPdvTicketOption(ReadInteger(SECTION_PREFIX+'GENERAL','PDV_TICKET_OPTION',0));
end;

function TENV_VCL.GetPosPrinterIdDefault: Int64;
begin
  Result := ReadInteger(SECTION_PREFIX+'GENERAL','POS_PRINTER_ID_DEFAULT',0);
end;

procedure TENV_VCL.SetLanguage(const Value: String);
begin
  WriteString(SECTION_PREFIX+'RESOURCE','LANGUAGE',Value);
end;

procedure TENV_VCL.SetLimitPerPage(const Value: Int64);
begin
  WriteInt64(SECTION_PREFIX+'GENERAL','LIMIT_PER_PAGE',Value);
end;

procedure TENV_VCL.SetPosPrinterURI(const Value: String);
begin
  WriteString(SECTION_PREFIX+'GENERAL','POS_PRINTER_URI',Value);
end;

procedure TENV_VCL.SetStationId(const Value: Int64);
begin
  WriteInt64(SECTION_PREFIX+'GENERAL','STATION_ID',Value);
end;

procedure TENV_VCL.SetBaseURI(const Value: String);
begin
  WriteString(SECTION_PREFIX+'GENERAL','BASE_URI',Value);
end;

procedure TENV_VCL.SetPdvTicketCopies(const Value: SmallInt);
begin
  WriteInteger(SECTION_PREFIX+'GENERAL','PDV_TICKET_COPIES',Value);
end;

procedure TENV_VCL.SetPdvTicketOption(const Value: TPdvTicketOption);
begin
  WriteInteger(SECTION_PREFIX+'GENERAL','PDV_TICKET_OPTION',Ord(Value));
end;

procedure TENV_VCL.SetPosPrinterIdDefault(const Value: Int64);
begin
  WriteInteger(SECTION_PREFIX+'GENERAL','POS_PRINTER_ID_DEFAULT',Value);
end;

initialization
  ENV_VCL := TENV_VCL.Create(ExtractFilePath(ParamStr(0)) + TENV_VCL.EnvName);
  ENV_VCL.CreateFileIfNotExists;

finalization
  FreeAndNil(ENV_VCL);

end.

