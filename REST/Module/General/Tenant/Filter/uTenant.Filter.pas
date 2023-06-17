unit uTenant.Filter;

interface

uses
  uFilter;

type
  ITenantFilter = Interface(IFilter)
    ['{9B6C0E47-FEE9-4D6C-932A-3258FCDB5DC1}']
  End;

  TTenantFilter = class(TFilter, ITenantFilter)
  public
    class function Make: ITenantFilter;
  end;

implementation

{ TTenantFilter }

class function TTenantFilter.Make: ITenantFilter;
begin
  Result := Self.Create;
end;

end.
