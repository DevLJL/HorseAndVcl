unit uPerson.Filter;

interface

uses
  uFilter;

type
  IPersonFilter = Interface(IFilter)
    ['{A7DE6EAC-554F-4534-8254-5DA8B3C93210}']
  End;

  TPersonFilter = class(TFilter, IPersonFilter)
  public
    class function Make: IPersonFilter;
  end;

implementation

{ TPersonFilter }

class function TPersonFilter.Make: IPersonFilter;
begin
  Result := Self.Create;
end;

end.
