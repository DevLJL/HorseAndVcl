unit uQueueEmail.Filter;

interface

uses
  uFilter;

type
  IQueueEmailFilter = Interface(IFilter)
    ['{0ACD7CD8-3320-403E-98E8-D27DAFB09769}']
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
