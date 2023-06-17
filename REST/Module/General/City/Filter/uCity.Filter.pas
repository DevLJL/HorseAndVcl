unit uCity.Filter;

interface

uses
  uFilter;

type
  ICityFilter = Interface(IFilter)
    ['{F16816CD-2464-4921-AB05-3930FFEBA9C0}']
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
