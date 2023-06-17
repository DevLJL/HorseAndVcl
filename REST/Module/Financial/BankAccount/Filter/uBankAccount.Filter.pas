unit uBankAccount.Filter;

interface

uses
  uFilter;

type
  IBankAccountFilter = Interface(IFilter)
    ['{B9797535-C772-4F92-ACF6-CA4D5F44ACCA}']
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
