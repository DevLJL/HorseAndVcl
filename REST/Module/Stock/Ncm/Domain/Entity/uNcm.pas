unit uNcm;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB;

type
  TNcm = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;

    // OneToOne
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;
    Fnational_rate: Double;
    Fcode: String;
    Fstate_rate: Double;
    Fcest: String;
    Fadditional_information: String;
    Fstart_of_validity: TDate;
    Fimported_rate: Double;
    Fmunicipal_rate: Double;
    Fend_of_validity: TDate;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property code: String read Fcode write Fcode;
    property national_rate: Double read Fnational_rate write Fnational_rate;
    property imported_rate: Double read Fimported_rate write Fimported_rate;
    property state_rate: Double read Fstate_rate write Fstate_rate;
    property municipal_rate: Double read Fmunicipal_rate write Fmunicipal_rate;
    property cest: String read Fcest write Fcest;
    property additional_information: String read Fadditional_information write Fadditional_information;
    property start_of_validity: TDate read Fstart_of_validity write Fstart_of_validity;
    property end_of_validity: TDate read Fend_of_validity write Fend_of_validity;
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

{ TNcm }

constructor TNcm.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TNcm.Destroy;
begin
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;
  inherited;
end;

procedure TNcm.Initialize;
begin
  Fcreated_at          := now;
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
end;

function TNcm.Validate: String;
var
  LIsInserting: Boolean;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Descrição') + #13;

  if Fcode.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('NCM [Código]') + #13;
end;

end.

