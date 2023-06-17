unit uQueueEmail.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uQueueEmail;

type
  IQueueEmailRepository = interface(IBaseRepository)
    ['{C7F453C4-F165-4094-B13C-E7C97F696DFD}']
    function Show(AId: Int64): TQueueEmail;
  end;

implementation

end.


