unit uAclUser.Filter;

interface

uses
  uFilter;

type
  IAclUserFilter = Interface(IFilter)
    ['{9315E53A-D23D-4E71-B3EC-9DA3F65C8BDF}']
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
