unit uStorageLocation.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uStorageLocation;

type
  IStorageLocationRepository = interface(IBaseRepository)
    ['{3F033149-DAC1-4682-A0A3-3C08F2DC420C}']
    function Show(AId: Int64): TStorageLocation;
  end;

implementation

end.


