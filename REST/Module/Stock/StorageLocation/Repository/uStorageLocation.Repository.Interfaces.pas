unit uStorageLocation.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uStorageLocation;

type
  IStorageLocationRepository = interface(IBaseRepository)
    ['{1DEB945A-88F0-46D4-981B-4768F62E7958}']
    function Show(AId: Int64): TStorageLocation;
  end;

implementation

end.


