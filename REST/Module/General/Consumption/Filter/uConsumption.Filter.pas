unit uConsumption.Filter;

interface

uses
  uFilter;

type
  IConsumptionFilter = Interface(IFilter)
    ['{91DD2FEF-A42C-4165-BCBA-C89754B1964D}']
  End;

  TConsumptionFilter = class(TFilter, IConsumptionFilter)
  public
    class function Make: IConsumptionFilter;
  end;

implementation

{ TConsumptionFilter }

class function TConsumptionFilter.Make: IConsumptionFilter;
begin
  Result := Self.Create;
end;

end.
