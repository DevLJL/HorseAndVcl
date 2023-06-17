unit uAdditional.Filter;

interface

uses
  uFilter;

type
  IAdditionalFilter = Interface(IFilter)
    ['{BB991DDD-3AF2-44CA-ADA0-09C513549792}']
  End;

  TAdditionalFilter = class(TFilter, IAdditionalFilter)
  public
    class function Make: IAdditionalFilter;
  end;

implementation

{ TAdditionalFilter }

class function TAdditionalFilter.Make: IAdditionalFilter;
begin
  Result := Self.Create;
end;

end.
