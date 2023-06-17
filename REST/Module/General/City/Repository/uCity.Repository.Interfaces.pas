unit uCity.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uCity;

type
  ICityRepository = interface(IBaseRepository)
    ['{DE47FFE9-F37F-4B5E-9247-3C0F365F66C7}']
    function Show(AId: Int64): TCity;
  end;

implementation

end.


