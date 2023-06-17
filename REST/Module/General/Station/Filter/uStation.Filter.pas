unit uStation.Filter;

interface

uses
  uFilter;

type
  IStationFilter = Interface(IFilter)
    ['{F301806A-B86D-4EAB-A3CC-E6D6B0029C5B}']
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
