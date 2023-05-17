unit uBillPayReceive.Filter;

interface

uses
  uFilter;

type
  IBillPayReceiveFilter = Interface(IFilter)
    ['{AFA71D35-9CE7-49DC-A79C-2A293B5FD47B}']
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
