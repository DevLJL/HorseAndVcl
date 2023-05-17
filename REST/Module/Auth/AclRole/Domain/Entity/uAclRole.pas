unit uAclRole;

interface

uses
  uAppRest.Types,
  uBase.Entity,
  System.Generics.Collections,
  uAclRole.Types;

type
  TAclRole = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Fgeneral_search_method: TAclRoleGeneralSearchMethod;
  public
    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property general_search_method: TAclRoleGeneralSearchMethod read Fgeneral_search_method write Fgeneral_search_method;
    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uTrans;

function TAclRole.Validate: String;
begin
  Result := EmptyStr;
  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('name') + #13;
end;

end.
