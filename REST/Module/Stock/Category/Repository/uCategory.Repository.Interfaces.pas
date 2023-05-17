unit uCategory.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uCategory;

type
  ICategoryRepository = interface(IBaseRepository)
    ['{16B53308-5854-4627-A71F-C994D3E0D21A}']
    function Show(AId: Int64): TCategory;
  end;

implementation

end.


