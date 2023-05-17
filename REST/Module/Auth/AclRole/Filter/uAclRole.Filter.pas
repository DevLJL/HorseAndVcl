unit uAclRole.Filter;

interface

uses
  uFilter;

type
  IAclRoleFilter = Interface(IFilter)
    ['{A6B6FF9D-8E61-4BC4-AB5F-22F8344099AB}']
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
