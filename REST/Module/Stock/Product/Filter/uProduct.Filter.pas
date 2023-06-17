unit uProduct.Filter;

interface

uses
  uFilter;

type
  IProductFilter = Interface(IFilter)
    ['{748B93C2-C2D1-404E-B704-0F6ADA4999D9}']
  End;

  TProductFilter = class(TFilter, IProductFilter)
  public
    class function Make: IProductFilter;
  end;

implementation

{ TProductFilter }

class function TProductFilter.Make: IProductFilter;
begin
  Result := Self.Create;
end;

end.
