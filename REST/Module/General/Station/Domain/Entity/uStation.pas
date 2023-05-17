unit uStation;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB;

type
  TStation = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uApplication.Exception,
  uTrans;

{ TStation }

constructor TStation.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TStation.Destroy;
begin
  inherited;
end;

procedure TStation.Initialize;
begin
end;

function TStation.Validate: String;
var
  LIsInserting: Boolean;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

end.
