unit uSale.Filter;

interface

uses
  uFilter;

type
  ISaleFilter = Interface(IFilter)
    ['{F8EADB55-305C-4229-92E4-95375873F682}']
  End;

  TSaleFilter = class(TFilter, ISaleFilter)
  public
    class function Make: ISaleFilter;
  end;

implementation

{ TSaleFilter }

class function TSaleFilter.Make: ISaleFilter;
begin
  Result := Self.Create;
end;

end.
