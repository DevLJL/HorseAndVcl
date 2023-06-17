unit uPriceList.Filter;

interface

uses
  uFilter;

type
  IPriceListFilter = Interface(IFilter)
    ['{DB56DB5B-FC44-45BF-9910-362D3C90C15D}']
  End;

  TPriceListFilter = class(TFilter, IPriceListFilter)
  public
    class function Make: IPriceListFilter;
  end;

implementation

{ TPriceListFilter }

class function TPriceListFilter.Make: IPriceListFilter;
begin
  Result := Self.Create;
end;

end.
