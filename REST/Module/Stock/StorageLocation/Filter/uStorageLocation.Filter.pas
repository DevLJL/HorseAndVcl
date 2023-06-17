unit uStorageLocation.Filter;

interface

uses
  uFilter;

type
  IStorageLocationFilter = Interface(IFilter)
    ['{28DDBD01-9433-4928-A789-B6A7CF1C8C7B}']
  End;

  TStorageLocationFilter = class(TFilter, IStorageLocationFilter)
  public
    class function Make: IStorageLocationFilter;
  end;

implementation

{ TStorageLocationFilter }

class function TStorageLocationFilter.Make: IStorageLocationFilter;
begin
  Result := Self.Create;
end;

end.
