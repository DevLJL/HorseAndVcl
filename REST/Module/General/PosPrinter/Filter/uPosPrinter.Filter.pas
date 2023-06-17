unit uPosPrinter.Filter;

interface

uses
  uFilter;

type
  IPosPrinterFilter = Interface(IFilter)
    ['{FF9C929A-3DBF-441E-8D7C-A35FD2E3ADF0}']
  End;

  TPosPrinterFilter = class(TFilter, IPosPrinterFilter)
  public
    class function Make: IPosPrinterFilter;
  end;

implementation

{ TPosPrinterFilter }

class function TPosPrinterFilter.Make: IPosPrinterFilter;
begin
  Result := Self.Create;
end;

end.
