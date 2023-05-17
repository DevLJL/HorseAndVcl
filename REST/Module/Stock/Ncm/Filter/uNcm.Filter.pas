unit uNcm.Filter;

interface

uses
  uFilter;

type
  INcmFilter = Interface(IFilter)
    ['{5DD9A01B-9744-4CDA-A72B-7561A3343CA1}']
  End;

  TNcmFilter = class(TFilter, INcmFilter)
  public
    class function Make: INcmFilter;
  end;

implementation

{ TNcmFilter }

class function TNcmFilter.Make: INcmFilter;
begin
  Result := Self.Create;
end;

end.
