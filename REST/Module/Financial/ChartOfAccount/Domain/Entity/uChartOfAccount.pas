unit uChartOfAccount;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB;

type
  TChartOfAccount = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Fnote: string;
    Fflg_analytical: SmallInt;
    Fhierarchy_code: string;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;

    // OneToOne
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property hierarchy_code: string read Fhierarchy_code write Fhierarchy_code;
    property flg_analytical: SmallInt read Fflg_analytical write Fflg_analytical;
    property note: string read Fnote write Fnote;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    // OneToOne
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uApplication.Exception, uTrans;

{ TChartOfAccount }

constructor TChartOfAccount.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TChartOfAccount.Destroy;
begin
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;
  inherited;
end;

procedure TChartOfAccount.Initialize;
begin
  Fcreated_at          := now;
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
end;

function TChartOfAccount.Validate: String;
var
  LIsInserting: Boolean;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;

  if Fhierarchy_code.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Hierarquia') + #13;
end;

end.

