unit uChartOfAccount.Filter;

interface

uses
  uFilter;

type
  IChartOfAccountFilter = Interface(IFilter)
    ['{88C6925C-1606-4828-A397-2F7241787D28}']
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
