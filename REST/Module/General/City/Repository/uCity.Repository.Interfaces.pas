unit uCity.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uCity;

type
  ICityRepository = interface(IBaseRepository)
    ['{62497ED6-3983-4909-A813-314A47FF92B3}']
    function Show(AId: Int64): TCity;
  end;

implementation

end.


