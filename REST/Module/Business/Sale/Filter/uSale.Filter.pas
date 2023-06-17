unit uSale.Filter;

interface

uses
  uFilter;

type
  ISaleFilter = Interface(IFilter)
    ['{89A0C098-8503-41F7-9AC5-ABAC27C738D6}']
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
