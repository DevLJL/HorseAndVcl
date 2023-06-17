unit uSize.Filter;

interface

uses
  uFilter;

type
  ISizeFilter = Interface(IFilter)
    ['{9340AACC-5894-4E0D-A656-3B62B0C01BF1}']
  End;

  TSizeFilter = class(TFilter, ISizeFilter)
  public
    class function Make: ISizeFilter;
  end;

implementation

{ TSizeFilter }

class function TSizeFilter.Make: ISizeFilter;
begin
  Result := Self.Create;
end;

end.
