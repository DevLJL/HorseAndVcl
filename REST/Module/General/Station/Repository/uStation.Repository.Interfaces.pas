unit uStation.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uStation;

type
  IStationRepository = interface(IBaseRepository)
    ['{FE7D968C-E357-4401-A9C4-29B09F4D3A67}']
    function Show(AId: Int64): TStation;
  end;

implementation

end.


