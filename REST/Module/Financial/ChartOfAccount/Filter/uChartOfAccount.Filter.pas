unit uChartOfAccount.Filter;

interface

uses
  uFilter;

type
  IChartOfAccountFilter = Interface(IFilter)
    ['{586201E5-13F6-4F58-B50E-13AD5C7B74A7}']
  End;

  TChartOfAccountFilter = class(TFilter, IChartOfAccountFilter)
  public
    class function Make: IChartOfAccountFilter;
  end;

implementation

{ TChartOfAccountFilter }

class function TChartOfAccountFilter.Make: IChartOfAccountFilter;
begin
  Result := Self.Create;
end;

end.
