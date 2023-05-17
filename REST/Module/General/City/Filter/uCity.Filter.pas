unit uCity.Filter;

interface

uses
  uFilter;

type
  ICityFilter = Interface(IFilter)
    ['{E1862647-20DB-46A7-83D4-B0050D4DB4E9}']
  End;

  TCityFilter = class(TFilter, ICityFilter)
  public
    class function Make: ICityFilter;
  end;

implementation

{ TCityFilter }

class function TCityFilter.Make: ICityFilter;
begin
  Result := Self.Create;
end;

end.
