unit uCategory.Filter;

interface

uses
  uFilter;

type
  ICategoryFilter = Interface(IFilter)
    ['{C7B98FE9-7024-4DE2-8C49-36C543D60947}']
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
