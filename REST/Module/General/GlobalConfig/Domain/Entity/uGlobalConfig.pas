unit uGlobalConfig;

interface

uses
  {$IFDEF APPREST}
  uAppRest.Types,
  {$ENDIF}
  uAclUser,
  uBase.Entity,
  Data.DB;

type
  TGlobalConfig = class(TBaseEntity)
  private
    Fid: Int64;
    Fpdv_edit_item_before_register: SmallInt;
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
    property pdv_edit_item_before_register: SmallInt read Fpdv_edit_item_before_register write Fpdv_edit_item_before_register;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    // OneToOne
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    {$IFDEF APPREST}
    function Validate: String; override;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TGlobalConfig }

constructor TGlobalConfig.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TGlobalConfig.Destroy;
begin
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;
  inherited;
end;

procedure TGlobalConfig.Initialize;
begin
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
end;

{$IFDEF APPREST}
function TGlobalConfig.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);
end;
{$ENDIF}

end.
