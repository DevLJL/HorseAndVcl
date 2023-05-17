unit uCompany.Filter;

interface

uses
  uFilter;

type
  ICompanyFilter = Interface(IFilter)
    ['{FE563C61-6FE3-4913-8956-025B8926AE09}']
  End;

  TCompanyFilter = class(TFilter, ICompanyFilter)
  public
    class function Make: ICompanyFilter;
  end;

implementation

{ TCompanyFilter }

class function TCompanyFilter.Make: ICompanyFilter;
begin
  Result := Self.Create;
end;

end.
