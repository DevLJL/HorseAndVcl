unit uCompany.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uCompany;

type
  ICompanyRepository = interface(IBaseRepository)
    ['{EDD4F686-DB2F-42AB-91F0-B57D0CA65702}']
    function Show(AId: Int64): TCompany;
  end;

implementation

end.


