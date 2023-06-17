unit uBank.Filter;

interface

uses
  uFilter;

type
  IBankFilter = Interface(IFilter)
    ['{9A63C25B-3C39-4833-AD64-2C2E32A088D9}']
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
