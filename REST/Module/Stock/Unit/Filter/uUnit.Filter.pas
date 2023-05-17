unit uUnit.Filter;

interface

uses
  uFilter;

type
  IUnitFilter = Interface(IFilter)
    ['{72709D2D-21EC-4EB2-B085-3CEF18E45F11}']
  End;

  TUnitFilter = class(TFilter, IUnitFilter)
  public
    class function Make: IUnitFilter;
  end;

implementation

{ TUnitFilter }

class function TUnitFilter.Make: IUnitFilter;
begin
  Result := Self.Create;
end;

end.
