unit uBrand.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uBrand;

type
  IBrandRepository = interface(IBaseRepository)
    ['{42522BDC-131B-47F4-9E68-32E0FD9EE90D}']
    function Show(AId: Int64): TBrand;
  end;

implementation

end.


