unit uAclRole;

interface

uses
  uBase.Entity,
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
  end;

implementation

end.
