﻿unit uCity;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB;

type
  TCity = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Fstate: string;
    Fcountry: string;
    Fibge_code: string;
    Fcountry_ibge_code: string;
    Fidentification: string;
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
    property state: string read Fstate write Fstate;
    property country: string read Fcountry write Fcountry;
    property ibge_code: string read Fibge_code write Fibge_code;
    property country_ibge_code: string read Fcountry_ibge_code write Fcountry_ibge_code;
    property identification: string read Fidentification write Fidentification;
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
  uEntityValidation.Exception,
  uTrans;

{ TCity }

constructor TCity.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TCity.Destroy;
begin
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;
  inherited;
end;

procedure TCity.Initialize;
begin
  Fcreated_at          := now;
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
end;

function TCity.Validate: String;
var
  LIsInserting: Boolean;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;

  if Fstate.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('UF') + #13;

  if Fcountry.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Pa�s') + #13;

  if Fibge_code.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Cód IBGE da Cidade') + #13;

  if Fcountry_ibge_code.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Cód IBGE do Pa�s') + #13;
end;

end.

