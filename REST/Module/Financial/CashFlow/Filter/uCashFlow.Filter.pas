unit uCashFlow.Filter;

interface

uses
  uFilter;

type
  ICashFlowFilter = Interface(IFilter)
    ['{38B24D5E-E677-408E-9353-643DF949C5CA}']
  End;

  TCashFlowFilter = class(TFilter, ICashFlowFilter)
  public
    class function Make: ICashFlowFilter;
  end;

implementation

{ TCashFlowFilter }

class function TCashFlowFilter.Make: ICashFlowFilter;
begin
  Result := Self.Create;
end;

end.
