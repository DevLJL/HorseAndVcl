unit uQueueEmail.Filter;

interface

uses
  uFilter;

type
  IQueueEmailFilter = Interface(IFilter)
    ['{01F21979-25F0-41E9-9D03-67E0C346C329}']
  End;

  TQueueEmailFilter = class(TFilter, IQueueEmailFilter)
  public
    class function Make: IQueueEmailFilter;
  end;

implementation

{ TQueueEmailFilter }

class function TQueueEmailFilter.Make: IQueueEmailFilter;
begin
  Result := Self.Create;
end;

end.
