unit uPayment.Filter;

interface

uses
  uFilter;

type
  IPaymentFilter = Interface(IFilter)
    ['{2CB9F3B0-3B26-40C9-84BF-DCBDC7CB0A85}']
  End;

  TPaymentFilter = class(TFilter, IPaymentFilter)
  public
    class function Make: IPaymentFilter;
  end;

implementation

{ TPaymentFilter }

class function TPaymentFilter.Make: IPaymentFilter;
begin
  Result := Self.Create;
end;

end.
