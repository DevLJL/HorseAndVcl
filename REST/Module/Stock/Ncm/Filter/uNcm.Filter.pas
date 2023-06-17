unit uNcm.Filter;

interface

uses
  uFilter;

type
  INcmFilter = Interface(IFilter)
    ['{535C4E96-3409-4591-9BD6-B3463E3783EF}']
  End;

  TNcmFilter = class(TFilter, INcmFilter)
  public
    class function Make: INcmFilter;
  end;

implementation

{ TNcmFilter }

class function TNcmFilter.Make: INcmFilter;
begin
  Result := Self.Create;
end;

end.
