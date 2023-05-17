unit uCategory.Filter;

interface

uses
  uFilter;

type
  ICategoryFilter = Interface(IFilter)
    ['{8A236BB6-FC7D-405E-9049-6DCEBF03744D}']
  End;

  TCategoryFilter = class(TFilter, ICategoryFilter)
  public
    class function Make: ICategoryFilter;
  end;

implementation

{ TCategoryFilter }

class function TCategoryFilter.Make: ICategoryFilter;
begin
  Result := Self.Create;
end;

end.
