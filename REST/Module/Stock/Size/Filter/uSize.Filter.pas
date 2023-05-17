unit uSize.Filter;

interface

uses
  uFilter;

type
  ISizeFilter = Interface(IFilter)
    ['{F27F05B9-11E9-47AA-923D-3D494D14E070}']
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
