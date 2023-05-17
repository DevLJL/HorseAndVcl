unit uCashFlow.Filter;

interface

uses
  uFilter;

type
  ICashFlowFilter = Interface(IFilter)
    ['{FC7D8908-F296-4367-AAC0-3ABE1AEDE45A}']
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
