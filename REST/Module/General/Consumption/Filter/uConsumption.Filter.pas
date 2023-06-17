unit uConsumption.Filter;

interface

uses
  uFilter;

type
  IConsumptionFilter = Interface(IFilter)
    ['{1CE61872-4155-4ACC-A1D5-5B62ADD08DE9}']
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
