unit uAclRole.Filter;

interface

uses
  uFilter;

type
  IAclRoleFilter = Interface(IFilter)
    ['{D15117EE-C976-4621-B694-BC291FC440E0}']
  End;

  TAclRoleFilter = class(TFilter, IAclRoleFilter)
  public
    class function Make: IAclRoleFilter;
  end;

implementation

{ TAclRoleFilter }

class function TAclRoleFilter.Make: IAclRoleFilter;
begin
  Result := Self.Create;
end;

end.
