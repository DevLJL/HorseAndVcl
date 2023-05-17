unit uBankAccount.Filter;

interface

uses
  uFilter;

type
  IBankAccountFilter = Interface(IFilter)
    ['{B3F7F9C8-5BBB-447F-8EB4-573065D1854C}']
  End;

  TBankAccountFilter = class(TFilter, IBankAccountFilter)
  public
    class function Make: IBankAccountFilter;
  end;

implementation

{ TBankAccountFilter }

class function TBankAccountFilter.Make: IBankAccountFilter;
begin
  Result := Self.Create;
end;

end.
