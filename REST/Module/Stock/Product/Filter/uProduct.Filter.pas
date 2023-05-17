unit uProduct.Filter;

interface

uses
  uFilter;

type
  IProductFilter = Interface(IFilter)
    ['{59367E8E-5E56-44EA-8891-9CFDA13CD550}']
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
