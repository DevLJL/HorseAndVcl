unit uAclUser.Filter;

interface

uses
  uFilter;

type
  IAclUserFilter = Interface(IFilter)
    ['{15BEAE59-41D4-408F-89D1-EFD4F918E063}']
  End;

  TAclUserFilter = class(TFilter, IAclUserFilter)
  public
    class function Make: IAclUserFilter;
  end;

implementation

{ TAclUserFilter }

class function TAclUserFilter.Make: IAclUserFilter;
begin
  Result := Self.Create;
end;

end.
