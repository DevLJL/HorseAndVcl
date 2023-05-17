unit uBrand.Filter;

interface

uses
  uFilter;

type
  IBrandFilter = Interface(IFilter)
    ['{0ACD7CD8-3320-403E-98E8-D27DAFB09769}']
  End;

  TBrandFilter = class(TFilter, IBrandFilter)
  public
    class function Make: IBrandFilter;
  end;

implementation

{ TBrandFilter }

class function TBrandFilter.Make: IBrandFilter;
begin
  Result := Self.Create;
end;

end.
