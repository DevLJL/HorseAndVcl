unit uPayment.Filter;

interface

uses
  uFilter;

type
  IPaymentFilter = Interface(IFilter)
    ['{7D2AC545-483F-4812-806C-CC3B23BE796B}']
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
