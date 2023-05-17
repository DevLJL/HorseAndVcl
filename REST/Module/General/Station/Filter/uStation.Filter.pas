unit uStation.Filter;

interface

uses
  uFilter;

type
  IStationFilter = Interface(IFilter)
    ['{F9B0AEB1-339B-4AF7-BB22-B261B7302EE1}']
  End;

  TStationFilter = class(TFilter, IStationFilter)
  public
    class function Make: IStationFilter;
  end;

implementation

{ TStationFilter }

class function TStationFilter.Make: IStationFilter;
begin
  Result := Self.Create;
end;

end.
