unit uCategory.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uCategory;

type
  ICategoryRepository = interface(IBaseRepository)
    ['{12ACDE75-07A3-4953-98DD-A3F2EB04DD5F}']
    function Show(AId: Int64): TCategory;
  end;

implementation

end.


