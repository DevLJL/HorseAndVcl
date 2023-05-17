unit uPerson.Filter;

interface

uses
  uFilter;

type
  IPersonFilter = Interface(IFilter)
    ['{4B1E4CCD-6713-4869-A482-90B10FF14353}']
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
