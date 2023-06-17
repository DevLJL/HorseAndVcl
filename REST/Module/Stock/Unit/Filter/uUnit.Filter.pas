unit uUnit.Filter;

interface

uses
  uFilter;

type
  IUnitFilter = Interface(IFilter)
    ['{3A78DC49-617D-4FB9-B23E-0F3ADF5300A9}']
  End;

  TUnitFilter = class(TFilter, IUnitFilter)
  public
    class function Make: IUnitFilter;
  end;

implementation

{ TUnitFilter }

class function TUnitFilter.Make: IUnitFilter;
begin
  Result := Self.Create;
end;

end.
