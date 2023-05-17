unit uStorageLocation.Filter;

interface

uses
  uFilter;

type
  IStorageLocationFilter = Interface(IFilter)
    ['{3280A23B-E4FF-446E-8F0F-E1572F74043E}']
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
