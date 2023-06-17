unit uBrand.Filter;

interface

uses
  uFilter;

type
  IBrandFilter = Interface(IFilter)
    ['{FE3F03C4-2CA5-4DF2-82F7-45C71FA9E9B1}']
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
