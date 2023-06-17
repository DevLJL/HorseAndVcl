unit uCostCenter.Filter;

interface

uses
  uFilter;

type
  ICostCenterFilter = Interface(IFilter)
    ['{30A69FC6-7823-4249-804E-A694077E16F1}']
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
