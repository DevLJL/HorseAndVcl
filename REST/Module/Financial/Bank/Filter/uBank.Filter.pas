unit uBank.Filter;

interface

uses
  uFilter;

type
  IBankFilter = Interface(IFilter)
    ['{D0BE1371-4858-4E5A-A16F-7F7F40401563}']
  End;

  TBankFilter = class(TFilter, IBankFilter)
  public
    class function Make: IBankFilter;
  end;

implementation

{ TBankFilter }

class function TBankFilter.Make: IBankFilter;
begin
  Result := Self.Create;
end;

end.
