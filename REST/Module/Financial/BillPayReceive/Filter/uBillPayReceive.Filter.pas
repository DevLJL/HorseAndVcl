unit uBillPayReceive.Filter;

interface

uses
  uFilter;

type
  IBillPayReceiveFilter = Interface(IFilter)
    ['{4858A049-8973-45D5-A5B9-FAAB977B3182}']
  End;

  TBillPayReceiveFilter = class(TFilter, IBillPayReceiveFilter)
  public
    class function Make: IBillPayReceiveFilter;
  end;

implementation

{ TBillPayReceiveFilter }

class function TBillPayReceiveFilter.Make: IBillPayReceiveFilter;
begin
  Result := Self.Create;
end;

end.
