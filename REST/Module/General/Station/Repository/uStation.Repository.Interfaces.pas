unit uStation.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uStation;

type
  IStationRepository = interface(IBaseRepository)
    ['{4F705E00-D2A2-4568-AF45-39353B46D8FB}']
    function Show(AId: Int64): TStation;
  end;

implementation

end.


