unit uCostCenter.Filter;

interface

uses
  uFilter;

type
  ICostCenterFilter = Interface(IFilter)
    ['{6DFD1CFC-3798-4C59-8AE4-A71390E89CF3}']
  End;

  TCostCenterFilter = class(TFilter, ICostCenterFilter)
  public
    class function Make: ICostCenterFilter;
  end;

implementation

{ TCostCenterFilter }

class function TCostCenterFilter.Make: ICostCenterFilter;
begin
  Result := Self.Create;
end;

end.
