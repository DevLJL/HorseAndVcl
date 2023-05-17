unit uBrand.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uBrand;

type
  IBrandRepository = interface(IBaseRepository)
    ['{D988894A-6C51-4AC9-90E1-797F31D22D90}']
    function Show(AId: Int64): TBrand;
  end;

implementation

end.


