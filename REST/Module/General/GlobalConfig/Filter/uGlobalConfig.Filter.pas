unit uGlobalConfig.Filter;

interface

uses
  uFilter;

type
  IGlobalConfigFilter = Interface(IFilter)
    ['{391A6BDA-FDB0-424F-9131-C7F389D6081C}']
  End;

  TGlobalConfigFilter = class(TFilter, IGlobalConfigFilter)
  public
    class function Make: IGlobalConfigFilter;
  end;

implementation

{ TGlobalConfigFilter }

class function TGlobalConfigFilter.Make: IGlobalConfigFilter;
begin
  Result := Self.Create;
end;

end.
